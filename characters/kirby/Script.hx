// Script.hx for Kirby
// Ported from SSF2 KirbyExt.as

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

// ── Kirby-specific overrides ──────────────────────────────────

// NOTE: merge with base template initialize() if needed
function initialize() {

         // (removed SSF2 debug print)
         this.dongTimer = new FrameTimer(126);
         this.fruit = 0;
         self.setGlobalVariable("canCommandCancel",false);
         self.setGlobalVariable("canHadoken",false);
         self.setGlobalVariable("canShakunetsu",false);
         self.addEventListener(SSF2Event.CHAR_KO_DEATH,this.resetCharge,{"persistent":true});
         this.inhale = new InhaleController(this);
         this.inhale.spitInterrupt = this.spitInterrupt;
         this.inhale.bulletStatsName = "kirby_starbullet";
      
}

function restoreSpecials() {

         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_NEUTRAL — store effect id on addStatusEffect */;
         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_NEUTRAL — store effect id on addStatusEffect */;
         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_SIDE — store effect id on addStatusEffect */;
         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_SIDE — store effect id on addStatusEffect */;
         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_UP — store effect id on addStatusEffect */;
         /* TODO: removeStatusEffect for CharacterActions.SPECIAL_UP — store effect id on addStatusEffect */;
      
}

function update() {

         var _local1:* = undefined;
         var _local2:* = undefined;
         SSF2Utils.replacePalette(getKirbyHatMC(),getPaletteSwapData().paletteSwap,1,true);
         if(!this.hatCheck)
         {
            if(self.getCurrentKirbyPower() != null)
            {
               this.hatCheck = true;
            }
         }
         else if(self.getCurrentKirbyPower() == null)
         {
            this.hatCheck = false;
            self.resetCharge();
         }
         this.inhale.update();
         if(this.dongEffect != null)
         {
            this.dongEffect.visible = self.getMC().visible;
            this.dongTimer.tick();
            if(this.dongTimer.completed)
            {
               self.createChargeEffect("dong");
               this.dongTimer.reset();
            }
         }
         if(this.KirbyPower == "lucario")
         {
            this.auraSet = false;
         }
         else if(this.KirbyPower == "ryu")
         {
            _local1 = self.getHeldControls();
            _local2 = self.getHeldControls();
            if(Boolean(this.currentTimer > 0) && (this.INPUT1_D != null) && (this.INPUT2_DF) != null)
            {
               if((this.originallyFacingRight != null) && Boolean(self.isOnlyPressingSpecified(_local1,false,false,true,false)) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,false,false,false))
               {
                  self.setGlobalVariable("canHadoken",true);
                  self.setGlobalVariable("canShakunetsu",false);
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
            }
            if(Boolean(this.currentTimer > 0) && (this.INPUT1_D != null) && !this.INPUT2_DF)
            {
               if((this.originallyFacingRight != null) && Boolean(self.isOnlyPressingSpecified(_local1,false,true,true,false)) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,true,false,false))
               {
                  this.INPUT2_DF = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
            }
            if(self.isOnlyPressingSpecified(_local1,false,true,false,false) && !this.INPUT1_D && !this.INPUT2_DF && !this.INPUT2_DB && !this.INPUT1_B)
            {
               this.INPUT1_D = true;
               this.originallyFacingRight = self.isFacingRight();
               this.INPUT_NULL = false;
               this.currentTimer = this.maxTimer;
            }
            if(Boolean(this.currentTimer > 0) && (this.INPUT1_B != null) && (this.INPUT2_DB != null) && (this.INPUT3_D != null) && (this.INPUT4_DF) != null)
            {
               if((this.originallyFacingRight != null) && Boolean(self.isOnlyPressingSpecified(_local1,false,false,true,false)) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,false,false,false))
               {
                  // (removed SSF2 debug print)
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
                  self.setGlobalVariable("canShakunetsu",true);
                  self.setGlobalVariable("canHadoken",false);
               }
            }
            if(Boolean(this.currentTimer > 0) && (this.INPUT1_B != null) && (this.INPUT2_DB != null) && (this.INPUT3_D != null) && !this.INPUT4_DF)
            {
               if((this.originallyFacingRight != null) && Boolean(self.isOnlyPressingSpecified(_local1,false,true,true,false)) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,true,false,false))
               {
                  // (removed SSF2 debug print)
                  this.INPUT4_DF = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
               else if(Boolean(this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,false,false,true,false)) && Boolean(!this.skippedShaku) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,false,false,false) && !this.skippedShaku)
               {
                  // (removed SSF2 debug print)
                  // (removed SSF2 debug print)
                  this.INPUT4_DF = true;
                  this.INPUT_NULL = false;
                  this.skippedShaku = true;
                  this.currentTimer = this.maxTimer;
                  self.setGlobalVariable("canShakunetsu",true);
                  self.setGlobalVariable("canHadoken",false);
               }
            }
            if(Boolean(this.currentTimer > 0 && this.INPUT1_B && this.INPUT2_DB) && Boolean(!this.INPUT3_D) && !this.INPUT4_DF)
            {
               if(self.isOnlyPressingSpecified(_local1,false,true,false,false))
               {
                  // (removed SSF2 debug print)
                  this.INPUT3_D = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
               else if(Boolean(this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,false,true,true,false)) && Boolean(!this.skippedShaku) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,true,true,false,false) && !this.skippedShaku)
               {
                  // (removed SSF2 debug print)
                  this.INPUT3_D = true;
                  this.INPUT4_DF = true;
                  this.skippedShaku = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
            }
            if(Boolean(this.currentTimer > 0 && this.INPUT1_B && !this.INPUT2_DB) && Boolean(!this.INPUT3_D) && !this.INPUT4_DF)
            {
               if((this.originallyFacingRight != null) && Boolean(self.isOnlyPressingSpecified(_local1,true,true,false,false)) || !this.originallyFacingRight && self.isOnlyPressingSpecified(_local1,false,true,true,false))
               {
                  // (removed SSF2 debug print)
                  this.INPUT2_DB = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
               else if(self.isOnlyPressingSpecified(_local1,false,true,false,false) && !this.skippedShaku)
               {
                  // (removed SSF2 debug print)
                  this.INPUT2_DB = true;
                  this.INPUT3_D = true;
                  this.skippedShaku = true;
                  this.INPUT_NULL = false;
                  this.currentTimer = this.maxTimer;
               }
            }
            if(self.isOnFloor())
            {
               if(Boolean(self.isOnlyPressingSpecified(_local2,true,false,false,false) && this.oldFacingRight) && Boolean(!self.isFacingRight()) && !this.INPUT1_B)
               {
                  this.INPUT1_B = true;
                  this.originallyFacingRight = true;
                  this.currentTimer = this.maxTimer;
               }
               else if(self.isOnlyPressingSpecified(_local2,false,false,true,false) && !this.oldFacingRight && self.isFacingRight() && !this.INPUT1_B)
               {
                  this.INPUT1_B = true;
                  this.originallyFacingRight = false;
                  this.currentTimer = this.maxTimer;
               }
            }
            else if(self.isOnlyPressingSpecified(_local1,false,false,true,false) && !self.isFacingRight() && !this.INPUT1_B)
            {
               this.INPUT1_B = true;
               this.originallyFacingRight = false;
               this.currentTimer = this.maxTimer;
            }
            else if(self.isOnlyPressingSpecified(_local1,true,false,false,false) && self.isFacingRight() && !this.INPUT1_B)
            {
               this.INPUT1_B = true;
               this.originallyFacingRight = true;
               this.currentTimer = this.maxTimer;
            }
            if(this.currentTimer > 0 && (_local2.BUTTON1) != null)
            {
               if(self.inCommandCancelState())
               {
                  if(Boolean(self.getGlobalVariable("canHadoken")) || Boolean(self.getGlobalVariable("canShakunetsu")))
                  {
                     self.setGlobalVariable("canCommandCancel",false);
                     if(self.isOnFloor())
                     {
                        self.forceAttack("b",true);
                     }
                     else
                     {
                        self.forceAttack("b_air",true);
                     }
                  }
               }
            }
            if(this.currentTimer > 0)
            {
               --this.currentTimer;
            }
            if(this.currentTimer == 0)
            {
               self.resetCommands();
            }
            this.oldFacingRight = self.isFacingRight();
         }
      
}

function isOnlyPressingSpecified(param1:Dynamic, param2:Bool, param3:Bool, param4:Bool, param5:Bool) {

         if(param1.LEFT == param2 && param1.DOWN == param3 && param1.RIGHT == param4 && param1.UP == param5)
         {
            return true;
         }
         return false;
      
}

function resetCommands() {

         this.INPUT1_F = false;
         this.INPUT1_D = false;
         this.INPUT1_B = false;
         this.INPUT2_D = false;
         this.INPUT2_DB = false;
         this.INPUT2_DF = false;
         this.INPUT3_DF = false;
         this.INPUT3_B = false;
         this.INPUT3_D = false;
         this.INPUT4_DF = false;
         this.INPUT4_DB = false;
         this.INPUT_NULL = true;
         this.shoryuFacingRight = null;
         this.skippedShaku = false;
         self.setGlobalVariable("canHadoken",false);
         self.setGlobalVariable("canShakunetsu",false);
      
}

function finishShoryuken() {

         if(Boolean(this.currentTimer > 0) && (this.INPUT1_F != null) && (this.INPUT2_D != null) && !this.INPUT3_DF)
         {
            if((self.isFacingRight( != null) && this.shoryuFacingRight) && (self.isOnlyPressingSpecified(getControls( != null),false,true,true,false)) || !self.isFacingRight() && !this.shoryuFacingRight && self.isOnlyPressingSpecified(getControls(),true,true,false,false))
            {
               self.setGlobalVariable("canShoryuken",true);
               return true;
            }
         }
         return false;
      
}

function inCommandCancelState() {

         if(self.getState() == 0 || self.getState() == 3 || self.getState() == 4 || self.getState() == 6 || self.getState() == 7 || self.getState() == 12 || self.getState() == 25 || self.getState() == 31 || self.getState() == 46 || self.getState() == 48 || Boolean(self.getGlobalVariable("canCommandCancel")))
         {
            return true;
         }
         return false;
      
}

function createChargeEffect(param1:String) {

         switch(param1)
         {
            case "dong":
               self.removeChargeEffect("dong");
               if(!self.isStandby())
               {
                  this.dongEffect = self.attachEffectOverlay("kirby_dkbar",{"parentLock":true});
               }
         }
      
}

function removeChargeEffect(param1:String) {

         switch(param1)
         {
            case "dong":
               if(this.dongEffect != null && this.dongEffect.parent != null)
               {
                  this.dongEffect.parent.removeChild(this.dongEffect);
                  this.dongEffect = null;
               }
         }
      
}

function setAura() {

         var _local1:* = getCharacterStat("stamina");
         var _local2:* = self.getDamage();
         if(_local1 <= 0)
         {
            if(_local2 < 40)
            {
               this.auraMult = 0.8 + _local2 / 200;
            }
            else if(_local2 < 130)
            {
               this.auraMult = 1 + (_local2 - 40) / 300;
            }
            else
            {
               this.auraMult = 1.3;
            }
         }
         else if(_local2 > _local1 / 4)
         {
            this.auraMult = 0.8 + (_local1 - _local2) * 2 / (_local1 * 3);
         }
         else
         {
            this.auraMult = 1.3;
         }
         this.auraPcnt = (this.auraMult - 0.8) * 2;
         this.auraSet = true;
      
}

function spitInterrupt() {

         return false;
      
}

function swallow() {

         var _local1:* = getGrabbedOpponents()[0];
         _local1.takeDamage({
            "damage":this.SWALLOW_DAMAGE,
            "hasEffect":true,
            "direction":60,
            "power":75
         },this);
         match.getCamera()  // TODO: camera shake(5);
      
}

function isDarkPit() {

         return false;
      
}

function jumpToContinue(param1:* = null) {

         self.removeEventListener(SSF2Event.GROUND_TOUCH,this.jumpToContinue);
         self.updateAttackStats({
            "allowControl":false,
            "cancelWhenAirborne":true
         });
         self.stancePlayFrame("continue");
      
}

function removeLocked() {

         self.destroyTimer(this.checkLocked);
         if(this.attachedMovieClip != null && this.attachedMovieClip.currentFrameLabel != "die" && this.canRemove)
         {
            this.attachedMovieClip.gotoAndStop("die");
         }
         this.canRemove = false;
      
}

function checkLocked() {

         if(self.getMC().currentFrameLabel != this.attachedFrame && this.canAnimRemove || self.getMC().currentFrameLabel == "hurt" && this.canAnimRemove)
         {
            self.removeLocked();
         }
         else
         {
            this.attachedMovieClip.x = self.getX() + this.attachX;
            this.attachedMovieClip.y = self.getY() + this.attachY;
         }
      
}

function lockEffect(param1:String, param2:Float = 0, param3:Float = 0, param4:Bool = true, param5:Bool = true) {

         this.canAnimRemove = param5;
         self.destroyTimer(this.checkLocked);
         this.attachedFrame = self.getMC().currentFrameLabel;
         this.attachedMovieClip = self.attachEffect(param1,{
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

function setupHatEffect(param1:Float, param2:Float, param3:Float, param4:Float = -1, param5:Bool = false) {

         if(this.hatEffect != null && this.hatEffect.parent != null)
         {
            this.hatEffect.parent.removeChild(this.hatEffect);
            self.destroyTimer(this.checkHatEffect);
         }
         this.currentHat = self.getCurrentAnimation().slice(6);
         this.hatEffect = self.attachEffect("kh_" + this.currentHat + "_" + param1.toString(),{
            "scaleX":1.4,
            "scaleY":1.4,
            "parentLock":true,
            "syncHitStun":true,
            "x":self.flipX(param2),
            "y":param3,
            "behind":param5
         });
         this.offsets = new Point(param2,param3);
         this.hatID = param1;
         if(param4 != -1)
         {
            this.hatEffect.gotoAndStop(param4);
         }
         this.hatBehind = param5;
         self.createTimer(1,-1,this.checkHatEffect,{"persistent":true});
         self.addEventListener(SSF2Event.CHAR_SIZE_CHANGE,this.resizeHat);
      
}
