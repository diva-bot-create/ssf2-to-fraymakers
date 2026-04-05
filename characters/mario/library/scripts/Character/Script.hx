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
	if (/* ? */ == self) {
		SSF2API.print("Tried to add a NULL effect to list!");
		return null;
	} else {
		self.effects.push(_v1);
		return _v1;
	}
}


function clearEffectsOnStateChange(arg0) {
	self.clearListener = _v1;
	self.addEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	return;
}


function flipX(arg0) {
	if (!self.isFacingRight()) {
		return _v1;
	} else {
		return _v1 * -1;
	}
}


function followUser(arg0, arg1, arg2) {
	_v4 = self;
	if (!/* ? */) {
	}
	if (!/* ? */) {
		/* ? */.createTimer(/* ? */, self, 1, 0);
	} else {
		/* ? */.destroyTimer(self);
	}
	return;
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
	_v4 = self;
	if (!/* ? */) {
	}
	if (!/* ? */) {
		/* ? */.createTimer(self, 1, 0, { hitStunPause: false });
	}
	/* ? */.destroyTimer(self);
	return;
}


function pushEffectBehind(arg0) {
	SSF2API.getStage().getMidground().swapChildren(self.getMC(), _v1);
	return _v1;
}


function removeAllEffects(arg0) {
	_v2 = 0;
	while (/* ? */ < /* ? */) {
		self.effects = new Array();
		if (!self.clearListener) {
			self.hasEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
			if (/* ? */) {
				if (!/* ? */) {
					self.removeEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
				}
				return;
			} else {
				!_v1 == null;
			}
		}
	}
}


function setLandingLag(arg0) {
	if (!_v1) {
		self.removeEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
		self.addEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
		if (!self.isOnFloor()) {
			self.jumpToContinue();
			return;
		}
	} else {
		self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
		self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
		if (!self.isOnFloor()) {
			self.toLand();
		}
	}
}


function stopListening() {
	self.clearListener = false;
	self.removeEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	return;
}


// ── Frame scripts (85 methods) ──────────────────────────────────────────────
// NOTE: Frame scripts belong in the .entity file, not here.
// They are stored as FRAME_SCRIPT keyframes in each animation layer.
// See conversion_stats.json for the full list of extracted frame methods.

