// Script.hx for Pit
// Ported from SSF2 PitExt.as

// ── Base template ────────────────────────────────────────────────────────────
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

// ── Pit-specific overrides ──────────────────────────────────

// NOTE: merge with base template initialize() if needed
function initialize() {

         // (removed SSF2 debug print)
         var _local1:Dynamic = getCharacterStat("sounds");
         if(!self.isDarkPit())
         {
            _local1.jump = "pit_vc_jump";
            _local1.hurt = "pit_vc_hurt01";
            _local1.hurt = "pit_vc_hurt02";
            _local1.hurtBad = "pit_vc_hurtbad01";
            _local1.hurtBad2 = "pit_vc_hurtbad02";
            _local1.dead = "pit_vc_dead01";
            _local1.dead2 = "pit_vc_dead02";
            _local1.screenko = "pit_vc_hurt02";
            _local1.starko = "pit_vc_starko";
            _local1.ledge_grab = "pit_edgeGrab";
         }
         else if(self.isDarkPit())
         {
            _local1.jump = "dark_pit_jump";
            _local1.hurt = "dark_pit_hurt01";
            _local1.hurt2 = "dark_pit_hurt02";
            _local1.hurtBad = "dark_pit_hurtbad01";
            _local1.hurtBad2 = "dark_pit_hurtbad02";
            _local1.dead = "dark_pit_dead01";
            _local1.dead2 = "dark_pit_dead02";
            _local1.screenko = "dark_pit_hurt02";
            _local1.starko = "dark_pit_starko";
            _local1.ledge_grab = "dark_pit__edgeGrab";
         }
         updateCharacterStats({"sounds":_local1});
      
}

function isDarkPit() {

         return self.getPaletteSwapData().paletteSwapPA.replacements[76] == 4289855743;
      
}

function removeLocked() {

         this.destroyTimer(this.checkLocked);
         if(this.attachedMovieClip != null && this.attachedMovieClip.currentFrameLabel != "die" && this.canRemove)
         {
            this.attachedMovieClip.gotoAndStop("die");
         }
         this.canRemove = false;
      
}

function checkLocked() {

         if(self.getCurrentAttackFrame() != this.attachedFrame)
         {
            self.removeLocked();
         }
         else
         {
            this.attachedMovieClip.x = self.getX() + this.attachX;
            this.attachedMovieClip.y = self.getY() + this.attachY;
         }
      
}

function lockEffect(param1:String, param2:Float = 0, param3:Float = 0, param4:Bool = true) {

         this.destroyTimer(this.checkLocked);
         this.attachedFrame = self.getCurrentAttackFrame();
         this.attachedMovieClip = this.attachEffect(param1,{
            "x":param2,
            "y":param3,
            "flip":param4
         });
         this.attachX = param2;
         this.attachY = param3;
         self.createTimer(1,-1,this.checkLocked,{"persistent":true});
         this.canRemove = true;
         return this.attachedMovieClip;
      
}

function feather(param1:Float = 1, param2:Float = 0, param3:Float = 360, param4:Float = 0, param5:Float = 20, param6:Float = 20, param7:Float = 70) {

         var _local8:MovieClip = null;
         while(param1 > 0)
         {
            _local8 = attachEffect("pit_feather",{
               "x":this.flipX(// TODO: SSF2API.randomInteger(param4,param5) - (param5 - param4) / 2),
               "y":-// TODO: SSF2API.randomInteger(param6,param7)
            });
            SSF2Utils.replacePalette(_local8,getPaletteSwapData().paletteSwap,3);
            _local8.rotation = // TODO: SSF2API.randomInteger(param2,param3);
            _local8.feath.gotoAndStop(// TODO: SSF2API.randomInteger(0,30));
            param1--;
         }
      
}

function jumpToContinue(param1:* = null) {

         self.removeEventListener(SSF2Event.GROUND_TOUCH,this.jumpToContinue);
         self.updateAttackStats({
            "allowControl":false,
            "cancelWhenAirborne":true
         });
         this.stancePlayFrame("continue");
      
}
