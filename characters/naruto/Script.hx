// Script.hx for Naruto
// Ported from SSF2 NarutoExt.as
// Template reference: Fraymakers character-template

// ── Base template (from character-template/Script.hx) ────────────────────────
// API Script


var neutralSpecialProjectile = self.makeObject(null); // Tracks active Neutral Special projectile (in case we need to handle any special cases)

var lastDisabledNSpecStatusEffect = self.makeObject(null);

var downSpecialLoopCheckTimer = self.makeInt(-1);

var clutchReversalTimer = self.makeInt(-1); // tracks the latest
var clutchButtonHeld = self.makeBool(false); // Check if the clutch button is held current frame
var clutchButtonWasHeld = self.makeBool(false); // Check if the clutch button was held prev. frame

//offset projectile start position
var NSPEC_PROJ_X_OFFSET = 40;
var NSPEC_PROJ_Y_OFFSET = -50;

var NEUTRAL_SPECIAL_COOLDOWN = 60;

// start general functions --- 

//Runs on object init
function initialize(){
    self.addEventListener(GameObjectEvent.LINK_FRAMES, handleLinkFrames, {persistent:true});
}

function update(){
}

// Runs when reading inputs (before determining character state, update, framescript, etc.)
function inputUpdateHook(pressedControls:ControlsObject, heldControls:ControlsObject) {
    // This also runs when updating the buffer, below code should only be run on input tick
	if (self.isFirstInputUpdate()) {
        clutchButtonWasHeld.set(clutchButtonHeld.get());
		clutchButtonHeld.set(heldControls.SHIELD2);
	}

    // This runs when reading the buffer and on input tick -
	// Disable SHIELD2 input so engine will not see the shield2 input for shield/airdash
    //
    // self.getHeldControls().SHIELD2 will be false too
    // so must use clutchButtonHeld to check for clutch input
	pressedControls.SHIELD2 = false;
	heldControls.SHIELD2 = false;
}

// CState-based handling for LINK_FRAMES
// needed to ensure important code that would be skipped during the transition is still executed
function handleLinkFrames(e){
	if(self.inState(CState.SPECIAL_SIDE)){
		if(self.getCurrentFrame() >= 14){
			self.updateAnimationStats({bodyStatus:BodyStatus.NONE});
		}
	} else if(self.inState(CState.SPECIAL_DOWN)){
        specialDown_resetTimer();
        downSpecialLoopCheckTimer.set(self.addTimer(1, -1, specialDown_checkLoop));    
    }
}

function onTeardown() {
	
}

// --- end general functions

// Clutch Reversal logic

// Starting to hold button means not held previous frame, but held current frame
function startedHoldingClutch() {
    return !clutchButtonWasHeld.get() && clutchButtonHeld.get();
}

// Allow clutch reversal for the current animation (or until disabled)
function enableClutchReversal() {
    // remove any clutch checks if already being done in this animation
    disableClutchReversal();

    // On frame enabled, check if started holding current frame. If yes, then apply reversal and don't add the timer
    if (startedHoldingClutch()) {
        applyClutchReversal();
        return;
    }

    // timer that waits until startedHoldingClutch is true, then runs applyClutchReversal
    var timer = self.addTimer(0, -1, applyClutchReversal, {condition: startedHoldingClutch});
    clutchReversalTimer.set(timer);
}

// Disable clutch reversal for the current move 
function disableClutchReversal() {
    self.removeTimer(clutchReversalTimer.get());
    clutchReversalTimer.set(-1);
}

// Reverse momentum if clutch pressed (and enabled for current move)
function applyClutchReversal() {
    self.flip();
    self.setXVelocity(-1 * self.getXVelocity());

    AudioClip.play(self.getResource().getContent("downspecial"));
    
    // disable clutch for the rest of this animation (so no double clutch)
    disableClutchReversal();
}


//Rapid Jab logic
function jab3Loop(){
    if (self.getHeldControls().ATTACK) {
    	self.playFrame(2);
        Common.startJabComboCheck(); // responsible for allowing you to mash attack button in addition to holding
	} else {
		Common.playFrameIfTrue(2);
		Common.startJabComboCheck(); // responsible for allowing you to mash attack button in addition to holding
	}
}
//-----------NEUTRAL SPECIAL-----------

//projectile
function fireNSpecialProjectile(){
    neutralSpecialProjectile.set(match.createProjectile(self.getResource().getContent("characterTemplateNspecProjectile"), self));
    neutralSpecialProjectile.get().setX(self.getX() + self.flipX(NSPEC_PROJ_X_OFFSET));
    neutralSpecialProjectile.get().setY(self.getY() + NSPEC_PROJ_Y_OFFSET);
}

//cooldown timer
function startNeutralSpecialCooldown(){
    disableNeutralSpecial();
    self.addTimer(NEUTRAL_SPECIAL_COOLDOWN, 1, enableNeutralSpecial, {persistent:true});
}

function disableNeutralSpecial(){
    if (lastDisabledNSpecStatusEffect.get() != null) {
        self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, lastDisabledNSpecStatusEffect.get().id);
    }
    lastDisabledNSpecStatusEffect.set(self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_NEUTRAL));
}

function enableNeutralSpecial(){
    if (lastDisabledNSpecStatusEffect.get() != null) {
        self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, lastDisabledNSpecStatusEffect.get().id);
        lastDisabledNSpecStatusEffect.set(null);
    }
}

//-----------SIDE SPECIAL-----------

//shield hit slowdown 
function sideSpecialShieldHit(){
	self.setXSpeed(-4);
}

//jump cancel hit confirm
function sideSpecialHit(){
	self.updateAnimationStats({allowJump: true});
}

//-----------DOWN SPECIAL-----------

function specialDown_gotoEndlag(){
    if(self.isOnFloor()){
        self.playAnimation("special_down_endlag");
    } else {
        self.playAnimation("special_down_air_endlag");
    }
}

function specialDown_resetTimer(){
    self.removeTimer(downSpecialLoopCheckTimer.get());
    downSpecialLoopCheckTimer.set(-1);
}

function specialDown_checkLoop(){
    var heldControls:ControlsObject = self.getHeldControls();

    if(!heldControls.SPECIAL){
        specialDown_resetTimer();
        specialDown_gotoEndlag();
    }
}

function specialDown_gotoLoop(){
    if(self.isOnFloor()){
        self.playAnimation("special_down_loop");
    } else {
        self.playAnimation("special_down_air_loop");
    }

    //failsafe
    specialDown_resetTimer();

    // start checking inputs
    downSpecialLoopCheckTimer.set(self.addTimer(1, -1, specialDown_checkLoop));    
}


// ── Naruto-specific overrides (ported from SSF2 NarutoExt.as) ──

// Overrides the base template initialize()
// NOTE: base template initialize() sets up LINK_FRAMES listener; preserve that if needed.
function initialize() {

         // (removed SSF2 debug print)
         this.redoTimer = new FrameTimer(126);
         self.addEventListener(SSF2Event.ATTACK_ENABLED,this.onAttackEnabled,{"persistent":true});
         self.addEventListener(SSF2Event.CHAR_KO_DEATH,this.resetChargeOnDeath,{"persistent":true});
      
}

// Overrides the base template update()
function update() {

         if(this.chargeEffect != null)
         {
            this.chargeEffect.scaleX = self.getMC().scaleX;
            this.chargeEffect.scaleY = self.getMC().scaleY;
            this.chargeEffect.visible = self.getMC().visible;
            this.redoTimer.tick();
            // (removed SSF2 debug print)
            if(this.redoTimer.completed)
            {
               self.createChargeEffect();
               this.chargeEffect.gotoAndPlay("loop");
            }
         }
      
}

function onAttackEnabled(param1:*) {

         if(!isDisposed() && (param1.data.attackData.name == "b_down" || param1.data.attackData.name == "b_down_air"))
         {
            // TODO: SSF2API.removeEventListener(SSF2Event.GAME_TICK_END,this.recolorReenabledEffects);
            if((this.downBReenableEffectMC != null && this.downBReenableEffectMC != false) && (this.downBReenableEffectMC.parent != null && this.downBReenableEffectMC.parent != false))
            {
               this.downBReenableEffectMC.parent.removeChild(this.downBReenableEffectMC);
            }
            this.downBReenableEffectMC = // TODO: attachEffect("cloneReenable_MC") — use Fraymakers VFX system;
            // TODO: SSF2API.addEventListener(SSF2Event.GAME_TICK_END,this.recolorReenabledEffects);
         }
      
}

function recolorReenabledEffects(param1:*) {

         var _local2:Dynamic = null;
         if(isDisposed())
         {
            // TODO: SSF2API.removeEventListener(SSF2Event.GAME_TICK_END,this.recolorReenabledEffects);
            return;
         }
         if(!this.downBReenableEffectMC || !this.downBReenableEffectMC.parent)
         {
            // TODO: SSF2API.removeEventListener(SSF2Event.GAME_TICK_END,this.recolorReenabledEffects);
         }
         else
         {
            _local2 = getPaletteSwapData();
            applyPalette(this.downBReenableEffectMC);
            if(_local2)
            {
               SSF2Utils.replacePalette(this.downBReenableEffectMC,_local2.paletteSwap);
            }
         }
      
}

function createChargeEffect() {

         self.removeChargeEffect();
         if(!self.isStandby())
         {
            this.chargeEffect = this.attachEffectOverlay("naruto_fullChargeFlash",{"parentLock":true});
            this.redoTimer.reset();
         }
      
}

function removeChargeEffect() {

         if(this.chargeEffect != null && this.chargeEffect.parent != null)
         {
            this.chargeEffect.parent.removeChild(this.chargeEffect);
            this.chargeEffect = null;
         }
      
}

function resetChargeOnDeath(param1:* = null) {

         // TODO: setGlobalVariable("NarutoNSpecCharge", 0);
         // TODO: setGlobalVariable("NarutoNSpecFrame", 0);
         // TODO: setGlobalVariable("NarutoNSpecDoIt", false);
         // TODO: setGlobalVariable("NarutoNSpecID", null);
         self.removeChargeEffect();
      
}

function jumpToContinue(param1:* = null) {

         self.removeEventListener(SSF2Event.GROUND_TOUCH,this.jumpToContinue);
         self.updateAttackStats({
            "allowControl":false,
            "cancelWhenAirborne":true
         });
         self.playFrame("continue");
      
}
