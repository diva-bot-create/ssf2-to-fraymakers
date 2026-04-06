// API Script for jigglypuff — converted from SSF2
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


function ssf2_initialize() {
	Engine.log("Jigglypuff initialized.");
	return;
}


function jumpToContinue(arg0) {
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	// [SSF2-only: updateAttackStats] self.updateAttackStats({ allowControl: false, cancelWhenAirborne: true });
	// [SSF2-only: stancePlayFrame] self.stancePlayFrame("continue");
	return;
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


function restOnReaction() {
	_v1 = null;
	if ((self.getCPUForcedAction() == -1 ? self.getCPUForcedAction() == -1 : self.getCPUForcedAction() == 5)) {
	} else {
		return;
	}
	_v1 = self.getCPUTarget();
	// [SSF2-only: getMC] if ((self.getCPUTarget() && Random.getFloat(0, 1) < 0.5) || _v1.getMC().currentLabel != "defend") {
	}
	// [SSF2-only: getMC] if ((/* ? */ && _v1.getMC().currentLabel != "revival") || !self.inUpperRightWarningBounds()) {
	}
	// [SSF2-only: inUpperLeftWarningBounds] if ((/* ? */ && !self.inUpperLeftWarningBounds()) || !self.inLowerLeftWarningBounds()) {
	}
	if ((/* ? */ && _v1.getX() > self.getX() - 10) || _v1.getY() < self.getY() + 10) {
	}
	if (/* ? */) {
		self.importCPUControls([1088, 1]);
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


function startRestOnReaction() {
	// [SSF2-only: getCPULevel] if (self.isCPU() && self.getCPULevel() == 9) {
	}
}


function stopListening() {
	self.clearListener = false;
	self.removeEventListener(GameObjectEvent.LINK_FRAMES, self.removeAllEffects);
	return;
}


function stopRestOnReaction() {
	self.removeTimer(self.restOnReaction);
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
