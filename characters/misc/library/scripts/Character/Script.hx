// API Script for misc — converted from SSF2
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

