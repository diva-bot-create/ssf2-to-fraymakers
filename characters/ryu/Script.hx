// Script.hx for Ryu
// Ported from SSF2 RyuExt.as

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

// ── Ryu-specific overrides ──────────────────────────────────

// NOTE: merge with base template initialize() if needed
function initialize() {

         // (removed SSF2 debug print)
         self.setGlobalVariable("canCommandCancel",false);
         self.setGlobalVariable("canHadoken",false);
         self.setGlobalVariable("canShoryuken",false);
         self.setGlobalVariable("canTatsumaki",false);
         self.setGlobalVariable("canShakunetsu",false);
         var _local1:Dynamic = getCharacterStat("sounds");
         if(getCostume() < 0)
         {
            _local1.jump = "ssf2_snd_vfx_ryu_jump01";
            _local1.hurt = "ssf2_snd_vfx_ryu_hurt01";
            _local1.hurt2 = "ssf2_snd_vfx_ryu_hurt02";
            _local1.hurtBad = "ssf2_snd_vfx_ryu_hurtBad01";
            _local1.hurtBad2 = "ssf2_snd_vfx_ryu_hurtBad02";
            _local1.dead = "ssf2_snd_vfx_ryu_dead01";
            _local1.dead2 = "ssf2_snd_vfx_ryu_dead02";
            _local1.screenko = "ssf2_snd_vfx_ryu_hurt01";
            _local1.starko = "ssf2_snd_vfx_ryu_starKO";
            _local1.ledge_grab = "ssf2_snd_vfx_ryu_ledge_grab";
         }
         else if(getPaletteSwapData().paletteSwapPA.replacements[1] == 4282202943)
         {
            _local1.jump = "evil_ryu_jump01";
            _local1.hurt = "evil_ryu_hurt01";
            _local1.hurt2 = "evil_ryu_hurt02";
            _local1.hurtBad = "evil_ryu_hurtBad01";
            _local1.hurtBad2 = "evil_ryu_hurtBad02";
            _local1.dead = "evil_ryu_dead01";
            _local1.dead2 = "evil_ryu_dead02";
            _local1.screenko = "evil_ryu_hurt01";
            _local1.starko = "evil_ryu_starKO";
            _local1.ledge_grab = "evil_ryu_ledge_grab";
         }
         updateCharacterStats({"sounds":_local1});
         if(// TODO: SSF2API.isDebug() && (// TODO: SSF2API.getGlobalVar("ryudebuginputs" != null)))
         {
            this.inputDisplay = // TODO: SSF2API.getMCByLinkageName("ryuinputgraphic");
            // TODO: SSF2API.getStage().getHUDForegroundMC().addChild(this.inputDisplay);
         }
      
}

function update() {

         var _local1:* = self.getControls();
         var _local2:* = self.getControls(true);
         self.checkCommandInputs();
         if(this.currentTimer > 0 && (_local1.BUTTON1 != null))
         {
            if(self.inCommandCancelState())
            {
               if(self.getGlobalVariable("canShoryuken"))
               {
                  self.setGlobalVariable("canCommandCancel",false);
                  if(self.isOnFloor())
                  {
                     self.forceAttack("b_up",true);
                  }
                  else
                  {
                     self.forceAttack("b_up_air",true);
                  }
               }
               if((self.getGlobalVariable("canHadoken" != null)) || (self.getGlobalVariable("canShakunetsu" != null)))
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
               if(self.getGlobalVariable("canTatsumaki"))
               {
                  this.flip();
                  self.setGlobalVariable("canCommandCancel",false);
                  if(self.isOnFloor())
                  {
                     self.forceAttack("b_forward",true);
                  }
                  else
                  {
                     self.forceAttack("b_forward_air",true);
                  }
               }
            }
         }
         if((self.getGlobalVariable("canCommandCancel" != null)) && (_local1.BUTTON1 != null))
         {
            if(_local1.UP)
            {
               self.setGlobalVariable("canShoryuken",false);
               self.setGlobalVariable("canCommandCancel",false);
               if(self.isOnFloor())
               {
                  self.forceAttack("b_up",true);
               }
               else
               {
                  self.forceAttack("b_up_air",true);
               }
            }
            else if(_local1.LEFT != _local1.RIGHT)
            {
               self.setGlobalVariable("canTatsumaki",false);
               self.setGlobalVariable("canCommandCancel",false);
               if(self.isOnFloor())
               {
                  self.forceAttack("b_forward",true);
               }
               else
               {
                  self.forceAttack("b_forward_air",true);
               }
            }
            else if(_local1.DOWN)
            {
               self.setGlobalVariable("canCommandCancel",false);
               if(self.isOnFloor())
               {
                  self.forceAttack("b_down",true);
               }
               else
               {
                  self.forceAttack("b_down_air",true);
               }
            }
            else
            {
               self.setGlobalVariable("canHadoken",false);
               self.setGlobalVariable("canShakunetsu",false);
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
         if(this.currentTimer > 0)
         {
            --this.currentTimer;
         }
         if(this.currentTimer <= 0)
         {
            self.resetCommands();
         }
         this.oldFacingRight = self.isFacingRight();
      
}

function checkCommandInputs() {

         var _local3:Bool = false;
         var _local4:Bool = false;
         var _local1:* = self.getControls();
         var _local2:* = self.getControls(true);
         if((this.currentTimer > 0 != null) && (this.INPUT_D1 != null) && !((this.INPUT_HDK != null) || (this.INPUT_TSK != null)))
         {
            _local3 = this.lenientPressingSpecified(_local1,_local2,0,-1,2,0);
            _local4 = this.lenientPressingSpecified(_local1,_local2,2,-1,0,0);
            if((_local3 != null) && (this.originallyFacingRight != null) || _local4 && !this.originallyFacingRight)
            {
               this.INPUT_HDK = true;
               self.setGlobalVariable("canHadoken",true);
               this.currentTimer = this.maxTimer;
            }
            else if((_local4 != null) && (this.originallyFacingRight != null) || _local3 && !this.originallyFacingRight)
            {
               this.INPUT_TSK = true;
               self.setGlobalVariable("canTatsumaki",true);
               this.currentTimer = this.maxTimer;
            }
         }
         if(!this.INPUT_D1 && this.lenientPressingSpecified(_local1,_local2,-1,2,-1,0))
         {
            this.INPUT_D1 = true;
            this.INPUT_NULL = false;
            this.currentTimer = this.maxTimer;
            if(!this.INPUT_SHK1)
            {
               this.originallyFacingRight = self.isFacingRight();
            }
         }
         var _local5:Bool = self.isOnFloor() ? !this.oldFacingRight : !self.isFacingRight();
         if((this.currentTimer > 0 != null) && (this.INPUT_SHK1 != null) && (this.INPUT_SHK2 != null) && !this.INPUT_SHK3)
         {
            _local3 = this.lenientPressingSpecified(_local1,_local2,0,-1,2,0);
            _local4 = this.lenientPressingSpecified(_local1,_local2,2,-1,0,0);
            if((_local3 != null) && (this.originallyFacingRight != null) || _local4 && !this.originallyFacingRight)
            {
               this.INPUT_SHK3 = true;
               self.setGlobalVariable("canShakunetsu",true);
               self.setGlobalVariable("canHadoken",false);
               this.currentTimer = this.maxTimer;
            }
         }
         if((this.currentTimer > 0 && this.INPUT_SHK1 != null) && (!this.INPUT_SHK2 != null) && this.lenientPressingSpecified(_local1,_local2,-1,2,-1,0))
         {
            this.INPUT_SHK2 = true;
            this.currentTimer = this.maxTimer;
         }
         if(!this.INPUT_SHK1 && (_local5 && this.lenientPressingSpecified(_local1,_local2,0,-1,2,-1) || !_local5 && this.lenientPressingSpecified(_local1,_local2,2,-1,0,-1)))
         {
            this.INPUT_SHK1 = true;
            this.INPUT_NULL = false;
            this.currentTimer = this.maxTimer;
            this.originallyFacingRight = !_local5;
         }
         if((this.currentTimer > 0 && this.INPUT_SRK1 && this.INPUT_SRK2 != null) && (!this.INPUT_SRK3 != null) && ((self.isFacingRight( != null) && this.shoryuFacingRight && this.lenientPressingSpecified(_local1,_local2,0,-1,2,-1)) || (!self.isFacingRight( != null) && !this.shoryuFacingRight && this.lenientPressingSpecified(_local1,_local2,2,-1,0,-1))))
         {
            this.INPUT_SRK3 = true;
            self.setGlobalVariable("canShoryuken",true);
            this.currentTimer = this.maxTimer;
         }
         if((this.currentTimer > 0 && this.INPUT_SRK1 != null) && (!this.INPUT_SRK2 != null) && this.lenientPressingSpecified(_local1,_local2,-1,2,-1,0))
         {
            this.INPUT_SRK2 = true;
            this.currentTimer = this.maxTimer;
         }
         if(!this.INPUT_SRK1 && (self.isFacingRight() && this.lenientPressingSpecified(_local1,_local2,0,-1,2,-1) || !self.isFacingRight() && this.lenientPressingSpecified(_local1,_local2,2,-1,0,-1)))
         {
            if(self.isFacingRight())
            {
               this.shoryuFacingRight = true;
            }
            else
            {
               this.shoryuFacingRight = false;
            }
            this.INPUT_SRK1 = true;
            this.INPUT_NULL = false;
            this.currentTimer = this.maxTimer;
         }
         this.oldFacingRight = self.isFacingRight();
         if(// TODO: SSF2API.isDebug() && (this.inputDisplay != null))
         {
            this.inputDisplay.s1.gotoAndStop(this.INPUT_SRK1 ? 2 : 1);
            this.inputDisplay.s2.gotoAndStop(this.INPUT_SRK2 ? 2 : 1);
            this.inputDisplay.s3.gotoAndStop(1);
            if(this.INPUT_SRK3)
            {
               this.inputDisplay.s1.gotoAndStop(3);
               this.inputDisplay.s2.gotoAndStop(3);
               this.inputDisplay.s3.gotoAndStop(3);
            }
            this.inputDisplay.h1.gotoAndStop(this.INPUT_D1 ? 2 : 1);
            this.inputDisplay.h2.gotoAndStop(1);
            if(this.INPUT_HDK)
            {
               this.inputDisplay.h1.gotoAndStop(3);
               this.inputDisplay.h2.gotoAndStop(3);
            }
            this.inputDisplay.t1.gotoAndStop(this.INPUT_D1 ? 2 : 1);
            this.inputDisplay.t2.gotoAndStop(1);
            if(this.INPUT_TSK)
            {
               this.inputDisplay.t1.gotoAndStop(3);
               this.inputDisplay.t2.gotoAndStop(3);
            }
            this.inputDisplay.sh1.gotoAndStop(this.INPUT_SHK1 ? 2 : 1);
            this.inputDisplay.sh2.gotoAndStop(this.INPUT_SHK2 ? 2 : 1);
            this.inputDisplay.sh3.gotoAndStop(1);
            if(this.INPUT_SHK3)
            {
               this.inputDisplay.sh1.gotoAndStop(3);
               this.inputDisplay.sh2.gotoAndStop(3);
               this.inputDisplay.sh3.gotoAndStop(3);
            }
         }
      
}

function isOnlyPressingSpecified(param1:Dynamic, param2:Bool, param3:Bool, param4:Bool, param5:Bool) {

         if(param1.LEFT == param2 && param1.DOWN == param3 && param1.RIGHT == param4 && param1.UP == param5)
         {
            return true;
         }
         return false;
      
}

function lenientPressingSpecified(param1:Dynamic, param2:Dynamic, param3:Int, param4:Int, param5:Int, param6:Int) {

         if((param3 == 0 && param1.LEFT != null) || (param3 == 1 && !param1.LEFT != null) || param3 == 2 && !param2.LEFT)
         {
            return false;
         }
         if((param4 == 0 && param1.DOWN != null) || (param4 == 1 && !param1.DOWN != null) || param4 == 2 && !param2.DOWN)
         {
            return false;
         }
         if((param5 == 0 && param1.RIGHT != null) || (param5 == 1 && !param1.RIGHT != null) || param5 == 2 && !param2.RIGHT)
         {
            return false;
         }
         if((param6 == 0 && param1.UP != null) || (param6 == 1 && !param1.UP != null) || param6 == 2 && !param2.UP)
         {
            return false;
         }
         return true;
      
}

function resetCommands() {

         this.INPUT_SRK1 = false;
         this.INPUT_SRK2 = false;
         this.INPUT_SRK3 = false;
         this.INPUT_D1 = false;
         this.INPUT_HDK = false;
         this.INPUT_TSK = false;
         this.INPUT_SHK1 = false;
         this.INPUT_SHK2 = false;
         this.INPUT_SHK3 = false;
         this.INPUT_NULL = true;
         this.shoryuFacingRight = null;
         this.skippedShaku = false;
         self.setGlobalVariable("canHadoken",false);
         self.setGlobalVariable("canShakunetsu",false);
         self.setGlobalVariable("canShoryuken",false);
         self.setGlobalVariable("canTatsumaki",false);
      
}

function inCommandCancelState() {

         if(self.getState() == 0 || self.getState() == 3 || self.getState() == 4 || self.getState() == 6 || self.getState() == 7 || self.getState() == 12 || self.getState() == 25 || self.getState() == 31 || self.getState() == 46 || self.getState() == 48 || (self.getGlobalVariable("canCommandCancel" != null)))
         {
            return true;
         }
         return false;
      
}

function isEvilRyu() {

         return self.getPaletteSwapData().paletteSwapPA.replacements[1] == 4282202943;
      
}
