// API Script for mario — converted from SSF2
// Frame scripts are extracted from SSF2 timeline code.
// SSF2 API calls are mapped to Fraymakers equivalents where possible.
// Lines marked TODO need manual review.

// start general functions ---

//Runs on object init
function initialize(){
	self.addEventListener(GameObjectEvent.LINK_FRAMES, handleLinkFrames, {persistent:true});
}

function update(){
}

// Runs when reading inputs (before determining character state, update, framescript, etc.)
function inputUpdateHook(pressedControls:ControlsObject, heldControls:ControlsObject) {
}

// CState-based handling for LINK_FRAMES
function handleLinkFrames(e){
}

function onTeardown() {
}

// --- end general functions

// ── Decompiled from SSF2 XxxExt.as ─────────────────────────────────────────

function addEffectToList(arg0) {
	if (arg0 == null) {
		Engine.log("Tried to add a NULL effect to list!");
		return null;
	} else {
		self.effects.push(arg0);
		return arg0;
	}
}


function clearEffectsOnStateChange(arg0) {
	self.clearListener = arg0;
	self.addEventListener(GameObjectEvent.LINK_FRAMES, self.removeAllEffects);
	return;
}


function flipX(arg0) {
	if (self.isFacingRight()) {
		return arg0;
	}
	return arg0 * -1;
}


function followUser(arg0, arg1, arg2) {
	var updatePos = function() {
		effectMC.x = self.getX() + xOffset;
		effectMC.y = self.getY() + yOffset;
		return;
	};
	var xOffset = arg1.x - self.getX();
	var yOffset = arg1.y - self.getY();
	var options = { hitStunPause: false };
	if (arg2) {
		var options = { persistent: true, hitStunPause: false };
	} else {
		var options = { persistent: false, hitStunPause: false };
	}
	if (arg0) {
		self.addTimer(1, 0, updatePos, options);
		return;
	}
	self.removeTimer(updatePos);
}


function ssf2_initialize() {
	Engine.log("Mario initialized.");
	return;
}


function jumpToContinue(arg0) {
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ allowControl: false, cancelWhenAirborne: true });
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("continue");
	return;
}


function loopEffect(arg0, arg1, arg2) {
	var doLoop = function() {
		// [SSF2-only: gotoAndStop] effectMC.gotoAndStop(1);
		return;
	};
	var options = { hitStunPause: false };
	if (arg2) {
		var options = { persistent: true, hitStunPause: false };
	} else {
		var options = { persistent: false, hitStunPause: false };
	}
	if (arg0) {
		self.addTimer(1, 0, doLoop, { hitStunPause: false });
		return;
	}
	self.removeTimer(doLoop);
}


function pushEffectBehind(arg0) {
	// [SSF2-only: getMC] SSF2API.getStage().getMidground().swapChildren(self.getMC(), arg0);
	return arg0;
}


function removeAllEffects(arg0) {
	var i = 0;
	while (i < self.effects.length) {
		if (self.effects[i] == null) {
			i = i + 1;
		} else {
			if (self.effects[i].parent == null) {
			} else {
				self.effects[i].parent.removeChild(self.effects[i]);
			}
		}
	}
	self.effects = new Array();
	if ((self.clearListener && self.hasEventListener(GameObjectEvent.LINK_FRAMES, self.removeAllEffects)) || arg0 != null) {
		self.removeEventListener(GameObjectEvent.LINK_FRAMES, self.removeAllEffects);
	}
	return;
}


function setLandingLag(arg0) {
	if (arg0) {
		self.removeEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
		self.addEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
		if (self.isOnFloor()) {
			// [SSF2-only: jumpToContinue] self.jumpToContinue();
		}
		return;
	}
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	if (self.isOnFloor()) {
		self.toState(CState.LAND);
	}
}


function stopListening() {
	self.clearListener = false;
	self.removeEventListener(GameObjectEvent.LINK_FRAMES, self.removeAllEffects);
	return;
}


// ── Frame scripts (504 methods) ──────────────────────────────────────────────
// NOTE: These are SSF2 timeline frame methods, named by global frame number.
// They need to be manually assigned to animation FRAME_SCRIPT layers in FrayTools.

function a__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
// [FM] isReady guard removed — always true in Fraymakers
	self.controls = self.getHeldControls();
	self.used = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "jab");
	self.used2 = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "jab2");
	self.time = self.getLastUsed();
	self.addTimer(1, 39, self.updateControls, false);
	self.continueCombo();
	self.pressed1 = false;
	self.pressed2 = false;
	return;
}


function a__frame1() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_blast", { x: self.flipX(43), y: -18, parentLock: true });
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	return;
}


function a__frame11() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_m");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_blast", { x: self.flipX(43), y: -15, parentLock: true });
	return;
}


function a__frame12() {
	self.pressed1 = false;
	self.checkControls();
	return;
}


function a__frame13() {
	self.addTimer(1, 6, self.checkControls, false);
	return;
}


function a__frame14() {
	self.addTimer(1, 6, self.checkForGoToJab3, false);
	return;
}


function a__frame17() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a__frame18() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	self.newStats = { angle: 45, baseKnockback: 40, damage: 5, knockbackGrowth: 100, weightKB: 0 };
	self.updateHitboxStats(1, self.newStats);
	self.updateHitboxStats(2, self.newStats);
	self.setLastUsed("a", 0);
	self.reactivateHitboxes();
	self.removeTimer(self.checkControls);
	self.removeTimer(self.checkForGoToJab3);
	return;
}


function a__frame2() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function a__frame20() {
	self.updateHitboxStats(1, { effectSound: "brawl_kick_m" });
	self.updateHitboxStats(2, { effectSound: "brawl_kick_m" });
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	self.setXVelocity(7, false);
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function a__frame29() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a__frame3() {
	self.pressed1 = false;
	self.checkControls();
	return;
}


function a__frame4() {
	self.addTimer(1, 6, self.checkControls, false);
	return;
}


function a__frame5() {
	self.addTimer(1, 5, self.checkForGoToJab2, false);
	return;
}


function a__frame7() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a__frame8() {
	self.newStats = { angle: 70, damage: 2 };
	self.updateHitboxStats(1, self.newStats);
	self.reactivateHitboxes();
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", true);
	self.setLastUsed("a", 0);
	self.removeTimer(self.checkControls);
	self.removeTimer(self.checkForGoToJab2);
	return;
}


function a_air__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function a_air__frame1() {
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	return;
}


function a_air__frame16() {
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air__frame2() {
	self.updateAnimationStats({ autoCancel: true });
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_blast", { x: self.flipX(25), y: -15, parentLock: true });
	return;
}


function a_air__frame20() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air__frame21() {
	self/* TODO: removeAllEffects */;
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function a_air__frame25() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air__frame4() {
	self.updateHitboxStats(1, { angle: 55, damage: 8, baseKnockback: 13, effect_id: "effect_hit2", effectSound: "brawl_kick_s" });
	return;
}


function a_air_backward__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air_backward__frame14() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_backward__frame2() {
	self.updateAnimationStats({ autoCancel: true });
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	return;
}


function a_air_backward__frame23() {
	self/* TODO: removeAllEffects */;
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function a_air_backward__frame28() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_backward__frame3() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_blast", { x: self.flipX(-48), y: -22, parentLock: true });
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function a_air_backward__frame5() {
	self.updateHitboxStats(1, { baseKnockback: 7, damage: 9, knockbackGrowth: 90, effect_id: "effect_hit1" });
	return;
}


function a_air_backward__frame9() {
	self.updateAnimationStats({ autoCancel: true });
	return;
}


function a_air_down__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air_down__frame11() {
	// [SSF2-only: playSound] self.playSound("mario_spin");
	self.reactivateHitboxes();
	return;
}


function a_air_down__frame12() {
	self.reactivateHitboxes();
	return;
}


function a_air_down__frame16() {
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air_down__frame19() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_down__frame2() {
	self.updateAnimationStats({ autoCancel: true });
	return;
}


function a_air_down__frame20() {
	self.updateHitboxStats(1, { weightKB: 40, damage: 2 });
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ refreshRate: 50 });
	self.reactivateHitboxes();
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self/* TODO: removeAllEffects */;
	SSF2API.getCamera().shake(3);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function a_air_down__frame26() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_down__frame5() {
	// [SSF2-only: playSound] self.playSound("mario_spin");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_spiral", { x: self.flipX(6), y: -15, scaleX: 1.2, scaleY: 1.2, rotation: self.flipX(-30), parentLock: true });
	return;
}


function a_air_down__frame6() {
	self.reactivateHitboxes();
	return;
}


function a_air_down__frame7() {
	// [SSF2-only: playSound] self.playSound("mario_spin");
	return;
}


function a_air_down__frame8() {
	self.reactivateHitboxes();
	return;
}


function a_air_down__frame9() {
	// [SSF2-only: playSound] self.playSound("mario_spin");
	self.reactivateHitboxes();
	return;
}


function a_air_forward__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air_forward__frame1() {
	self.updateAnimationStats({ autoCancel: true });
	return;
}


function a_air_forward__frame24() {
	self.updateAnimationStats({ autoCancel: false });
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ allowFullInterrupt: true, doubleJumpCancelAttack: true });
	return;
}


function a_air_forward__frame29() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_forward__frame30() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self/* TODO: removeAllEffects */;
	SSF2API.getCamera().shake(4);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landHeavy");
}


function a_air_forward__frame37() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_forward__frame7() {
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	self.playAttackVoice(/* voice index: */1);
	return;
}


function a_air_forward__frame9() {
	self.updateHitboxStats(2, { hitstun: -1.1, camShake: 2, angle: 55, baseKnockback: 20, knockbackGrowth: 100, reversableAngle: true });
	return;
}


function a_air_up__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_air_up__frame1() {
	self.updateAnimationStats({ autoCancel: true });
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	return;
}


function a_air_up__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_up__frame16() {
	self/* TODO: removeAllEffects */;
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function a_air_up__frame2() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	return;
}


function a_air_up__frame20() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_air_up__frame7() {
	return;
}


function a_air_up__frame8() {
	self.updateAnimationStats({ autoCancel: false });
	return;
}


function a_down__frame0() {
	// self reference (implicit in FM)
	self.xframe = null;
	return;
}


function a_down__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	return;
}


function a_down__frame1() {
	self.xframe = "charging";
	return;
}


function a_down__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_down__frame2() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_m");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function a_down__frame40() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("charging");
	return;
}


function a_down__frame41() {
	self.xframe = "attack";
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	self.playAttackVoice(/* voice index: */1);
	return;
}


function a_down__frame42() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	// [SSF2-only: playSound] self.playSound("mario_kickswing");
	return;
}


function a_down__frame45() {
	self.updateHitboxStats(1, { damage: 10, baseKnockback: 35, knockbackGrowth: 75 });
	// [SSF2-only: playSound] self.playSound("brawl_swing_s");
	// [SSF2-only: playSound] self.playSound("mario_kickswing");
	return;
}


function a_down__frame63() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_forward__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.setXVelocity(14, false);
	return;
}


function a_forward__frame19() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_forward__frame2() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy");
	// [SSF2-only: playSound] self.playSound("brawl_swing_m");
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_lightLand");
}


function a_forward__frame4() {
	self.updateHitboxStats(1, { angle: 45, damage: 7, baseKnockback: 55, knockbackGrowth: 30, effectSound: "brawl_kick_m" });
	return;
}


function a_forward_tilt__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	return;
}


function a_forward_tilt__frame1() {
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function a_forward_tilt__frame13() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_forward_tilt__frame2() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_m");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function a_forwardsmash__frame0() {
	// self reference (implicit in FM)
	self.xframe = null;
	self.customData = { attackBox: {}, attackBox2: { damage: 14, baseKnockback: 30, knockbackGrowth: 93, hitstop: 5, selfHitstop: 2, priority: 5 } };
	return;
}


function a_forwardsmash__frame2() {
	self.xframe = "charging";
	return;
}


function a_forwardsmash__frame42() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("charging");
	return;
}


function a_forwardsmash__frame43() {
	self.xframe = "attack";
	return;
}


function a_forwardsmash__frame47() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy");
	// [SSF2-only: attachEffect] self.attachEffect("effect_explosion", { x: self.flipX(48), y: -25 });
	SSF2API.getCamera().shake(6);
	// [SSF2-only: playSound] self.playSound("mario_Fsmash_sfx");
	self.playAttackVoice(/* voice index: */1);
	return;
}


function a_forwardsmash__frame64() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_up__frame0() {
	// self reference (implicit in FM)
	self.xframe = null;
	return;
}


function a_up__frame4() {
	self.xframe = "charging";
	return;
}


function a_up__frame44() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("charging");
	return;
}


function a_up__frame45() {
	self.xframe = "attack";
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	self.playAttackVoice(/* voice index: */1);
	return;
}


function a_up__frame46() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	// [SSF2-only: playSound] self.playSound("mario_kickswing");
	return;
}


function a_up__frame48() {
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_lightLand");
}


function a_up__frame65() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_up_tilt__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	return;
}


function a_up_tilt__frame1() {
	// [SSF2-only: clearEffectsOnStateChange] self.clearEffectsOnStateChange();
	return;
}


function a_up_tilt__frame12() {
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_lightLand");
}


function a_up_tilt__frame13() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function a_up_tilt__frame2() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function airdodge__frame0() {
	// self reference (implicit in FM)
	return;
}


function airdodge__frame14() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function airdodge__frame2() {
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 12);
	return;
}


function airdodge__frame24() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function b__frame0() {
// [FM] isReady guard removed — always true in Fraymakers
}


function b__frame22() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function b__frame6() {
	// [SSF2-only: fireProjectile] self.fireProjectile("mario_fireball", 22, -20);
	// [SSF2-only: attachEffect] self.attachEffect("nSpecWave", { x: self.flipX(25), y: -25 });
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	// [SSF2-only: playSound] self.playSound("mario_fireballspawn");
	// [SSF2-only: playSound] self.playSound("mario_fireballsfx");
	return;
}


function b_air__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function b_air__frame18() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function b_air__frame8() {
	// [SSF2-only: fireProjectile] self.fireProjectile("mario_fireball", 22, -20);
	// [SSF2-only: attachEffect] self.attachEffect("nSpecWave", { x: self.flipX(10), y: -25, rotation: self.flipX(20) });
	// [SSF2-only: playSound] self.playSound("mario_fireballspawn");
	// [SSF2-only: playSound] self.playSound("mario_fireballsfx");
	return;
}


function b_down__frame0() {
	// self reference (implicit in FM)
	self.riseAmt = -6;
	self.riseAmtMax = -12;
	self.riseAmtIncr = -2;
	self.pressed1 = false;
	self.pressed2 = false;
// [FM] isReady guard removed — always true in Fraymakers
}


function b_down__frame10() {
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_dspec3");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_spin", { y: -28, scaleX: 0.55, parentLock: true });
	return;
}


function b_down__frame11() {
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_dspec4");
	return;
}


function b_down__frame13() {
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_dspec4");
	return;
}


function b_down__frame14() {
	// [SSF2-only: playSound] self.playSound("mario_dspec5");
	self.reactivateHitboxes();
	return;
}


function b_down__frame16() {
	self.reactivateHitboxes();
	self.removeTimer(self.rise);
	if (self.isOnFloor()) {
	} else {
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", false);
	}
	return;
}


function b_down__frame18() {
	self.reactivateHitboxes();
	if (self.isOnFloor()) {
	} else {
		self.setYVelocity(-4);
	}
	return;
}


function b_down__frame19() {
	self.playAttackVoice(/* voice index: */1);
	return;
}


function b_down__frame2() {
	// [SSF2-only: playSound] self.playSound("mario_dspec");
	self.reactivateHitboxes();
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: -1 });
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_spin", { y: -28, scaleX: 0.55, parentLock: true });
	self.addTimer(1, 0, self.rise);
	return;
}


function b_down__frame20() {
	self.updateHitboxStats(1, { damage: 5, angle: 65, baseKnockback: 75, knockbackGrowth: 100, weightKB: 0 });
	self.reactivateHitboxes();
	return;
}


function b_down__frame21() {
	// [SSF2-only: playSound] self.playSound("mario_dspec6");
	return;
}


function b_down__frame22() {
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: 0 });
	return;
}


function b_down__frame25() {
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: -1 });
	return;
}


function b_down__frame32() {
	// [SSF2-only: isCPU] if (self.isCPU()) {
		if (self.getCPUAction() != 3) {
		} else {
			self.setAttackEnabled(false, "b_down_air");
			self.addEventListener(SSF2Event.GROUND_TOUCH, self.reenableForCPU, { persistent: true });
		}
	}
	if (self.isOnFloor()) {
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	}
	self.endAnimation();
	return;
}


function b_down__frame4() {
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_dspec");
	return;
}


function b_down__frame5() {
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_dspec2");
	return;
}


function b_down__frame7() {
	// [SSF2-only: playSound] self.playSound("mario_dspec2");
	return;
}


function b_down__frame8() {
	// [SSF2-only: playSound] self.playSound("mario_dspec3");
	self.reactivateHitboxes();
	return;
}


function b_forward__frame0() {
	// self reference (implicit in FM)
	self.gliding = false;
// [FM] isReady guard removed — always true in Fraymakers
	self.addEventListener(SSF2Event.GROUND_LEAVE, self.glideAway);
	return;
}


function b_forward__frame18() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function b_forward__frame2() {
	self.removeEventListener(SSF2Event.GROUND_LEAVE, self.glideAway);
	// [SSF2-only: playSound] self.playSound("mario_capespawn");
	return;
}


function b_forward__frame5() {
	// [SSF2-only: playSound] self.playSound("mario_cape");
	if (!self.gliding && !self.isOnFloor()) {
		// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy");
		// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	}
	self.reactivateHitboxes();
	return;
}


function b_forward_air__frame0() {
	// self reference (implicit in FM)
	self.gliding = false;
// [FM] isReady guard removed — always true in Fraymakers
}


function b_forward_air__frame18() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function b_forward_air__frame2() {
	// [SSF2-only: playSound] self.playSound("mario_capespawn");
	return;
}


function b_forward_air__frame5() {
	// [SSF2-only: playSound] self.playSound("mario_cape");
	if (!self.gliding && !self.isOnFloor()) {
	}
}


function b_up__frame0() {
	// self reference (implicit in FM)
	self.speed = -23;
	self.updateStats = true;
// [FM] isReady guard removed — always true in Fraymakers
}


function b_up__frame0() {
// [FM] isReady guard removed — always true in Fraymakers
	self.addEventListener(SSF2Event.CHAR_ATTACK_COMPLETE, self.toHelpless);
	// self reference (implicit in FM)
	self.angle = Math.atan(26 / 18) * 180 / Math.PI;
	self.speed = 25;
	self.angleAlt = 5.5;
// [FM] isReady guard removed — always true in Fraymakers
	self.controls = self.getHeldControls();
	self.facingRight = self.isFacingRight();
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up__frame1() {
	self.setXVelocity(self.getXVelocity() / 2);
	// [SSF2-only: playSound] self.playSound("screw1");
	return;
}


function b_up__frame1() {
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 2);
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up__frame10() {
	// [SSF2-only: playSound] self.playSound("screw4");
	self.setIASA(true);
	return;
}


function b_up__frame10() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame11() {
	self.updateHitboxStats(1, { baseKnockback: 80, knockbackGrowth: 100, damage: 2, hitstop: 5, selfHitstop: 5 });
	self.updateHitboxStats(2, { baseKnockback: 80, knockbackGrowth: 100, damage: 2, hitstop: 5, selfHitstop: 5 });
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ refreshRate: 90 });
	self.reactivateHitboxes();
	return;
}


function b_up__frame11() {
	self.updateHitboxStats(1, { baseKnockback: 45, knockbackGrowth: 100, angle: 60, damage: 3, weightKB: 0 });
	self.reactivateHitboxes();
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: 0 });
	self.setYVelocity(0);
	self.setXVelocity(0);
	return;
}


function b_up__frame14() {
	// [SSF2-only: playSound] self.playSound("screw5");
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: 4 + self.getCharacterStat("max_ySpeed") * 0.4 });
	return;
}


function b_up__frame15() {
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ allowControl: true, air_ease: -1, xSpeedDecay: 0, xSpeedDecayAir: 0 });
	return;
}


function b_up__frame18() {
	// [SSF2-only: playSound] self.playSound("screw6");
	return;
}


function b_up__frame2() {
	self.addTimer(1, 10, self.moveUp);
	self.setYVelocity(-23);
	// [SSF2-only: playSound] self.playSound("screw2");
	return;
}


function b_up__frame2() {
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up__frame23() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("loop");
	return;
}


function b_up__frame3() {
	// [FM] setIntangibility(false) removed — duration encoded above
	self.updateHitboxStats(1, { damage: 1 });
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_uspec");
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy");
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	self.angle = 45;
	self.updateHitboxStats(1, { angle: self.angle });
	self.addTimer(1, -1, self.moveIt, { pauseHitstun: true });
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toHeavyLand);
	return;
}


function b_up__frame4() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame5() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame50() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("fallLoop");
	return;
}


function b_up__frame6() {
	// [SSF2-only: playSound] self.playSound("screw3");
	return;
}


function b_up__frame6() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame7() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame8() {
	self.updateStats = false;
	self.updateHitboxStats(1, { baseKnockback: 30, knockbackGrowth: 100, damage: 2, hitstop: 2, selfHitstop: 1 });
	self.updateHitboxStats(2, { baseKnockback: 0, knockbackGrowth: 100, damage: 2, hitstop: 2, selfHitstop: 1 });
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ refreshRate: 1 });
	return;
}


function b_up__frame8() {
	self.reactivateHitboxes();
	return;
}


function b_up__frame9() {
	self.removeTimer(self.moveIt);
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame0() {
// [FM] isReady guard removed — always true in Fraymakers
	self.attachEffectOverlay("upSpecSparkle");
	// self reference (implicit in FM)
	self.angle = Math.atan(26 / 18) * 180 / Math.PI;
	self.speed = 25;
	self.angleAlt = 5.5;
// [FM] isReady guard removed — always true in Fraymakers
	self.controls = self.getHeldControls();
	self.facingRight = self.isFacingRight();
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up_air__frame1() {
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 2);
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up_air__frame10() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame11() {
	self.updateHitboxStats(1, { baseKnockback: 45, knockbackGrowth: 90, angle: 60, damage: 3, weightKB: 0 });
	self.reactivateHitboxes();
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ air_ease: 0 });
	self.removeTimer(self.moveIt);
	self.setYVelocity(0);
	self.setXVelocity(0);
	return;
}


function b_up_air__frame15() {
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ allowControl: true, air_ease: -1, xSpeedDecay: 0, xSpeedDecayAir: 0 });
	return;
}


function b_up_air__frame2() {
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	return;
}


function b_up_air__frame23() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("loop");
	return;
}


function b_up_air__frame3() {
	// [FM] setIntangibility(false) removed — duration encoded above
	self.updateHitboxStats(1, { damage: 1 });
	self.reactivateHitboxes();
	// [SSF2-only: playSound] self.playSound("mario_uspec");
	self.controls = self.getHeldControls();
	if ((self.facingRight && self.controls.LEFT) || !self.facingRight) {
		self.angle = self.angle + self.angleAlt;
	}
	if ((self.facingRight && self.controls.RIGHT) || !self.facingRight) {
		self.angle = self.angle - self.angleAlt;
	}
	self.angle = 45;
	self.updateHitboxStats(1, { angle: self.angle });
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toHeavyLand);
	self.addEventListener(SSF2Event.CHAR_ATTACK_COMPLETE, self.toHelpless);
	self.addTimer(1, -1, self.moveIt);
	return;
}


function b_up_air__frame4() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame5() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame6() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame7() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame8() {
	self.reactivateHitboxes();
	return;
}


function b_up_air__frame9() {
	self.reactivateHitboxes();
	return;
}


function climbup__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 15);
	// [SSF2-only: playSound] self.playSound("mario_lift");
	return;
}


function climbup__frame15() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function climbup__frame16() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function climbup__frame3() {
	// [SSF2-only: playSound] self.playSound("mario_runstart");
	return;
}


function climbup__frame6() {
	self.setXVelocity(6, false);
	return;
}


function climbup__frame8() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function crash__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function crouch__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function crouch__frame3() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "crouchdown", true);
	return;
}


function crouch__frame4() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("loop");
	return;
}


function defend__frame0() {
// [FM] isReady guard removed — always true in Fraymakers
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.addEventListener(SSF2Event.CHAR_SHIELD_HIT, self.outOfShield);
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function defend__frame4() {
	// [SSF2-only: stop] self.stop();
	return;
}


function defend__frame5() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("pause");
	return;
}


function dizzy__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
	} else {
		// [SSF2-only: playSound] self.playSound("mario_dizzy", true);
	}
	return;
}


function dizzy__frame37() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("loop");
	return;
}


function egg__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function entrance__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	return;
}


function entrance__frame29() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landHeavy");
}


function entrance__frame39() {
	SSF2API.getCharacter(self).endAnimation();
	return;
}


function entrance__frame8() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
	} else {
		// [SSF2-only: playSound] self.playSound("letsago", true);
	}
	// [SSF2-only: playSound] self.playSound("mario_jumpsfx");
	return;
}


function fall__frame0() {
	// self reference (implicit in FM)
	return;
}


function fall__frame11() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("again");
	return;
}


function falling__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function frame1() {
	self.xframe = "stand";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame10() {
	self.xframe = "fall";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame11() {
	self.xframe = "land";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame12() {
	self.xframe = "heavyland";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame13() {
	self.xframe = "skid";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame14() {
	self.xframe = "a";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame15() {
	self.xframe = "a_forward";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame16() {
	self.xframe = "a_forward_tilt";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame17() {
	self.xframe = "a_forwardsmash";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame18() {
	self.xframe = "a_up";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame19() {
	self.xframe = "a_up_tilt";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame2() {
	self.xframe = "entrance";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame20() {
	self.xframe = "a_down";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame21() {
	self.xframe = "b";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame22() {
	self.xframe = "b_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame23() {
	self.xframe = "b_up";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame24() {
	self.xframe = "b_up_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame25() {
	self.xframe = "b_forward";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame26() {
	self.xframe = "b_forward_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame27() {
	self.xframe = "b_down";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame28() {
	self.xframe = "b_down_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame29() {
	self.xframe = "a_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame3() {
	self.xframe = "revival";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame30() {
	self.xframe = "a_air_up";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame31() {
	self.xframe = "a_air_forward";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame32() {
	self.xframe = "a_air_backward";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame33() {
	self.xframe = "a_air_down";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame34() {
	self.xframe = "throw_up";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame35() {
	self.xframe = "throw_forward";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame36() {
	self.xframe = "throw_down";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame37() {
	self.xframe = "throw_back";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame38() {
	self.xframe = "item_pickup";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame39() {
	self.xframe = "item_jab";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame4() {
	self.xframe = "win";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame40() {
	self.xframe = "item_dash";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame41() {
	self.xframe = "item_tilt";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame42() {
	self.xframe = "item_smash";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame43() {
	self.xframe = "item_homerun";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame44() {
	self.xframe = "item_fan";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame45() {
	self.xframe = "item_shoot";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame46() {
	self.xframe = "item_raise";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame47() {
	self.xframe = "item_float";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame48() {
	self.xframe = "item_screw";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame49() {
	self.xframe = "crouch";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame5() {
	self.xframe = "lose";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame50() {
	self.xframe = "crouch_attack";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame51() {
	self.xframe = "grab";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame52() {
	self.xframe = "hurt";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame53() {
	self.xframe = "dodgeroll";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame54() {
	self.xframe = "airdodge";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame55() {
	self.xframe = "sidestep";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame56() {
	self.xframe = "flying";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame57() {
	self.xframe = "hang";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame58() {
	self.xframe = "climbup";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame59() {
	self.xframe = "rollup";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame6() {
	self.xframe = "walk";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame60() {
	self.xframe = "ledge_attack";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame61() {
	self.xframe = "roll";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame62() {
	self.xframe = "defend";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame63() {
	self.xframe = "stunned";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame64() {
	self.xframe = "dizzy";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame65() {
	self.xframe = "sleep";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame66() {
	self.xframe = "falling";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame67() {
	self.xframe = "crash";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame68() {
	self.xframe = "getup_attack";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame69() {
	self.xframe = "carry";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame7() {
	self.xframe = "run";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame70() {
	self.xframe = "swim";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame71() {
	self.xframe = "ladder";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame72() {
	self.xframe = "edgelean";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame73() {
	self.xframe = "wallstick";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame74() {
	self.xframe = "frozen";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame75() {
	self.xframe = "taunt";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame76() {
	self.xframe = "egg";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame77() {
	self.xframe = "star";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame78() {
	self.xframe = "special";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame79() {
	self.xframe = "starko";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame8() {
	self.xframe = "jump";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame80() {
	self.xframe = "screenko";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame81() {
	self.xframe = "pitfall";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame82() {
	self.xframe = "tech_ground";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame83() {
	self.xframe = "tech_roll";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame84() {
	self.xframe = "toss";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame85() {
	self.xframe = "toss_air";
	// [SSF2-only: stop] self.stop();
	return;
}


function frame9() {
	self.xframe = "jump_midair";
	// [SSF2-only: stop] self.stop();
	return;
}


function frozen__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function getup_attack__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function getup_attack__frame11() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	return;
}


function getup_attack__frame13() {
	// [SSF2-only: setIntangibility] self.setIntangibility(false); //TODO: intangibility set outside this script
	return;
}


function getup_attack__frame24() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function getup_attack__frame3() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function getup_attack__frame7() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	return;
}


function grab__frame0() {
	// self reference (implicit in FM)
	self.xframe = "grab";
	return;
}


function grab__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function grab__frame16() {
	self.xframe = "grab";
	self.setXVelocity(self.getXVelocity() * 1.25);
	return;
}


function grab__frame2() {
	// [SSF2-only: playSound] SSF2API.playSound("grab_swing4");
	return;
}


function grab__frame20() {
	// [SSF2-only: playSound] SSF2API.playSound("grab_swing6");
	return;
}


function grab__frame21() {
	self.setXVelocity(0);
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	return;
}


function grab__frame3() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	return;
}


function grab__frame36() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function grab__frame37() {
	self.xframe = "grab";
	self.target = null;
	self.grab = 0;
	// [SSF2-only: getCPULevel] if ((self.isCPU() && self.getCPULevel() >= 7) || self.target != null) {
	}
}


function grab__frame38() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("grabbed");
	return;
}


function grab__frame39() {
	self.xframe = "attack";
	return;
}


function grab__frame44() {
	self.updateHitboxStats(1, { effect_id: "effect_lightHit" });
	return;
}


function grab__frame45() {
	// [SSF2-only: playSound] self.playSound("mario_kick_l");
	return;
}


function grab__frame49() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("grabbed");
	return;
}


function hang__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function hang__frame6() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("loop");
	return;
}


function hurt__frame0() {
	// self reference (implicit in FM)
	self.xframe = "hurt1";
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function hurt__frame10() {
	self.xframe = "hurt2";
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function hurt__frame18() {
	self.xframe = "done1";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame19() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done2");
	return;
}


function hurt__frame20() {
	self.xframe = "hurt3";
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function hurt__frame28() {
	self.xframe = "done1";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame29() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done3");
	return;
}


function hurt__frame30() {
	self.xframe = "downed";
	return;
}


function hurt__frame38() {
	self.xframe = "downed";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame39() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("downed");
	return;
}


function hurt__frame40() {
	self.xframe = "shock";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame49() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("shock");
	return;
}


function hurt__frame50() {
	self.setAttackEnabled(true, "b_up");
	self.setAttackEnabled(true, "b_up_air");
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", 0);
	return;
}


function hurt__frame58() {
	self.xframe = "ball";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame59() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("ball");
	return;
}


function hurt__frame8() {
	self.xframe = "done1";
	// [SSF2-only: stop] self.stop();
	return;
}


function hurt__frame9() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done1");
	return;
}


function item_dash__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_dash__frame23() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_dash__frame5() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	return;
}


function item_dash__frame7() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	return;
}


function item_fan__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_fan__frame2() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	return;
}


function item_fan__frame3() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	return;
}


function item_fan__frame5() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_homerun__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_homerun__frame10() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy", { x: self.flipX(30), y: 3 });
	return;
}


function item_homerun__frame16() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy", { x: self.flipX(30), y: 3 });
	return;
}


function item_homerun__frame22() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy", { x: self.flipX(30), y: 3 });
	return;
}


function item_homerun__frame28() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy", { x: self.flipX(30), y: 3 });
	return;
}


function item_homerun__frame30() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	self.playAttackVoice(/* voice index: */1);
	return;
}


function item_homerun__frame32() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	return;
}


function item_homerun__frame4() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_heavy", { x: self.flipX(30), y: 3 });
	return;
}


function item_homerun__frame45() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_jab__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_jab__frame12() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_jab__frame3() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	return;
}


function item_jab__frame4() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	return;
}


function item_pickup__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_pickup__frame1() {
	// [SSF2-only: pickupItem] self.pickupItem();
	// [SSF2-only: attachEffect] self.attachEffect("itempickup_effect", { x: self.flipX(0), y: 0 });
	return;
}


function item_pickup__frame4() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_raise__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_raise__frame16() {
	// [SSF2-only: playSound] SSF2API.playSound("mario_jumpsfx");
	return;
}


function item_raise__frame26() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function item_raise__frame30() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_raise__frame7() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	return;
}


function item_shoot__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_shoot__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_shoot__frame3() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	return;
}


function item_smash__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_smash__frame4() {
	self.xframe = "charging";
	return;
}


function item_smash__frame44() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("charging");
	return;
}


function item_smash__frame45() {
	self.xframe = "attack";
	return;
}


function item_smash__frame47() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	self.playAttackVoice(/* voice index: */1);
	return;
}


function item_smash__frame49() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ chargetime_max: 0 });
	return;
}


function item_smash__frame65() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_tilt__frame0() {
	// self reference (implicit in FM)
	return;
}


function item_tilt__frame18() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function item_tilt__frame6() {
	// [SSF2-only: getItem] self.getItem().activateItem();
	// [SSF2-only: playAttackSound] self.playAttackSound(1);
	return;
}


function item_tilt__frame8() {
	// [SSF2-only: getItem] self.getItem().deactivateItem();
	return;
}


function jump__frame0() {
	// self reference (implicit in FM)
	self.xframe = "midair";
	self.done = false;
// [FM] isReady guard removed — always true in Fraymakers
}


function jump__frame25() {
	self.done = true;
	// [SSF2-only: stop] self.stop();
	return;
}


function jump__frame26() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done");
	return;
}


function jump__frame49() {
	self.done = true;
	// [SSF2-only: stop] self.stop();
	return;
}


function jump__frame50() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done2");
	return;
}


function jump_midair__frame0() {
	// self reference (implicit in FM)
	self.rand = 0;
// [FM] isReady guard removed — always true in Fraymakers
}


function jump_midair__frame18() {
	self.done = true;
	// [SSF2-only: stop] self.stop();
	return;
}


function jump_midair__frame19() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done");
	return;
}


function jump_midair__frame24() {
	// [SSF2-only: playSound] self.playSound("mario_backjump");
	return;
}


function jump_midair__frame28() {
	// [SSF2-only: playSound] self.playSound("mario_backjump");
	return;
}


function jump_midair__frame32() {
	// [SSF2-only: playSound] self.playSound("mario_backjump");
	return;
}


function jump_midair__frame36() {
	// [SSF2-only: playSound] self.playSound("mario_backjump");
	return;
}


function jump_midair__frame45() {
	self.done = true;
	// [SSF2-only: stop] self.stop();
	return;
}


function jump_midair__frame46() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("done2");
	return;
}


function land__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
		return;
	}
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function land__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function land__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function land__frame2() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function ledge_attack__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 12);
	return;
}


function ledge_attack__frame11() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_light");
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function ledge_attack__frame12() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function ledge_attack__frame16() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function ledge_attack__frame24() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function ledge_attack__frame3() {
	// [SSF2-only: playSound] self.playSound("mario_runstart");
	return;
}


function ledge_attack__frame9() {
	// [SSF2-only: playSound] self.playSound("brawl_swing_l");
	self.setXVelocity(8, false);
	self.setYVelocity(-4);
	return;
}


function revival__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	// [SSF2-only: setIntangibility] self.setIntangibility(false); //TODO: intangibility set outside this script
	return;
}


function roll__frame0() {
	// self reference (implicit in FM)
	return;
}


function roll__frame1() {
	// [SSF2-only: attachEffect] self.effect = self.attachEffect("global_dust_heavy", { scaleX: 0.8, scaleY: 0.8 });
	self.effect.scaleX = -self.effect.scaleX;
	return;
}


function roll__frame15() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function roll__frame2() {
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 6);
	return;
}


function roll__frame8() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function rollup__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	// [SSF2-only: playSound] self.playSound("mario_lift");
// [FM] isReady guard removed — always true in Fraymakers
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 18);
	return;
}


function rollup__frame18() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function rollup__frame19() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m1");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep");
}


function rollup__frame23() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m2");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep2");
}


function rollup__frame24() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function rollup__frame3() {
	// [SSF2-only: playSound] self.playSound("mario_runstart");
	return;
}


function rollup__frame6() {
	return;
}


function run__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function run__frame10() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m2");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep2");
}


function run__frame14() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("run");
	return;
}


function run__frame15() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	// [SSF2-only: playSound] self.playSound("mario_runstart");
	return;
}


function run__frame20() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("run");
	return;
}


function run__frame21() {
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function run__frame3() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m1");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep");
}


function run__frame30() {
	// [SSF2-only: playSound] self.playSound("mario_runstop");
	return;
}


function run__frame32() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("run");
	return;
}


function sidestep__frame0() {
	// self reference (implicit in FM)
	return;
}


function sidestep__frame1() {
	self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 7);
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud", { scaleX: 0.8, scaleY: 0.8 });
	return;
}


function sidestep__frame13() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function sidestep__frame8() {
	// [FM] setIntangibility(false) removed — duration encoded above
	return;
}


function skid__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function skid__frame6() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function sleep__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function stand__frame0() {
	// self reference (implicit in FM)
	self.rand = 0;
	if (self.repeats) {
	} else {
		self.repeats = 0;
	}
// [FM] isReady guard removed — always true in Fraymakers
	self.rand = Random.getInt(0, 3);
	self.repeats = 0;
	// [SSF2-only: gotoAndStop] self.gotoAndStop("bored");
// [FM] isReady guard removed — always true in Fraymakers
}


function stand__frame104() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("loop");
	return;
}


function stand__frame107() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("loop");
	return;
}


function stand__frame35() {
	_v1 = self;
	_v2 = self.repeats + 1;
	self.repeats = self.repeats + 1;
	// [SSF2-only: gotoAndStop] self.gotoAndStop("loop");
	return;
}


function star__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	return;
}


function taunt__frame0() {
	// self reference (implicit in FM)
	return;
}


function taunt__frame1() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
	} else {
		// [SSF2-only: playSound] self.playSound("mario_tauntSide", true);
	}
	return;
}


function taunt__frame114() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function taunt__frame115() {
	// [SSF2-only: playSound] self.playSound("MarioDTauntSpin");
	return;
}


function taunt__frame147() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	SSF2API.getCamera().shake(2);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_heavyLand");
}


function taunt__frame164() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function taunt__frame41() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function taunt__frame46() {
	// [SSF2-only: playSound] self.playSound("mario_grow1");
	return;
}


function taunt__frame94() {
	// [SSF2-only: playSound] self.playSound("mario_grow2");
	return;
}


function tech_ground__frame0() {
	// self reference (implicit in FM)
	SSF2API.getCamera().shake(3);
// [FM] isReady guard removed — always true in Fraymakers
	self.ready = false;
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_m");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function tech_ground__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function tech_ground__frame10() {
	// [SSF2-only: setIntangibility] self.setIntangibility(false); //TODO: intangibility set outside this script
	return;
}


function tech_ground__frame12() {
	// [SSF2-only: attachEffect] self.attachEffect("effect_land");
	SSF2API.getCamera().shake(2);
// [FM] isReady guard removed — always true in Fraymakers
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function tech_ground__frame13() {
	// [SSF2-only: stop] self.stop();
	self.ready = true;
	return;
}


function tech_ground__frame13() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function tech_ground__frame14() {
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("dead");
	return;
}


function tech_ground__frame15() {
	// [SSF2-only: isForcedCrash] if (self.isForcedCrash()) {
	} else {
		self.applyGlobalBodyStatus(BodyStatus.INTANGIBLE, 10);
	}
	return;
}


function tech_ground__frame25() {
	// [SSF2-only: isForcedCrash] if (self.isForcedCrash()) {
	} else {
		// [FM] setIntangibility(false) removed — duration encoded above
	}
	return;
}


function tech_ground__frame30() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function tech_ground__frame35() {
	// [SSF2-only: gotoAndStop] self.gotoAndStop("standloop");
	return;
}


function tech_ground__frame36() {
	if (self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "standtime") == 0) {
	}
	if (/* ? */ == /* ? */ - 1) {
	} else {
		// [SSF2-only: gotoAndStop] /* ? */.gotoAndStop(/* ? */);
		self.addTimer(1, -1, self.standCountdown);
		return;
	}
}


function tech_ground__frame46() {
	// [SSF2-only: attachEffect] self.attachEffect("effect_land");
	SSF2API.getCamera().shake(2);
// [FM] isReady guard removed — always true in Fraymakers
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_land_s");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_landLight");
}


function tech_ground__frame49() {
	if (self.getState() != CState.CRASH_GETUP) {
	} else {
		self.setState(CState.CRASH_LAND);
	}
	// [SSF2-only: gotoAndStop] self.gotoAndStop("dead");
	return;
}


function tech_roll__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function tech_roll__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function tech_roll__frame10() {
	// [SSF2-only: setIntangibility] self.setIntangibility(false); //TODO: intangibility set outside this script
	return;
}


function tech_roll__frame11() {
	// [SSF2-only: setIntangibility] self.setIntangibility(false); //TODO: intangibility set outside this script
	return;
}


function tech_roll__frame17() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function tech_roll__frame20() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function throw_back__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.enemy = self.getGrabbedOpponents()[0];
	self.swapDepths(self.enemy);
	return;
}


function throw_back__frame1() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_back__frame10() {
	self.enemy.flip();
	return;
}


function throw_back__frame12() {
	self.swapDepths(self.enemy);
	return;
}


function throw_back__frame16() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	self.enemy.flip();
	return;
}


function throw_back__frame18() {
	self.swapDepths(self.enemy);
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function throw_back__frame20() {
	self.enemy.flip();
	return;
}


function throw_back__frame22() {
	self.swapDepths(self.enemy);
	return;
}


function throw_back__frame24() {
	SSF2API.getCamera().shake(9);
	self.enemy.flip();
	return;
}


function throw_back__frame26() {
	self.playAttackVoice(/* voice index: */1);
	return;
}


function throw_back__frame32() {
	self.flip();
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function throw_back__frame6() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	self.enemy.flip();
	return;
}


function throw_back__frame8() {
	self.swapDepths(self.enemy);
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function throw_down__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
// [FM] isReady guard removed — always true in Fraymakers
	self.enemy = self.getGrabbedOpponents()[0];
	self.swapDepths(self.enemy);
	return;
}


function throw_down__frame1() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_down__frame10() {
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	SSF2API.getCamera().shake(9);
	return;
}


function throw_down__frame20() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function throw_down__frame9() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_forward__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.enemy = null;
// [FM] isReady guard removed — always true in Fraymakers
	self.enemy = self.getGrabbedOpponents()[0];
	self.swapDepths(self.enemy);
	return;
}


function throw_forward__frame1() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_forward__frame10() {
	self.swapDepths(self.enemy);
	SSF2API.getCamera().shake(9);
	return;
}


function throw_forward__frame14() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function throw_forward__frame4() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_forward__frame6() {
	self.enemy.flip();
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function throw_forward__frame7() {
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function throw_forward__frame9() {
	self.swapDepths(self.enemy);
	self.enemy.flip();
	return;
}


function throw_up__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.playsound = Random.getFloat(0, 1);
	self.audio = self.getAnimationStatsMetadata(/* TODO: getGlobalVariable */ "audio");
	self.enemy = self.getGrabbedOpponents()[0];
	self.swapDepths(self.enemy);
	return;
}


function throw_up__frame1() {
	// [SSF2-only: playSound] self.playSound("throw_woosh");
	return;
}


function throw_up__frame12() {
	SSF2API.getCamera().shake(9);
	if ((self.playsound > 0.2 && self.playsound <= 0.4) || self.audio != 1) {
		self.playAttackVoice(/* voice index: */1);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 1);
	}
	if ((self.playsound > 0.4 && self.playsound <= 0.6) || self.audio != 2) {
		self.playAttackVoice(/* voice index: */2);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 2);
	}
	if ((self.playsound > 0.6 && self.playsound <= 0.8) || self.audio != 3) {
		self.playAttackVoice(/* voice index: */3);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 3);
	}
	if ((self.playsound > 0.8 && self.playsound <= 1) || self.audio != 4) {
		self.playAttackVoice(/* voice index: */4);
		self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "audio", 4);
	}
	return;
}


function throw_up__frame21() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss__frame0() {
	// self reference (implicit in FM)
	return;
}


function toss__frame1() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	return;
}


function toss__frame10() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss__frame12() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	return;
}


function toss__frame14() {
	// [SSF2-only: tossItem] self.tossItem(270);
	return;
}


function toss__frame22() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss__frame24() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	return;
}


function toss__frame26() {
	// [SSF2-only: tossItem] self.tossItem(90);
	return;
}


function toss__frame3() {
	// [SSF2-only: tossItem] self.tossItem(158);
	return;
}


function toss__frame34() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss__frame36() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_cloud");
	return;
}


function toss__frame38() {
	// [SSF2-only: tossItem] self.tossItem(12);
	return;
}


function toss__frame46() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss_air__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
}


function toss_air__frame1() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function toss_air__frame10() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss_air__frame11() {
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	return;
}


function toss_air__frame12() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function toss_air__frame14() {
	// [SSF2-only: tossItem] self.tossItem(270);
	return;
}


function toss_air__frame22() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss_air__frame23() {
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	return;
}


function toss_air__frame24() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function toss_air__frame26() {
	// [SSF2-only: tossItem] self.tossItem(90);
	return;
}


function toss_air__frame3() {
	// [SSF2-only: tossItem] self.tossItem(158);
	return;
}


function toss_air__frame34() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function toss_air__frame35() {
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	return;
}


function toss_air__frame36() {
	// [SSF2-only: attachEffect] self.attachEffect("global_dust_swirl");
	return;
}


function toss_air__frame38() {
	// [SSF2-only: tossItem] self.tossItem(12);
	return;
}


function toss_air__frame46() {
	// [FM] endAnimation removed — redundant on last frame
	return;
}


function walk__frame0() {
	// self reference (implicit in FM)
// [FM] isReady guard removed — always true in Fraymakers
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "canStartRise", true);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab", false);
	self.updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ "jab2", false);
	return;
}


function walk__frame14() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m2");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep2");
}


function walk__frame4() {
	// [SSF2-only: getMetalStatus] if (self.getMetalStatus()) {
		// [SSF2-only: playSound] self.playSound("metal_step_m1");
		return;
	}
	// [SSF2-only: playSound] self.playSound("mario_footstep");
}


function win__frame197() {
	self.gotoAndPlay("loop");
	return;
}


function win__frame39() {
	// [SSF2-only: playSound] SSF2API.playSound("mario_win2", true);
	// [SSF2-only: playSound] self.fire = SSF2API.playSound("mario_finale");
	return;
}


function win__frame81() {
	// [SSF2-only: playSound] SSF2API.playSound("mario_win2_pt2", true);
	return;
}


function win__frame86() {
	SSF2API.stopSound(self.fire);
	return;
}



// ── Jab chain — SSF2 Jab_21 sub-animations (begin / hit2 / hit3) ─────────────────
// SSF2 uses gotoAndPlay("hit2") / gotoAndPlay("hit3") to chain jabs on button press.
// In Fraymakers, jab1/jab2/jab3 are separate animations chained via CState transitions.

// Called from AnimationStats.jab1 last-frame handler (link in FrayTools):
function jab1_end() {
	if (entity.checkInput(ControlsObject.ATTACK)) {
		// Player pressed attack again — chain to jab2
		entity.setAnimation("jab2");
		entity.playCState(CState.JAB2);
	} else {
		// No input — return to idle
		entity.playCState(CState.IDLE);
	}
}

// Called from AnimationStats.jab2 last-frame handler:
function jab2_end() {
	if (entity.checkInput(ControlsObject.ATTACK)) {
		entity.setAnimation("jab3");
		entity.playCState(CState.JAB3);
	} else {
		entity.playCState(CState.IDLE);
	}
}

// Called from AnimationStats.jab3 last-frame handler:
function jab3_end() {
	entity.playCState(CState.IDLE);
}
