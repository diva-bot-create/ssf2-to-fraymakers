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
	_v2 = 0;
	while (_v2 < self.effects.length) {
		if (self.effects[_v2] == null) {
			_v2 = _v2 + 1;
		} else {
			if (self.effects[_v2].parent == null) {
			} else {
				self.effects[_v2].parent.removeChild(self.effects[_v2]);
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
// NOTE: Frame scripts belong in the .entity file, not here.
// They are stored as FRAME_SCRIPT keyframes in each animation layer.
// See conversion_stats.json for the full list of extracted frame methods.

