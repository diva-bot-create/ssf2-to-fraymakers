// Projectile script for bombArrow -- converted from SSF2
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
    // Projectile moves via setXSpeed/setYSpeed set in initialize().
    // Add custom movement logic here if needed.
}
