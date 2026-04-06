// Projectile script for linkbomb -- converted from SSF2
// This projectile has multiple animation states from SSF2:
//   'attack_hold' -> animation 'projectileHeld' (18 frames)
//   'attack_toss' -> animation 'projectileActive' (35 frames)
// TODO: wire up state transitions to match SSF2 behaviour.
// TODO: tune X_SPEED / Y_SPEED and gravity to match SSF2 behaviour.

var X_SPEED = 8;
var Y_SPEED = 0;

function initialize() {
    self.addEventListener(EntityEvent.COLLIDE_FLOOR, onGroundHit, { persistent: true });
    self.addEventListener(GameObjectEvent.HIT_DEALT,  onHit,       { persistent: true });

    self.setCostumeIndex(self.getOwner().getCostumeIndex());
    Common.enableReflectionListener({ mode: "X", replaceOwner: true });

    self.setState(PState.ACTIVE);
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
    // TODO: implement multi-state transition logic here.
    // Use self.toAnimation("projectileHeld") / "projectileActive" etc.
}
