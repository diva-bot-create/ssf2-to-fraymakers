// Script.hx for Pichu
// Ported from SSF2 PichuExt.as
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


// ── Pichu-specific overrides (ported from SSF2 PichuExt.as) ──

function isShinyPichu() {

         return self.getPaletteSwapData().paletteSwapPA.replacements[5] == 4284099845;
      
}

// Overrides the base template initialize()
// NOTE: base template initialize() sets up LINK_FRAMES listener; preserve that if needed.
function initialize() {

         var _local2:FrameLabel = null;
         // (removed SSF2 debug print)
         var _local1:* = self.getMC().currentLabels;
         for each(_local2 in _local1)
         {
            this.animationArray.push(_local2.name);
         }
         self.addEventListener(SSF2Event.CHAR_HURT,this.dischargeEffects,{"persistent":true});
         self.addEventListener(SSF2Event.CHAR_KO_DEATH,this.onDeath,{"persistent":true});
         self.addEventListener(SSF2Event.CHAR_DESTROYED,this.resetDischarge,{"persistent":true});
         self.addEventListener(SSF2Event.CHAR_DESTROYED,this.resetElectricTerrain,{"persistent":true});
         self.addEventListener(SSF2Event.STATE_CHANGE,this.checkElectricTerrain,{"persistent":true});
      
}

// Overrides the base template update()
function update() {

         var _local1:* = self.getDischargeFrame();
         if(_local1)
         {
            self.forceAttack(_local1,null,false);
         }
         if(self.isElectricTerrainActive())
         {
            if(this.finalSmash.isDisposed())
            {
               this.finalSmash = null;
            }
            else
            {
               this.finalSmash.update();
            }
         }
      
}

function dischargeEffects(param1:* = null) {

         if(this.DischargeEnabled)
         {
            if(this.SevereEnabled && !this.playedSevere && self.getDamage() > this.SevereThreshold - 1)
            {
               this.playedSevere = true;
               // TODO: SSF2API.shakeCamera(this.SevereCamShakeIntensity);
               self.playSound(this.SevereSFX);
               this.attachEffect(this.SevereFX);
            }
            else if(!this.playedDamaged && (self.getDamage() > this.DamagedThreshold - 1 && getCharacterStat("stamina") <= 0 || self.getDamage() < getCharacterStat("stamina") * this.DamagedRatio && getCharacterStat("stamina") > 0))
            {
               this.playedDamaged = true;
               // TODO: SSF2API.shakeCamera(this.DamagedCamShakeIntensity);
               self.playSound(this.DamagedSFX);
               this.attachEffect(this.DamagedFX);
            }
         }
      
}

function recover(param1:Int) {

         if(getCharacterStat("stamina") <= 0)
         {
            if(getDamage() - param1 < this.SevereThreshold)
            {
               this.playedSevere = false;
            }
            if(getDamage() - param1 < this.DamagedThreshold)
            {
               this.playedDamaged = false;
            }
         }
         else if(getDamage() + param1 > getCharacterStat("stamina") * this.DamagedRatio)
         {
            this.playedDamaged = false;
         }
         return super.recover(param1);
      
}

function onDeath(param1:* = null) {

         self.resetDischarge();
      
}

function resetDischarge(param1:* = null) {

         this.playedDamaged = false;
         this.playedSevere = false;
      
}

function resetElectricTerrain(param1:* = null) {

         if(self.isElectricTerrainActive())
         {
            this.finalSmash.destroy();
            this.finalSmash = null;
         }
      
}

function getDischargeFrame() {

         var _local1:* = self.getCurrentAnimation();
         var _local2:* = null;
         if(this.DischargeEnabled && self.getStanceMC().currentFrame === 1 && (_local1 != null && _local1 != false))
         {
            _local2 = _local1;
            if(this.SevereEnabled && self.getDamage() > this.SevereThreshold - 1)
            {
               _local2 = _local1 + "_severe";
            }
            else if(self.getDamage() > this.DamagedThreshold - 1 && getCharacterStat("stamina") <= 0 || self.getDamage() < getCharacterStat("stamina") * this.DamagedRatio && getCharacterStat("stamina") > 0)
            {
               _local2 = _local1 + "_damaged";
            }
            else
            {
               _local2 = null;
            }
            if((_local2 != null && _local2 != false) && this.animationArray.indexOf(_local2) != -1)
            {
               if(this.DebugOnSuccess)
               {
                  // (removed SSF2 debug print)
               }
            }
            else if(_local2)
            {
               if(this.DebugOnFail)
               {
                  // (removed SSF2 debug print)
               }
               _local2 = null;
            }
         }
         return _local2;
      
}

function hurtSelf(param1:Float) {

         if(getCharacterStat("stamina") <= 0)
         {
            self.setDamage(self.getDamage() + param1);
         }
         else
         {
            self.setDamage(self.getDamage() - param1);
         }
         this.throbDamageCounter();
         if(this.DischargeEnabled && (self.getDamage() > this.DamagedThreshold - 1 && getCharacterStat("stamina") <= 0 || self.getDamage() < getCharacterStat("stamina") * this.DamagedRatio && getCharacterStat("stamina") > 0))
         {
            this.dischargeEffects();
         }
      
}

function jumpToContinue(param1:* = null) {

         self.removeEventListener(SSF2Event.GROUND_TOUCH,this.jumpToContinue);
         self.updateAttackStats({
            "allowControl":false,
            "cancelWhenAirborne":true
         });
         self.getStanceMC().gotoAndStop("continue");
      
}

function activateFinalSmash() {

         if(self.isElectricTerrainActive())
         {
            this.finalSmash.destroy();
         }
         this.finalSmash = new ElectricTerrainC(this);
      
}

function isElectricTerrainActive() {

         return (this.finalSmash != null && this.finalSmash != false) && !this.finalSmash.isDisposed() ? true : false;
      
}

function fireProjectile(param1:*, param2:Float = 0, param3:Float = 0, param4:Bool = false, param5:Dynamic = null) {

         var _local7:Int = 0;
         var _local8:* = undefined;
         var _local6:* = super.// TODO: fireProjectile(param1,param2,param3,param4,param5);
         if(self.isElectricTerrainActive() && (_local6 != null && _local6 != false))
         {
            _local7 = 1;
            _local8 = _local6.getAttackBoxStat(_local7,"damage");
            while(_local7 < 4)
            {
               if(_local6.getAttackBoxStat(_local7,"shock") === true)
               {
                  _local8 *= 1.25;
                  _local6.updateAttackBoxStats(_local7,{"damage":_local8});
               }
               _local7++;
               _local8 = _local6.getAttackBoxStat(_local7,"damage");
            }
         }
         return _local6;
      
}

function crouchHeal() {

         if(// TODO: SSF2API.getGameSettings().levelData.stage === "restarea")
         {
            return;
         }
         this.recover(1);
      
}

function updateAttackBoxStats(param1:Int, param2:Dynamic) {

         if(self.isElectricTerrainActive() && param2.damage !== undefined)
         {
            param2.damage *= 1.25;
         }
         super.updateAttackBoxStats(param1,param2);
      
}
