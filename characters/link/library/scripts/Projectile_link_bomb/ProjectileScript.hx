// Projectile script for linkbomb -- converted from SSF2 (multi-state)
// Uses the local state machine to switch between animations since PState
// only supports built-in values (ACTIVE, DESTROYING, etc).
// TODO: tune X_SPEED / Y_SPEED and gravity to match SSF2 behaviour.

var X_SPEED = 8;
var Y_SPEED = 0;

// ---- Local state machine setup ----
function _prepLocalState(animation:String, ?index:Int=Math.NaN):Int {
    if (!__hasInitLocalStateMachine) {
        Common.initLocalStateMachine();
        __hasInitLocalStateMachine = true;
    }
    if (index != Math.NaN) {
        index = __localStatePrepIndex++;
    }
    Common.registerLocalState(index, animation);
    return index;
}
var __hasInitLocalStateMachine = false;
var __localStatePrepIndex = -1;

var LState = {
    IDLE:    _prepLocalState("projectileIdle"),
    HELD: _prepLocalState("projectileHeld"),
    ACTIVE: _prepLocalState("projectileActive"),
}

function initialize() {
    self.addEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit, { persistent: true });
    self.addEventListener(GameObjectEvent.HIT_DEALT,  onHit,       { persistent: true });

    self.setCostumeIndex(self.getOwner().getCostumeIndex());
    Common.enableReflectionListener({ mode: "X", replaceOwner: true });

    self.setState(PState.ACTIVE);
    Common.toLocalState(LState.IDLE);
    self.setXSpeed(X_SPEED);
    self.setYSpeed(Y_SPEED);
}

function onGroundHit(event) {
    self.removeEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit);
    self.removeEventListener(GameObjectEvent.HIT_DEALT,  onHit);
    self.toState(PState.DESTROYING);
}

function onHit(event) {
    self.removeEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit);
    self.removeEventListener(GameObjectEvent.HIT_DEALT,  onHit);
    self.toState(PState.DESTROYING);
}

function update() {
    if (Common.inLocalState(LState.IDLE)) {
        // TODO: implement IDLE state logic (projectileIdle animation)
    } else if (Common.inLocalState(LState.HELD)) {
        // TODO: implement HELD state logic (18 frames)
        if (self.finalFramePlayed()) {
            Common.toLocalState(LState.IDLE);
        }
    } else if (Common.inLocalState(LState.ACTIVE)) {
        // TODO: implement ACTIVE state logic (35 frames)
        if (self.finalFramePlayed()) {
            Common.toLocalState(LState.IDLE);
        }
    }
}
