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

function addEffectToList() {
	// if (local1 == null) { /* jump 11 */ }
	self.effects.push(local1);
	return local1;
}

function clearEffectsOnStateChange() {
	self.clearListener = local1;
	self.addEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	return;
}

function clearListener() {
	self.SSF2API = Object;
	return;
}

function count() {
	self.SSF2API = Object;
	return;
}

function effects() {
	self.SSF2API = Object;
	return;
}

function flipX() {
	// if (!self.isFacingRight()) { /* jump 2 */ }
	return local1;
}

function followUser() {
	throw /* value */;
	// if (local1 == local2) { /* jump 7146368 */ }
	throw /* value */;
	// if (!null.x - getX.getX().y - getY.getY()) { /* jump 20 */ }
	// if (!{ persistent: false, hitStunPause: false }) { /* jump 20 */ }
	self.createTimer({ persistent: true, hitStunPause: false }, self, 1, 0);
	self.destroyTimer(self);
	return;
}

function initialize() {
	SSF2API.print("Mario initialized.");
	return;
}

function jumpToContinue() {
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	self.updateAttackStats({ allowControl: false, cancelWhenAirborne: true });
	self.stancePlayFrame("continue");
	return;
}

function loopEffect() {
	throw /* value */;
	// if (local1 == local2) { /* jump 7146368 */ }
	throw /* value */;
	// if (!null) { /* jump 20 */ }
	// if (!{ persistent: false, hitStunPause: false }) { /* jump 22 */ }
	{ persistent: true, hitStunPause: false }.createTimer(self, 1, 0, { hitStunPause: false });
	self.destroyTimer(self);
	return;
}

function pushEffectBehind() {
	SSF2API.getStage().getMidground().swapChildren(self.getMC(), local1);
	return local1;
}

function removeAllEffects() {
	var local2 = 0;
	// if (0. == null) { /* jump 39 */ }
	// if (0..parent == null) { /* jump 23 */ }
	self.effects.removeChild(0.);
	var local2 = 0;
	// if (0 < self.effects.length) { /* jump -69 */ }
	self.effects = Array.new Array();
	// if (!self.clearListener) { /* jump 15 */ }
	// if (self.hasEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects)) { /* jump 5 */ }
	// if (!!local1 == null) { /* jump 13 */ }
	self.removeEventListener(SSF2Event.STATE_CHANGE, self.removeAllEffects);
	return;
}

function setLandingLag() {
	// if (!local1) { /* jump 43 */ }
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	// if (!self.isOnGround()) { /* jump 5 */ }
	self.jumpToContinue();
	self.removeEventListener(SSF2Event.GROUND_TOUCH, self.jumpToContinue);
	self.addEventListener(SSF2Event.GROUND_TOUCH, self.toLand);
	// if (!self.isOnGround()) { /* jump 5 */ }
	self.toLand();
	return;
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

