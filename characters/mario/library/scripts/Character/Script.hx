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
		SSF2API.print("Tried to add a NULL effect to list!");
		return null;
	} else {
		self.effects.push(arg0);
		return arg0;
	}
}


function clearEffectsOnStateChange(arg0) {
	self.clearListener = arg0;
	self.addEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
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
		self.createTimer(1, 0, updatePos, options);
		return;
	}
	self.destroyTimer(updatePos);
}


function ssf2_initialize() {
	SSF2API.print("Mario initialized.");
	return;
}


function jumpToContinue(arg0) {
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	self.updateAttackStats({ allowControl: false, cancelWhenAirborne: true });
	self.stancePlayFrame("continue");
	return;
}


function loopEffect(arg0, arg1, arg2) {
	var doLoop = function() {
		effectMC.gotoAndStop(1);
		return;
	};
	var options = { hitStunPause: false };
	if (arg2) {
		var options = { persistent: true, hitStunPause: false };
	} else {
		var options = { persistent: false, hitStunPause: false };
	}
	if (arg0) {
		self.createTimer(1, 0, doLoop, { hitStunPause: false });
		return;
	}
	self.destroyTimer(doLoop);
}


function pushEffectBehind(arg0) {
	SSF2API.getStage().getMidground().swapChildren(self.getMC(), arg0);
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
	if ((self.clearListener && self.hasEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects)) || arg0 != null) {
		self.removeEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	}
	return;
}


function setLandingLag(arg0) {
	if (arg0) {
		self.removeEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
		self.addEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
		if (self.isOnFloor()) {
			self.jumpToContinue();
		}
		return;
	}
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	if (self.isOnFloor()) {
		self.toLand();
	}
}


function stopListening() {
	self.clearListener = false;
	self.removeEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	return;
}


// ── Frame scripts (85 methods) ──────────────────────────────────────────────
// NOTE: These are SSF2 timeline frame methods, named by global frame number.
// They need to be manually assigned to animation FRAME_SCRIPT layers in FrayTools.

function frame1() {
	self.xframe = "stand";
	self.stop();
	return;
}


function frame10() {
	self.xframe = "fall";
	self.stop();
	return;
}


function frame11() {
	self.xframe = "land";
	self.stop();
	return;
}


function frame12() {
	self.xframe = "heavyland";
	self.stop();
	return;
}


function frame13() {
	self.xframe = "skid";
	self.stop();
	return;
}


function frame14() {
	self.xframe = "a";
	self.stop();
	return;
}


function frame15() {
	self.xframe = "a_forward";
	self.stop();
	return;
}


function frame16() {
	self.xframe = "a_forward_tilt";
	self.stop();
	return;
}


function frame17() {
	self.xframe = "a_forwardsmash";
	self.stop();
	return;
}


function frame18() {
	self.xframe = "a_up";
	self.stop();
	return;
}


function frame19() {
	self.xframe = "a_up_tilt";
	self.stop();
	return;
}


function frame2() {
	self.xframe = "entrance";
	self.stop();
	return;
}


function frame20() {
	self.xframe = "a_down";
	self.stop();
	return;
}


function frame21() {
	self.xframe = "b";
	self.stop();
	return;
}


function frame22() {
	self.xframe = "b_air";
	self.stop();
	return;
}


function frame23() {
	self.xframe = "b_up";
	self.stop();
	return;
}


function frame24() {
	self.xframe = "b_up_air";
	self.stop();
	return;
}


function frame25() {
	self.xframe = "b_forward";
	self.stop();
	return;
}


function frame26() {
	self.xframe = "b_forward_air";
	self.stop();
	return;
}


function frame27() {
	self.xframe = "b_down";
	self.stop();
	return;
}


function frame28() {
	self.xframe = "b_down_air";
	self.stop();
	return;
}


function frame29() {
	self.xframe = "a_air";
	self.stop();
	return;
}


function frame3() {
	self.xframe = "revival";
	self.stop();
	return;
}


function frame30() {
	self.xframe = "a_air_up";
	self.stop();
	return;
}


function frame31() {
	self.xframe = "a_air_forward";
	self.stop();
	return;
}


function frame32() {
	self.xframe = "a_air_backward";
	self.stop();
	return;
}


function frame33() {
	self.xframe = "a_air_down";
	self.stop();
	return;
}


function frame34() {
	self.xframe = "throw_up";
	self.stop();
	return;
}


function frame35() {
	self.xframe = "throw_forward";
	self.stop();
	return;
}


function frame36() {
	self.xframe = "throw_down";
	self.stop();
	return;
}


function frame37() {
	self.xframe = "throw_back";
	self.stop();
	return;
}


function frame38() {
	self.xframe = "item_pickup";
	self.stop();
	return;
}


function frame39() {
	self.xframe = "item_jab";
	self.stop();
	return;
}


function frame4() {
	self.xframe = "win";
	self.stop();
	return;
}


function frame40() {
	self.xframe = "item_dash";
	self.stop();
	return;
}


function frame41() {
	self.xframe = "item_tilt";
	self.stop();
	return;
}


function frame42() {
	self.xframe = "item_smash";
	self.stop();
	return;
}


function frame43() {
	self.xframe = "item_homerun";
	self.stop();
	return;
}


function frame44() {
	self.xframe = "item_fan";
	self.stop();
	return;
}


function frame45() {
	self.xframe = "item_shoot";
	self.stop();
	return;
}


function frame46() {
	self.xframe = "item_raise";
	self.stop();
	return;
}


function frame47() {
	self.xframe = "item_float";
	self.stop();
	return;
}


function frame48() {
	self.xframe = "item_screw";
	self.stop();
	return;
}


function frame49() {
	self.xframe = "crouch";
	self.stop();
	return;
}


function frame5() {
	self.xframe = "lose";
	self.stop();
	return;
}


function frame50() {
	self.xframe = "crouch_attack";
	self.stop();
	return;
}


function frame51() {
	self.xframe = "grab";
	self.stop();
	return;
}


function frame52() {
	self.xframe = "hurt";
	self.stop();
	return;
}


function frame53() {
	self.xframe = "dodgeroll";
	self.stop();
	return;
}


function frame54() {
	self.xframe = "airdodge";
	self.stop();
	return;
}


function frame55() {
	self.xframe = "sidestep";
	self.stop();
	return;
}


function frame56() {
	self.xframe = "flying";
	self.stop();
	return;
}


function frame57() {
	self.xframe = "hang";
	self.stop();
	return;
}


function frame58() {
	self.xframe = "climbup";
	self.stop();
	return;
}


function frame59() {
	self.xframe = "rollup";
	self.stop();
	return;
}


function frame6() {
	self.xframe = "walk";
	self.stop();
	return;
}


function frame60() {
	self.xframe = "ledge_attack";
	self.stop();
	return;
}


function frame61() {
	self.xframe = "roll";
	self.stop();
	return;
}


function frame62() {
	self.xframe = "defend";
	self.stop();
	return;
}


function frame63() {
	self.xframe = "stunned";
	self.stop();
	return;
}


function frame64() {
	self.xframe = "dizzy";
	self.stop();
	return;
}


function frame65() {
	self.xframe = "sleep";
	self.stop();
	return;
}


function frame66() {
	self.xframe = "falling";
	self.stop();
	return;
}


function frame67() {
	self.xframe = "crash";
	self.stop();
	return;
}


function frame68() {
	self.xframe = "getup_attack";
	self.stop();
	return;
}


function frame69() {
	self.xframe = "carry";
	self.stop();
	return;
}


function frame7() {
	self.xframe = "run";
	self.stop();
	return;
}


function frame70() {
	self.xframe = "swim";
	self.stop();
	return;
}


function frame71() {
	self.xframe = "ladder";
	self.stop();
	return;
}


function frame72() {
	self.xframe = "edgelean";
	self.stop();
	return;
}


function frame73() {
	self.xframe = "wallstick";
	self.stop();
	return;
}


function frame74() {
	self.xframe = "frozen";
	self.stop();
	return;
}


function frame75() {
	self.xframe = "taunt";
	self.stop();
	return;
}


function frame76() {
	self.xframe = "egg";
	self.stop();
	return;
}


function frame77() {
	self.xframe = "star";
	self.stop();
	return;
}


function frame78() {
	self.xframe = "special";
	self.stop();
	return;
}


function frame79() {
	self.xframe = "starko";
	self.stop();
	return;
}


function frame8() {
	self.xframe = "jump";
	self.stop();
	return;
}


function frame80() {
	self.xframe = "screenko";
	self.stop();
	return;
}


function frame81() {
	self.xframe = "pitfall";
	self.stop();
	return;
}


function frame82() {
	self.xframe = "tech_ground";
	self.stop();
	return;
}


function frame83() {
	self.xframe = "tech_roll";
	self.stop();
	return;
}


function frame84() {
	self.xframe = "toss";
	self.stop();
	return;
}


function frame85() {
	self.xframe = "toss_air";
	self.stop();
	return;
}


function frame9() {
	self.xframe = "jump_midair";
	self.stop();
	return;
}


