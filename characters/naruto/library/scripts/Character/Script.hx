// API Script for naruto — converted from SSF2
// Frame scripts are embedded in the entity file (FRAME_SCRIPT layers).
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
	Engine.log("Naruto initialized.");
	self.addEventListener(SSF2Event.ATTACK_ENABLED, self.onAttackEnabled, { persistent: true });
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


function onAttackEnabled(arg0) {
	if (!self.isDisposed()) {
		!self.isDisposed();
	}
	if ((arg0.data.attackData.name == "b_down" ? arg0.data.attackData.name == "b_down" : arg0.data.attackData.name == "b_down_air")) {
	} else {
		return;
	}
	SSF2API.removeEventListener(SSF2Event.GAME_TICK_END, self.recolorReenabledEffects);
	if (self.downBReenableEffectMC && self.downBReenableEffectMC.parent) {
	}
}


function recolorReenabledEffects(arg0) {
	_v2 = null;
	if (self.isDisposed()) {
		SSF2API.removeEventListener(SSF2Event.GAME_TICK_END, self.recolorReenabledEffects);
		return;
	}
	if ((!self.downBReenableEffectMC ? !self.downBReenableEffectMC : !self.downBReenableEffectMC.parent)) {
		SSF2API.removeEventListener(SSF2Event.GAME_TICK_END, self.recolorReenabledEffects);
		return;
	}
	_v2 = self.getPaletteSwapData();
	self.applyPalette(self.downBReenableEffectMC);
	if (self.getPaletteSwapData()) {
		SSF2Utils.replacePalette(self.downBReenableEffectMC, _v2.paletteSwap);
	}
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
