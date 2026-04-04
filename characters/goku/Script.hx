// Script.hx for Goku
// Ported from SSF2 GokuExt.as

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

// ── Goku-specific overrides ──────────────────────────────────

function kaiokenReset() {

         if(inState(CState.REVIVAL))
         {
            this.kaiokenPower = 0;
            this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
            self.setGlobalVariable("canKK",false);
            setCostume(getCostume(),getTeamID());
            self.powerDown();
         }
      
}

function kaiokenSpark(param1:* = null) {

         var _local2:Dynamic = {
            "crouch_attack":{
               "deny":false,
               "stack":2
            },
            "a":{
               "deny":false,
               "stack":0.25
            },
            "a_forward":{
               "deny":false,
               "stack":1
            },
            "a_forward_tilt":{
               "deny":false,
               "stack":1.5
            },
            "a_forwardsmash":{
               "deny":false,
               "stack":2.5
            },
            "a_up_tilt":{
               "deny":false,
               "stack":2
            },
            "a_up":{
               "deny":false,
               "stack":4
            },
            "a_down":{
               "deny":false,
               "stack":3
            },
            "b":{"deny":true},
            "b_air":{"deny":true},
            "b_up":{
               "deny":false,
               "stack":1
            },
            "b_up_air":{
               "deny":false,
               "stack":1
            },
            "b_forward":{
               "deny":false,
               "stack":1
            },
            "b_forward_air":{
               "deny":false,
               "stack":1
            },
            "b_down":{"deny":true},
            "b_down_air":{"deny":true},
            "a_air":{
               "deny":false,
               "stack":1.5
            },
            "a_air_up":{
               "deny":false,
               "stack":2
            },
            "a_air_forward":{
               "deny":false,
               "stack":3
            },
            "a_air_backward":{
               "deny":false,
               "stack":2
            },
            "a_air_down":{
               "deny":false,
               "stack":2
            },
            "throw_up":{
               "deny":false,
               "stack":1
            },
            "throw_forward":{
               "deny":false,
               "stack":1
            },
            "throw_down":{
               "deny":false,
               "stack":2
            },
            "throw_back":{
               "deny":false,
               "stack":1
            },
            "item_screw":{"deny":true},
            "item_firedash":{"deny":true},
            "item_bubblebounce":{"deny":true},
            "grab":{
               "deny":false,
               "stack":1
            },
            "ledge_attack":{
               "deny":false,
               "stack":1
            },
            "getup_attack":{
               "deny":false,
               "stack":1
            },
            "special":{"deny":true}
         };
         if(Boolean(_local2[getCurrentAnimation()]) && _local2[getCurrentAnimation()].deny === true)
         {
            return;
         }
         if(this.isPoweredUp == false)
         {
            if(!self.getGlobalVariable("canKK"))
            {
               if(this.kaiokenPower < 30)
               {
                  this.kaiokenPower += _local2[getCurrentAnimation()].stack;
                  this.kaiokenHUD.gotoAndStop("k" + Math.min(Math.floor(this.kaiokenPower),30));
                  if(this.kaiokenPower >= 30)
                  {
                     self.setGlobalVariable("canKK",true);
                  }
               }
            }
         }
      
}

function kaiokenCharge() {

         if(!self.getGlobalVariable("canKK"))
         {
            if(this.kaiokenPower < 30)
            {
               ++this.kaiokenPower;
               this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
               if(this.kaiokenPower >= 30)
               {
                  self.setGlobalVariable("canKK",true);
                  self.forceAttack("b_down","full_KK",true);
               }
            }
         }
         else
         {
            self.powerUp();
            self.setGlobalVariable("canKK",false);
            this.kaiokenPower = 30;
            self.enableTeleportation();
            self.enableDragonDash();
         }
      
}

function kaioKamehameha(param1:Int) {

         self.setGlobalVariable("canKK",false);
         if(this.kaiokenPower > param1)
         {
            this.kaiokenPower -= param1;
            this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
         }
         else
         {
            this.kaiokenPower = 0;
            this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
            self.powerDown();
         }
      
}

function checkKameCharge() {

         if(this.kaiokenPower < 10)
         {
            self.stancePlayFrame("quickfire");
         }
         else
         {
            this.kaiokenPower -= 10;
            this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
            self.setGlobalVariable("canKK",false);
            if(this.kaiokenPower <= 0)
            {
               this.kaiokenPower = 0;
            }
         }
      
}

function checkKaioKameCharge() {

         if(this.kaiokenPower > 10)
         {
            self.updateAttackBoxStats(1,{
               "damage":4,
               "hitStun":2,
               "selfHitStun":0,
               "direction":31,
               "power":53,
               "kbConstant":74
            });
            self.setGlobalVariable("canKK",false);
         }
         else
         {
            self.updateAttackBoxStats(1,{
               "damage":6,
               "hitStun":3,
               "selfHitStun":0,
               "direction":31,
               "power":53,
               "kbConstant":74
            });
            this.kaiokenPower = 0;
            this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
            self.setGlobalVariable("canKK",false);
            self.powerDown();
         }
      
}

function disableDragonDash(param1:* = null) {

         if(!self.isOnFloor())
         {
            setAttackEnabled(false,"b_forward");
            setAttackEnabled(false,"b_forward_air");
            addEventListener(SSF2Event.GROUND_TOUCH,this.enableDragonDash,{"persistent":true});
            addEventListener(SSF2Event.CHAR_HURT,this.enableDragonDash,{"persistent":true});
            addEventListener(SSF2Event.CHAR_GRABBED,this.enableDragonDash,{"persistent":true});
            addEventListener(SSF2Event.CHAR_LEDGE_GRAB,this.enableDragonDash,{"persistent":true});
         }
      
}

function enableDragonDash(param1:* = null) {

         setAttackEnabled(true,"b_forward");
         setAttackEnabled(true,"b_forward_air");
         removeEventListener(SSF2Event.GROUND_TOUCH,this.enableDragonDash);
         removeEventListener(SSF2Event.CHAR_HURT,this.enableDragonDash);
         removeEventListener(SSF2Event.CHAR_GRABBED,this.enableDragonDash);
         removeEventListener(SSF2Event.CHAR_LEDGE_GRAB,this.enableDragonDash);
      
}

function disableTeleportation(param1:* = null) {

         setAttackEnabled(false,"b_up");
         setAttackEnabled(false,"b_up_air");
         addEventListener(SSF2Event.GROUND_TOUCH,this.enableTeleportation,{"persistent":true});
         addEventListener(SSF2Event.CHAR_HURT,this.enableTeleportation,{"persistent":true});
         addEventListener(SSF2Event.CHAR_GRABBED,this.enableTeleportation,{"persistent":true});
         addEventListener(SSF2Event.CHAR_LEDGE_GRAB,this.enableTeleportation,{"persistent":true});
      
}

function enableTeleportation(param1:* = null) {

         setAttackEnabled(true,"b_up");
         setAttackEnabled(true,"b_up_air");
         removeEventListener(SSF2Event.GROUND_TOUCH,this.enableTeleportation);
         removeEventListener(SSF2Event.CHAR_HURT,this.enableTeleportation);
         removeEventListener(SSF2Event.CHAR_GRABBED,this.enableTeleportation);
         removeEventListener(SSF2Event.CHAR_LEDGE_GRAB,this.enableTeleportation);
      
}

function powerupAttackBox(param1:Int) {

         self.updateAttackBoxStats(param1,{
            "hitStun":Math.ceil(self.getAttackBoxStat(param1,"hitStun") * 1.25) + 1,
            "selfHitStun":Math.ceil(self.getAttackBoxStat(param1,"selfHitStun") * 1.25) + 1,
            "camShake":self.getAttackBoxStat(param1,"camShake") + 4,
            "sdiDistance":self.getAttackBoxStat(param1,"sdiDistance") / 1.5
         });
      
}

function applyDamageMod(param1:Int) {

         self.updateAttackBoxStats(param1,{"damage":self.damageMod(self.getAttackBoxStat(param1,"damage"))});
      
}

function damageMod(param1:Float) {

         return this.isPoweredUp ? param1 * 1.2 : param1;
      
}

function recoilKaioKen(param1:* = null) {

         dealDamage(param1.data.attackBoxData.damage * 0.25);
         forceHitStun(param1.data.attackBoxData.hitStun * 1.2,-1);
      
}

function powerUp() {

         var _local1:Dynamic = self.getOwnStats();
         this.extraFilter = getMC().filters;
         addEventListener(SSF2Event.CHAR_HURT,this.recoilKaioKen,{"persistent":true});
         updateCharacterStats({
            "norm_xSpeed":_local1.norm_xSpeed * 1.2,
            "max_xSpeed":_local1.max_xSpeed * 1.2,
            "decel_rate":_local1.decel_rate * 1.2,
            "accel_rate_air":_local1.accel_rate_air * 1.2,
            "max_jumpSpeed":_local1.max_jumpSpeed * 1.2,
            "damageRatio":_local1.damageRatio * 1.2
         });
         self.updateToKKFilter();
         this.isPoweredUp = true;
      
}

function powerDown() {

         var _local3:Dynamic  // MovieClip → use Sprite or Container = null;
         if(!this.isPoweredUp)
         {
            return;
         }
         var _local1:Dynamic = self.getOwnStats();
         removeEventListener(SSF2Event.CHAR_HURT,this.recoilKaioKen);
         updateCharacterStats({
            "norm_xSpeed":_local1.norm_xSpeed,
            "max_xSpeed":_local1.max_xSpeed,
            "decel_rate":_local1.decel_rate,
            "accel_rate_air":_local1.accel_rate_air,
            "max_jumpSpeed":_local1.max_jumpSpeed,
            "damageRatio":_local1.damageRatio
         });
         self.setColorFilters(false);
         var _local2:Int = 0;
         _local3 = getHealthBox().getChildByName("charHead") cast(MovieClip);
         if(_local3)
         {
            SSF2Utils.setColorFilters(_local3,false);
            _local3.filters = this.extraFilter;
         }
         _local3 = getHealthBox().getChildByName("stockiconsingle") cast(MovieClip);
         if(_local3)
         {
            SSF2Utils.setColorFilters(_local3,false);
         }
         else
         {
            while(_local2 < getLives())
            {
               _local3 = getHealthBox().getChildByName("stockicon" + _local2) cast(MovieClip);
               if(_local3)
               {
                  SSF2Utils.setColorFilters(_local3,{
                     "redMultiplier":1,
                     "greenMultiplier":1,
                     "blueMultiplier":1,
                     "redOffset":0,
                     "greenOffset":0,
                     "blueOffset":0,
                     "brightness":-15 * (getLives() - (_local2 + 1))
                  });
               }
               _local2++;
            }
         }
         this.isPoweredUp = false;
         getMC().filters = this.extraFilter;
      
}

// NOTE: merge with base template initialize() if needed
function initialize() {

         // (removed SSF2 debug print)
         addEventListener(SSF2Event.ATTACK_HIT,this.kaiokenSpark,{"persistent":true});
         addEventListener(SSF2Event.CHAR_METAL_CHANGE,this.restoreFilters,{"persistent":true});
         this.kaiokenHUD = new gokuKaiokenHUD();
         if(self.getHealthBox())
         {
            self.getHealthBox().addChild(this.kaiokenHUD);
         }
         this.kaiokenHUD.x = 1.5;
         this.kaiokenHUD.y = -1;
         self.createTimer(1,-1,this.animateKaiokenHUD,{
            "persistent":true,
            "hitStunPause":false
         });
      
}

function update() {

         if(this.isPoweredUp == true)
         {
            if(this.kaiokenPower > 0)
            {
               if(this.kaiokenDecayDelay > 0)
               {
                  --this.kaiokenDecayDelay;
               }
               else
               {
                  --this.kaiokenPower;
                  this.kaiokenHUD.gotoAndStop("k" + Math.floor(this.kaiokenPower));
                  this.kaiokenDecayDelay = 15;
               }
            }
            else
            {
               self.setGlobalVariable("canKK",false);
               self.powerDown();
            }
         }
         if(this.isPoweredUp && this.showBackEffect)
         {
            if(this.kaiokenBackEffect == null)
            {
               this.kaiokenBackEffect = attachEffect("goku_kk_back",{"behind":true});
            }
            else
            {
               if(this.kaiokenBackEffect.parent == null)
               {
                  this.kaiokenBackEffect = null;
                  this.kaiokenBackEffect = attachEffect("goku_kk_back",{"behind":true});
               }
               if(this.kaiokenBackEffect.parent != null)
               {
                  this.kaiokenBackEffect.scaleX = getScale().x;
                  this.kaiokenBackEffect.scaleY = getScale().y;
                  this.kaiokenBackEffect.x = getX() + this.kaiokenEffectX * getScale().x;
                  this.kaiokenBackEffect.y = getY() + this.kaiokenEffectY * getScale().y;
               }
            }
         }
         else if(this.kaiokenBackEffect != null)
         {
            if(this.kaiokenBackEffect.parent != null)
            {
               this.kaiokenBackEffect.parent.removeChild(this.kaiokenBackEffect);
            }
            this.kaiokenBackEffect = null;
         }
         if(this.upBCancelTimer > 0)
         {
            --this.upBCancelTimer;
         }
      
}

function resetKaioKenBackEffect() {

         this.showBackEffect = true;
         this.kaiokenEffectX = 0;
         this.kaiokenEffectY = 0;
      
}

function jumpToContinue(param1:* = null) {

         self.removeEventListener(SSF2Event.GROUND_TOUCH,this.jumpToContinue);
         self.updateAttackStats({
            "allowControl":false,
            "cancelWhenAirborne":true
         });
         self.stancePlayFrame("continue");
      
}

function setKKLandingLag(param1:Bool) {

         if(param1)
         {
            self.removeEventListener(SSF2Event.GROUND_TOUCH,this.toIdle);
            self.addEventListener(SSF2Event.GROUND_TOUCH,this.toLand);
            if(self.isOnFloor())
            {
               self.toLand();
            }
         }
         else
         {
            self.removeEventListener(SSF2Event.GROUND_TOUCH,this.toLand);
            self.addEventListener(SSF2Event.GROUND_TOUCH,this.toIdle);
            if(self.isOnFloor())
            {
               self.toIdle();
            }
         }
      
}

function forceOutro(param1:* = null) {

         forceAttack("outro",1,true);
      
}
