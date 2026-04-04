// Script.hx for Ness
// Ported from SSF2 NessExt.as

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

// ── Ness-specific overrides ──────────────────────────────────

function resetGravity(param1:* = null) {

         self.removeEventListener(SSF2Event.STATE_CHANGE,this.resetGravity);
         self.updateCharacterStats({"gravity":1.08});
      
}

function randVoice() {

         var _local1:Float = 4;
         var _local2:String = "ness_grunt";
         var _local3:Float = 1 / (_local1 + 1);
         var _local4:Float = Math.random();
         var _local5:Float = self.getGlobalVariable("audio");
         var _local6:Int = 0;
         while(_local6 < _local1)
         {
            if(_local4 > _local3 + _local6 * _local3 && _local4 <= _local3 * 2 + _local6 * _local3 && _local5 != _local6)
            {
               if(self.getMetalStatus())
               {
                  // TODO: SSF2API.playSound(_local2 + _local6.toString(),true);
               }
               self.setGlobalVariable("audio",_local6);
            }
            _local6++;
         }
      
}

function pkFire(param1:Float) {

         var _local2:Float = 14;
         self.fireProjectile("ness_pkfire");
         self.getCurrentProjectile().setXSpeed(_local2 * Math.sin(param1 * Math.PI / 180),false);
         self.getCurrentProjectile().setYSpeed(_local2 * Math.cos(param1 * Math.PI / 180));
         self.attachEffect("global_dust_heavy");
         self.attachEffect("global_spark",{
            "x":flipX(24),
            "y":-10
         });
      
}

// NOTE: merge with base template initialize() if needed
function initialize() {

         // (removed SSF2 debug print)
         addEventListener(SSF2Event.HIT_WALL,this.wallHit);
      
}

function toRocket(param1:*, param2:* = null) {

         if(param2 == null)
         {
            param2 = this;
         }
         var _local3:* = 23;
         var _local4:* = SSF2Utils.getAngleBetween(new Point(param1.getX(),param1.getY()),new Point(param2.getX(),param2.getY() - param2.getCharacterStat("height") / 2));
         var _local5:* = -0.7;
         self.rocket(_local3,_local4,_local5);
      
}

function rocket(param1:Float, param2:Float, param3:Float, param4:Bool = true) {

         endAttack();
         toIdle();
         forceAttack("b_up_air");
         // (removed SSF2 debug print)
         this.m_rocketAngle = SSF2Utils.forceBase360(param2);
         this.m_rocketDecay = param3;
         this.m_rocketRotation = param4;
         this.m_rocketSpeed = param1;
         self.updateCharacterStats({"gravity":0});
         self.addEventListener(SSF2Event.STATE_CHANGE,this.resetGravity);
         if(isOnGround() && (this.m_rocketAngle >= 260 && this.m_rocketAngle <= 280))
         {
            endAttack();
            self.resetGravity();
            resetRotation();
            toBounce();
         }
         else
         {
            if(isOnGround() && (this.m_rocketAngle > 180 && this.m_rocketAngle < 360))
            {
               this.m_rocketAngle = this.m_rocketAngle < 270 ? 180 : 0;
               resetRotation();
            }
            if(param4)
            {
               if(this.m_rocketAngle <= 90 && this.m_rocketAngle >= 0 || this.m_rocketAngle >= 270 && this.m_rocketAngle < 360)
               {
                  faceRight();
               }
               else
               {
                  faceLeft();
               }
            }
            if(this.m_rocketAngle < 180 && this.m_rocketAngle > 0)
            {
               unnattachFromGround();
            }
            stancePlayFrame("rocket");
            setXSpeed(SSF2Utils.calculateXSpeed(param1,this.m_rocketAngle));
            setYSpeed(-SSF2Utils.calculateYSpeed(param1,this.m_rocketAngle));
            createTimer(1,0,this.checkRocket);
         }
      
}

function endRocket() {

         destroyTimer(this.checkRocket);
         resetRotation();
         self.resetGravity();
      
}
