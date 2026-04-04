# SSF2 → Fraymakers API Conversion Reference

Complete mapping of SSF2 AS3 API calls to Fraymakers Haxe API equivalents.
Source: https://shifterbit.github.io/fraymakers-api-docs/classes/

---

## Script.hx Global Variables

In Fraymakers Script.hx, `self` is the character entity.
`match` is the global match object.

---

## Entity Methods (self.*)

| SSF2 AS3 | Fraymakers | Notes |
|---|---|---|
| `this.getX()` | `self.getX()` | |
| `this.getY()` | `self.getY()` | |
| `this.setX(v)` | `self.setX(v)` | |
| `this.setY(v)` | `self.setY(v)` | |
| `this.getXSpeed()` | `self.getXVelocity()` | SSF2 "speed" = FM "velocity" |
| `this.getYSpeed()` | `self.getYVelocity()` | |
| `this.setXSpeed(v)` | `self.setXVelocity(v)` | |
| `this.setYSpeed(v)` | `self.setYVelocity(v)` | |
| `this.getNetXSpeed()` | `self.getNetXVelocity()` | |
| `this.getNetYSpeed()` | `self.getNetYVelocity()` | |
| `this.setXSpeedScaled(v)` | `self.setXVelocityScaled(v)` | |
| `this.setYSpeedScaled(v)` | `self.setYVelocityScaled(v)` | |
| `this.faceLeft()` | `self.faceLeft()` | direct equivalent |
| `this.faceRight()` | `self.faceRight()` | direct equivalent |
| `this.flip()` | `self.flip()` | direct equivalent |
| `this.flipX(v)` | `self.flipX(v)` | returns v * facing direction |
| `this.isFacingLeft()` | `self.isFacingLeft()` | |
| `this.isFacingRight()` | `self.isFacingRight()` | |
| `this.isOnGround()` / `this.isOnFloor()` | `self.isOnFloor()` | |
| `this.getState()` | `self.getState()` | |
| `this.setState(s)` | `self.setState(s)` | no side effects; use toState() for full transition |
| `this.toState(s)` | `self.toState(CState.X)` | use CState constants |
| `this.inState(s)` | `self.inState(CState.X)` | |
| `this.inStateGroup(g)` | `self.inStateGroup(CStateGroup.X)` | |
| `this.getPreviousState()` | `self.getPreviousState()` | |
| `this.playAnimation(name)` | `self.playAnimation(name)` | direct equivalent |
| `this.playFrame(frame)` | `self.playFrame(frame)` | |
| `this.playFrameLabel(label)` | `self.playFrameLabel(label)` | |
| `this.getCurrentFrame()` | `self.getCurrentFrame()` | |
| `this.getTotalFrames()` | `self.getTotalFrames()` | |
| `this.finalFramePlayed()` | `self.finalFramePlayed()` | |
| `this.getAnimation()` | `self.getAnimation()` | |
| `this.hasAnimation(name)` | `self.hasAnimation(name)` | |
| `this.addTimer(interval, repeats, fn)` | `self.addTimer(interval, repeats, fn)` | returns Int uid |
| `this.removeTimer(uid)` | `self.removeTimer(uid)` | |
| `this.addEventListener(type, fn)` | `self.addEventListener(type, fn)` | |
| `this.removeEventListener(type, fn)` | `self.removeEventListener(type, fn)` | |
| `this.kill()` | `self.kill()` | |
| `this.getScaleX()` | `self.getScaleX()` | |
| `this.getScaleY()` | `self.getScaleY()` | |
| `this.setScaleX(v)` | `self.setScaleX(v)` | |
| `this.setScaleY(v)` | `self.setScaleY(v)` | |
| `this.getRotation()` | `self.getRotation()` | |
| `this.setRotation(v)` | `self.setRotation(v)` | |
| `this.resetMomentum()` | `self.resetMomentum()` | |
| `this.toggleGravity(bool)` | `self.toggleGravity(bool)` | |
| `this.getKnockback()` | `self.getKnockback()` | |
| `this.setKnockback(speed, angle)` | `self.setKnockback(speed, angle)` | |
| `this.move(x, y)` | `self.move(x, y)` | relative move |
| `this.moveAbsolute(x, y)` | `self.moveAbsolute(x, y)` | absolute position |
| `this.getTopLayer()` | `self.getTopLayer()` | Container for display objects |
| `this.getBottomLayer()` | `self.getBottomLayer()` | |
| `this.getResource()` | `self.getResource()` | for getting content by id |

---

## GameObject Methods (self.*)

| SSF2 AS3 | Fraymakers | Notes |
|---|---|---|
| `this.getDamage()` | `self.getDamage()` | current damage % |
| `this.setDamage(v)` | `self.setDamage(v)` | |
| `this.addDamage(v)` | `self.addDamage(v)` | |
| `this.getHitstop()` | `self.getHitstop()` | |
| `this.getHitstun()` | `self.getHitstun()` | |
| `this.startHitstop(frames, shake)` | `self.startHitstop(frames, shake)` | |
| `this.startHitstun(frames)` | `self.startHitstun(frames)` | |
| `this.forceStartHitstop(frames, shake)` | `self.forceStartHitstop(frames, shake)` | bypasses existing check |
| `this.forceStartHitstun(frames)` | `self.forceStartHitstun(frames)` | |
| `this.getOwner()` | `self.getOwner()` | |
| `this.setOwner(obj)` | `self.setOwner(obj)` | |
| `this.getGrabbedFoe()` | `self.getGrabbedFoe()` | |
| `this.getAllGrabbedFoes()` | `self.getAllGrabbedFoes()` | |
| `this.releaseCharacter(char, kb)` | `self.releaseCharacter(char, kb)` | |
| `this.releaseAllCharacters(kb)` | `self.releaseAllCharacters(kb)` | |
| `this.attemptGrab(foe, opts)` | `self.attemptGrab(foe, opts)` | |
| `this.attemptHit(target, stats)` | `self.attemptHit(target, stats)` | manual hit detection |
| `this.reactivateHitboxes()` | `self.reactivateHitboxes()` | refreshes attack UID (= SSF2 refreshAttackID) |
| `this.refreshAttackID()` | `self.reactivateHitboxes()` | |
| `this.updateAnimationStats(obj)` | `self.updateAnimationStats(obj)` | runtime anim stat overrides |
| `this.updateHitboxStats(id, obj)` | `self.updateHitboxStats(id, obj)` | runtime hitbox stat overrides (id = hitbox index) |
| `this.updateGameObjectStats(obj)` | `self.updateGameObjectStats(obj)` | |
| `this.addStatusEffect(type, val, opts)` | `self.addStatusEffect(type, val, opts)` | returns StatusEffectObject |
| `this.removeStatusEffect(type, id)` | `self.removeStatusEffect(type, id)` | |
| `this.getStatusEffectByType(type)` | `self.getStatusEffectByType(type)` | |
| `this.hasBodyStatus(flags)` | `self.hasBodyStatus(flags)` | |
| `this.applyGlobalBodyStatus(status, dur)` | `self.applyGlobalBodyStatus(status, dur)` | |
| `this.getSprite()` | `self.getSprite()` | main display sprite |
| `this.getTeam()` | `self.getTeam()` | |
| `this.getVisible()` | `self.getVisible()` | |
| `this.setVisible(v)` | `self.setVisible(v)` | |
| `this.setAlpha(v)` | `self.setAlpha(v)` | |

---

## Character Methods (self.*)

| SSF2 AS3 | Fraymakers | Notes |
|---|---|---|
| `this.isCPU()` | `self.isBot()` | |
| `this.getHeldControls()` | `self.getHeldControls()` | returns ControlsObject |
| `this.getPressedControls()` | `self.getPressedControls()` | returns ControlsObject |
| `this.getRawHeldControls()` | `self.getRawHeldControls()` | unmodified by input buffer |
| `this.getFoes()` | `self.getFoes()` | Array<Character> |
| `this.getDoubleJumpCount()` | `self.getDoubleJumpCount()` | |
| `this.setDoubleJumpCount(n)` | `self.setDoubleJumpCount(n)` | |
| `this.getAirdashCount()` | `self.getAirdashCount()` | |
| `this.setAirdashCount(n)` | `self.setAirdashCount(n)` | |
| `this.getLives()` | `self.getLives()` | |
| `this.getScore()` | `self.getScore()` | |
| `this.inActionableState()` | `self.inActionableState()` | idle/fall etc. |
| `this.inHurtState()` | `self.inHurtState()` | |
| `this.inSpecialAttackState()` | `self.inSpecialAttackState()` | |
| `this.inAerialAttackState()` | `self.inAerialAttackState()` | |
| `this.updateAnimationStats(obj)` | `self.updateAnimationStats(obj)` | inherited from GameObject |
| `this.updateCharacterStats(obj)` | `self.updateCharacterStats(obj)` | runtime char stat overrides |
| `this.toStateFromInput(state, anim)` | `self.toStateFromInput(state, anim)` | respects turbo mode cancel |
| `this.playAttackVoice()` | `self.playAttackVoice()` | uses attackVoiceIds from CharacterStats |
| `this.playHurtLightVoice()` | `self.playHurtLightVoice()` | |
| `this.playHurtMediumVoice()` | `self.playHurtMediumVoice()` | |
| `this.playHurtHeavyVoice()` | `self.playHurtHeavyVoice()` | |
| `this.playKoVoice()` | `self.playKoVoice()` | |
| `this.attachToLedge()` | `self.attachToLedge()` | |
| `this.attemptLedgeGrab()` | `self.attemptLedgeGrab()` | |
| `this.releaseLedge()` | `self.releaseLedge()` | |
| `this.forceLand(opts)` | `self.forceLand(opts)` | resets jumps, fires LAND event |
| `this.preLand(effect)` | `self.preLand(effect)` | pre-landing without animation |
| `this.pressedStrongAttack()` | `self.pressedStrongAttack()` | returns StrongInputType |
| `this.isFirstInputUpdate()` | `self.isFirstInputUpdate()` | for inputUpdateHook |
| `this.clearInputBuffer()` | `self.clearInputBuffer()` | |
| `this.getCharacterStat(name)` | `self.getCharacterStat(name)` | get named stat dynamically |
| `this.getPlayerConfig()` | `self.getPlayerConfig()` | port/player info |
| `this.getPortColor()` | `self.getPortColor()` | hex color |
| `this.performHitstopNudge(...)` | `self.performHitstopNudge(...)` | |
| `this.startBodySparkleEffect(opts)` | `self.startBodySparkleEffect(opts)` | visual body effect |
| `this.resetSingleUse(state)` | `self.resetSingleUse(state)` | re-enable singleUse move |
| `this.isDisabledBySingleUse(state)` | `self.isDisabledBySingleUse(state)` | |

---

## SSF2 → Fraymakers: setAttackEnabled / action enable

SSF2 used string-based move names. Fraymakers uses `CharacterActions` constants:

| SSF2 `setAttackEnabled(bool, "moveName")` | Fraymakers |
|---|---|
| `setAttackEnabled(false, "b")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_NEUTRAL)` |
| `setAttackEnabled(true, "b")` | `self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, lastEffect.id)` |
| `setAttackEnabled(false, "b_air")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_NEUTRAL)` |
| `setAttackEnabled(false, "b_forward")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_SIDE)` |
| `setAttackEnabled(false, "b_forward_air")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_SIDE)` |
| `setAttackEnabled(false, "b_up")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_UP)` |
| `setAttackEnabled(false, "b_down")` | `self.addStatusEffect(StatusEffectType.DISABLE_ACTION, CharacterActions.SPECIAL_DOWN)` |

**SSF2 move name → CharacterActions constant:**

| SSF2 string | CharacterActions |
|---|---|
| `"a"` | `CharacterActions.JAB` |
| `"a_forward_tilt"` | `CharacterActions.TILT_FORWARD` |
| `"a_up_tilt"` | `CharacterActions.TILT_UP` |
| `"a_down_tilt"` / `"crouch_attack"` | `CharacterActions.TILT_DOWN` |
| `"a_forwardsmash"` | `CharacterActions.STRONG_FORWARD` |
| `"a_up"` | `CharacterActions.STRONG_UP` |
| `"a_down"` | `CharacterActions.STRONG_DOWN` |
| `"a_air"` | `CharacterActions.AERIAL_NEUTRAL` |
| `"a_air_forward"` | `CharacterActions.AERIAL_FORWARD` |
| `"a_air_backward"` | `CharacterActions.AERIAL_BACK` |
| `"a_air_up"` | `CharacterActions.AERIAL_UP` |
| `"a_air_down"` | `CharacterActions.AERIAL_DOWN` |
| `"b"` | `CharacterActions.SPECIAL_NEUTRAL` |
| `"b_air"` | `CharacterActions.SPECIAL_NEUTRAL` |
| `"b_forward"` / `"b_forward_air"` | `CharacterActions.SPECIAL_SIDE` |
| `"b_up"` / `"b_up_air"` | `CharacterActions.SPECIAL_UP` |
| `"b_down"` / `"b_down_air"` | `CharacterActions.SPECIAL_DOWN` |
| `"throw_forward"` | `CharacterActions.THROW_FORWARD` |
| `"throw_back"` | `CharacterActions.THROW_BACK` |
| `"throw_up"` | `CharacterActions.THROW_UP` |
| `"throw_down"` | `CharacterActions.THROW_DOWN` |
| `"ledge_attack"` | `CharacterActions.LEDGE_ATTACK` |
| `"a_forward"` (dash attack) | `CharacterActions.DASH_ATTACK` |
| `"getup_attack"` | `CharacterActions.CRASH_ATTACK` |

---

## CState Constants

| SSF2 state string / concept | Fraymakers CState |
|---|---|
| idle/stand | `CState.STAND` |
| walk | `CState.WALK_IN`, `CState.WALK_LOOP`, `CState.WALK_OUT` |
| dash | `CState.DASH` |
| run | `CState.RUN` |
| jump squat | `CState.JUMP_SQUAT` |
| airborne / jump | `CState.JUMP_LOOP` |
| double jump | `CState.JUMP_MIDAIR` |
| fall | `CState.FALL` |
| special fall | `CState.FALL_SPECIAL` |
| crouch | `CState.CROUCH_LOOP` |
| jab/a | `CState.JAB` |
| tilt forward | `CState.TILT_FORWARD` |
| tilt up | `CState.TILT_UP` |
| tilt down | `CState.TILT_DOWN` |
| smash forward | `CState.STRONG_FORWARD_ATTACK` |
| smash up | `CState.STRONG_UP_ATTACK` |
| smash down | `CState.STRONG_DOWN_ATTACK` |
| aerial neutral | `CState.AERIAL_NEUTRAL` |
| aerial forward | `CState.AERIAL_FORWARD` |
| aerial back | `CState.AERIAL_BACK` |
| aerial up | `CState.AERIAL_UP` |
| aerial down | `CState.AERIAL_DOWN` |
| neutral special | `CState.SPECIAL_NEUTRAL` |
| side special | `CState.SPECIAL_SIDE` |
| up special | `CState.SPECIAL_UP` |
| down special | `CState.SPECIAL_DOWN` |
| grab | `CState.GRAB` |
| hold | `CState.GRAB_HOLD` |
| pummel | `CState.GRAB_PUMMEL` |
| throw forward | `CState.THROW_FORWARD` |
| throw back | `CState.THROW_BACK` |
| throw up | `CState.THROW_UP` |
| throw down | `CState.THROW_DOWN` |
| hurt light | `CState.HURT_LIGHT` |
| hurt medium | `CState.HURT_MEDIUM` |
| hurt heavy | `CState.HURT_HEAVY` |
| tumble | `CState.TUMBLE` |
| shield | `CState.SHIELD_LOOP` |
| roll | `CState.ROLL` |
| spot dodge | `CState.SPOT_DODGE` |
| tech roll | `CState.TECH_ROLL` |
| ledge | `CState.LEDGE_LOOP` |
| ledge attack | `CState.LEDGE_ATTACK` |
| crash/downed | `CState.CRASH_LOOP` |
| getup attack | `CState.CRASH_ATTACK` |
| KO | `CState.KO` |
| revival | `CState.REVIVAL` |
| airdash | `CState.AIRDASH_INITIAL` |

---

## SSF2 Effects → Fraymakers Elements

SSF2 used `effect_id` strings on hitboxes to determine hit visuals. In Fraymakers, use `element` (AttackElement) and `attackStrength` (AttackStrength) to automatically get the right hit effect/sound.

| SSF2 effect_id | Fraymakers element | Notes |
|---|---|---|
| `"effect_elechit_light"`, `"effect_elechit_heavy"` | `AttackElement.ELECTRIC` | shock:true in SSF2 |
| `"effect_firehit_heavy"`, `"effect_firehit_light"` | `AttackElement.FIRE` | burn:true in SSF2 |
| `"effect_darkhit"` | `AttackElement.MAGIC` | darkness:true in SSF2 |
| `"effect_hit1"`, `"effect_hit2"`, `"effect_heavyHit"`, `"effect_lightHit"` | `AttackElement.NORMAL` | standard physical |
| `"effect_swordSlash"` | `AttackElement.NORMAL` | |
| `"effect_waterhit_heavy"` | `AttackElement.NORMAL` | no direct equivalent |
| `"effect_icehit"` | `AttackElement.ICE` | freeze:true in SSF2 |

---

## SSF2 Hitbox Flags → Fraymakers HitboxStats

| SSF2 flag | Fraymakers equivalent |
|---|---|
| `shock: true` | `element: AttackElement.ELECTRIC` |
| `burn: true` | `element: AttackElement.FIRE` |
| `darkness: true` | `element: AttackElement.MAGIC` |
| `freeze: true` | `element: AttackElement.ICE` |
| `bypassShield: true` | `shieldable: false` |
| `bypassNonGrabbed: true` | `entityHitConditions: EntityHitCondition.CHARACTER` (only grabbed chars; use with care) |
| `bypassGrabbed: true` | hits only non-grabbed; no direct FM equivalent → use `entityHitConditions` |
| `stackKnockback: false` | `stackKnockback: false` | direct equivalent |
| `reversableAngle: false` | `reversibleAngle: false` | note spelling correction |
| `forceTumbleFall: true` | `tumbleType: TumbleType.ALWAYS` | SSF2 forceTumbleFall is deprecated in FM too |
| `onlyAffectsAir: true` | `physicsHitConditions: PhysicsHitCondition.AIRBORNE` |
| `onlyAffectsGround: true` | `physicsHitConditions: PhysicsHitCondition.GROUNDED` |
| `paralysis: N` | No direct equivalent → use `StatusEffectType.PHYSICS_FREEZE` via script |
| `hitLag: -1.1` | `hitstun: -1` (default multiplier, auto-calc) |
| `hitLag: N` (positive) | `hitstop: N` (frames, not multiplier) |
| `hitStun: N` | `hitstop: N` |
| `selfHitStun: N` | `selfHitstop: N` |
| `camShake: N` | `cameraShakeType: CameraShakeType.AUTO` (FM auto-calcs based on KB) |
| `hasEffect: false` | `hitEffectOverride: "#n/a"` |
| `meteorBounce: false` | No direct equivalent (FM handles meteor behavior via angle) |

---

## SSF2 Global Calls → Fraymakers

| SSF2 | Fraymakers | Notes |
|---|---|---|
| `SSF2API.print(msg)` | *(remove)* | debug only |
| `SSF2API.random()` | `Math.random()` | |
| `SSF2API.safeRandom()` | `Math.random()` | |
| `SSF2API.safeRandomInteger(n)` | `Math.floor(Math.random() * n)` | |
| `SSF2API.getCamera().shake(...)` | `match.getCamera()` + Camera API | |
| `SSF2API.createProjectile(...)` | `match.createProjectile(contentId, owner)` | |
| `this.fireProjectile(linkage, x, y)` | `match.createProjectile(self.getResource().getContent(linkage), self)` then set position | |
| `this.setGlobalVariable(key, val)` | `match.globals[key] = val` | match.globals is a Dynamic object |
| `this.getGlobalVariable(key)` | `match.globals[key]` | |
| `this.getNearestLedge()` | No direct FM equivalent | use `match.getStructures()` + manual distance check |
| `this.inUpperLeftWarningBounds()` | No direct FM equivalent | implement via `self.getX()` + stage bounds |
| `this.inUpperRightWarningBounds()` | No direct FM equivalent | implement via `self.getX()` + stage bounds |
| `this.isUsingFinalSmash()` | `self.inState(CState.EMOTE)` | final smash → emote state in FM |

---

## Audio

| SSF2 | Fraymakers |
|---|---|
| `this.playSound("soundId")` | `AudioClip.play(self.getResource().getContent("soundId"))` |
| `this.playSound("soundId", volume)` | `AudioClip.play(self.getResource().getContent("soundId"), {volume: volume})` |
| `this.playAttackSound(n)` | `self.playAttackVoice()` (uses CharacterStats.attackVoiceIds) |
| `this.playVoiceSound(n)` | `self.playAttackVoice()` or `self.playHurtMediumVoice()` etc. |

---

## Events

| SSF2 event string | Fraymakers constant |
|---|---|
| `"onLand"` | `GameObjectEvent.LAND` |
| `"onHit"` | `GameObjectEvent.HIT_DEALT` |
| `"onHitReceived"` | `GameObjectEvent.HIT_RECEIVED` |
| `"onHitboxConnected"` | `GameObjectEvent.HITBOX_CONNECTED` |
| `"onGrab"` | `GameObjectEvent.GRAB_DEALT` |
| `"onGrabReceived"` | `GameObjectEvent.GRAB_RECEIVED` |
| `"onLinkFrames"` | `GameObjectEvent.LINK_FRAMES` |
| `"onDamageUpdated"` | `GameObjectEvent.DAMAGE_UPDATED` |
| `"onEnterHitstop"` | `GameObjectEvent.ENTER_HITSTOP` |
| `"onExitHitstop"` | `GameObjectEvent.EXIT_HITSTOP` |
| `"onEnterHitstun"` | `GameObjectEvent.ENTER_HITSTUN` |
| `"onExitHitstun"` | `GameObjectEvent.EXIT_HITSTUN` |
| `"onLeftGround"` | `GameObjectEvent.LEFT_GROUND` |

---

## Match-level

| SSF2 | Fraymakers |
|---|---|
| `SSF2API.getMatch().getCharacters()` | `match.getCharacters()` |
| `SSF2API.getMatch().getPlayers()` | `match.getPlayers()` |
| `SSF2API.getMatch().createProjectile(...)` | `match.createProjectile(contentId, owner)` |
| `SSF2API.getMatch().getElapsedFrames()` | `match.getElapsedFrames()` |
| `SSF2API.getMatch().getTimeLeft()` | `match.getTimeLeft()` |
| `SSF2API.getMatch().createVfx(stats, owner)` | `match.createVfx(stats, owner)` |

---

## SSF2 Character stat fields → Fraymakers CharacterStats

| SSF2 getOwnStats() field | Fraymakers CharacterStats field | Notes |
|---|---|---|
| `weight1` | `weight` | |
| `gravity` | `gravity` | Note: FM CharacterStats doesn't have gravity! Gravity is controlled via `StatusEffectType.GRAVITY_MULTIPLIER` or AnimationStats `gravityMultiplier`. The base physics gravity is engine-level. Map SSF2 `gravity` to a `StatusEffectType.GRAVITY_MULTIPLIER` applied on init, relative to FM default. |
| `jumpSpeed` | `jumpSpeed` | |
| `jumpSpeedMidair` | `doubleJumpSpeeds: [v]` | array, one entry per double jump |
| `shortHopSpeed` | `shortHopSpeed` | |
| `max_ySpeed` | `terminalVelocity` | |
| `fastFallSpeed` | `fastFallSpeed` | |
| `norm_xSpeed` | `walkSpeedCap` + `runSpeedInitial` | SSF2 norm_xSpeed serves both |
| `max_xSpeed` | `runSpeedCap` + `groundSpeedCap` + `aerialSpeedCap` | |
| `accel_start` | `walkSpeedInitial` + `walkSpeedAcceleration` | |
| `accel_start_dash` | `dashSpeed` | |
| `accel_rate` | `runSpeedAcceleration` + `groundSpeedAcceleration` | |
| `accel_rate_air` | `aerialSpeedAcceleration` | |
| `decel_rate` | `friction` (abs value) | SSF2 is negative, FM is positive |
| `decel_rate_air` | `aerialFriction` (abs value) | |
| `dodgeSpeed` | `dodgeRollSpeed` | |
| `roll_speed` | `techRollSpeed` (approx) | |
| `roll_decay` | No direct FM equivalent | |
| `getup_roll_delay` | `dodgeRollSpeedStartFrame` | |
| `tech_roll_delay` | `techRollSpeedStartFrame` | |
| `climb_roll_delay` | `ledgeRollSpeedStartFrame` | |
| `max_jump` | length of `doubleJumpSpeeds` array | 0 = no double jump |
| `holdJump` | `holdToJump` | |
| `width` | `floorHipWidth` + `aerialHipWidth` | ECB half-width ≈ width/2 |
| `height` | `floorHeadPosition` + `aerialHeadPosition` | ECB height |
| `grabDamage` | No direct stat; pump damage via `addDamage()` in Script.hx | |
| `hurtFrames` | No direct stat; handle in Script.hx | |
| `maxShieldSize` | `shieldFrontWidth/Height` (visual sizing) | |
| `shield_scale` | `shieldFrontWidth/Height` | |
| `tiltTossMultiplier` | No direct FM equivalent | |
| `smashTossMultiplier` | No direct FM equivalent | |
| `tetherGrab` | `grabAirType: GrabAirType.TETHER` | |
| `special_type` | Handled in Script.hx logic | |
| `sounds.hurt*` | `hurtMediumVoiceIds`, `hurtHeavyVoiceIds` | |
| `sounds.dead*` | `koVoiceIds` | |
| `sounds.jump*` | Not in CharacterStats; play via `AudioClip.play()` in frame script | |
| `sounds.pummel` | Play via `AudioClip.play()` in grab pummel frame script | |

---

## GRAVITY NOTE

**Important:** Fraymakers `CharacterStats` does NOT have a `gravity` field.
Gravity is an engine-level value. To approximate SSF2's per-character gravity:

```haxe
// In initialize(), apply a gravity multiplier relative to FM default
// FM default gravity ≈ 0.8 (approximate, not documented)
// SSF2 Ganondorf gravity = 1.6 → multiplier = 1.6 / 0.8 = 2.0
var gravMultiplier = SSF2_GRAVITY / FM_BASE_GRAVITY;
self.addStatusEffect(StatusEffectType.GRAVITY_MULTIPLIER, gravMultiplier, {persistent: true});
```

Or use `updateAnimationStats({gravityMultiplier: v})` per-animation.

---

## AnimationStats fields (runtime override via updateAnimationStats)

These can be set in AnimationStats.hx OR via `self.updateAnimationStats({...})` in Script.hx:

| Field | Type | Description |
|---|---|---|
| `allowJump` | Bool | Allow jumping during this animation |
| `allowFastFall` | Bool | Allow fast fall |
| `allowMovement` | Bool | Allow directional air movement |
| `allowTurnOnFirstFrame` | Bool | Auto-face direction on first frame |
| `xSpeedConservation` | Float | Multiplier on horizontal speed carried into animation |
| `ySpeedConservation` | Float | Multiplier on vertical speed carried into animation |
| `gravityMultiplier` | Float | Per-animation gravity scaling |
| `aerialSpeedCap` | Float | Per-animation aerial speed cap |
| `groundSpeedCap` | Float | Per-animation ground speed cap |
| `endType` | AnimationEndType | FREEZE, LOOP, etc. |
| `landAnimation` | String | Animation to play on land |
| `landType` | LandType | TOUCH, LINK_FRAMES, etc. |
| `leaveGroundCancel` | Bool | Whether landing cancels the animation |
| `nextState` | CState | State to go to when animation ends |
| `singleUse` | Bool | Disable after first aerial use |
| `bodyStatus` | BodyStatus | Armor type (SUPER_ARMOR, etc.) |
| `bodyStatusShaderColor` | Int | Color override for armor shader |

---

## Script.hx Lifecycle Functions

| Function | When called |
|---|---|
| `initialize()` | Once, when character is created |
| `update()` | Every frame |
| `inputUpdateHook(pressed, held)` | When reading inputs (before state determination) |
| `onTeardown()` | When character is destroyed |
