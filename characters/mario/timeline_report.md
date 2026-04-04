# Mario SSF2 → Fraymakers Conversion Report

## Attack Mapping (SSF2 → Fraymakers)

SSF2 → Fraymakers stat mapping:
- `power` → `baseKnockback` &nbsp; `kbConstant` → `knockbackGrowth` &nbsp; `hitStun` → `hitstop` &nbsp; `hitLag` → `hitstun` &nbsp; `direction` → `angle`

| SSF2 Attack | FM Name | baseKnockback (power) | knockbackGrowth (kbConstant) | hitstop (hitStun) | hitstun (hitLag) | angle (direction) |
|-------------|---------|----------------------|------------------------------|-------------------|------------------|-------------------|
| a_air | aerial_neutral | ? | 80 | 0 | ? | ? |
| a_air_backward | aerial_back | ? | 45 | 3 | 4 | ? |
| a_air_down | aerial_down | ? | 40 | 4 | 5 | ? |
| a_air_forward | aerial_forward | ? | 80 | 0 | ? | ? |
| a_air_up | aerial_up | ? | 80 | 0 | ? | ? |
| a_down | tilt_down | ? | 70 | 2 | ? | ? |
| a_forward | tilt_forward | ? | 45 | 0 | 0 | ? |
| a_forwardsmash | strong_forward_attack | ? | 75 | 2 | ? | ? |
| a_up_tilt | tilt_up | ? | 30 | 2 | 2 | ? |
| b | special_neutral | ? | 45 | 0 | 0 | ? |
| b_air | special_neutral_air | ? | 45 | 0 | 0 | ? |
| b_up_air | special_up_air | ? | 45 | 3 | 4 | ? |
| crouch_attack | dash_attack | ? | 30 | 2 | 2 | ? |
| kirby | (no mapping) | ? | 50 | 3 | ? | ? |
| kirby_air | (no mapping) | ? | 30 | 0 | 0 | ? |
| throw_down | throw_down | ? | 145 | 0 | 0 | ? |
| throw_up | throw_up | ? | 30 | 2 | 2 | ? |

## Movement Stats Extracted

| SSF2 Stat | Value |
|-----------|-------|

## Timeline Calls by Method

Each SSF2 method mapped to its Fraymakers equivalent (or TODO).

### `CState`

- **static::getCharacterStats** `getCharacterStats()` → **TODO: no mapping**
- **static::getCharacters** `getWidth()` → **TODO: no mapping**
- **static::setFrameRate** `setFrameRate()` → **TODO: no mapping**

### `DoubleJump_18`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `FThrow_46`

- **frame16** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame46** `bringBehind("attack")` → **TODO: no mapping**
- **frame48** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **mario_fla:FThrow_46** `setScale(6)` → **TODO: no mapping**

### `Frozen_92`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `createTimer(25)` → `// createTimer — use Fraymakers frame counters or onUpdate callbacks` *(SSF2 timer; approximate with frame counting in onUpdate)*
- **frame4** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame71** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame71** `tossItem()` → **TODO: no mapping**

### `HangAttack_81`

- **fireball_land** `bringBehind("mario_lift")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `NSpecial_32`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **mario_fla:NSpecial_32** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:NSpecial_32** `setRotation("MarioSSpecFrame")` → `// SSF2 hitbox frame: 'MarioSSpecFrame' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `Revival_9`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("MarioSSpecFrame", 0)` → `// SSF2 hitbox frame: 'MarioSSpecFrame' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `bringBehind()` → **TODO: no mapping**

### `SSpecialAir_37`

- **frame12** `getClosestLedge()` → **TODO: no mapping**
- **frame16** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `__anon__`

- **method_3474** `getXSpeed()` → **TODO: no mapping**
- **method_3474** `getYSpeed()` → **TODO: no mapping**
- **method_3861** `faceRight()` → `entity.faceRight();` *(facing direction)*

### `addMovement`

- **warioWareEffect** `flip()` → `entity.flipFacing();` *(flip facing)*

### `angle`

- **fireball_land** `getClosestLedge()` → **TODO: no mapping**
- **fireball_land** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **fireball_land** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **fireball_land** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **fireball_land** `removeEventListener()` → **TODO: no mapping**
- **fireball_land** `removeEventListener()` → **TODO: no mapping**
- **fireball_land** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame10** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame11** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame12** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame13** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame14** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame21** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame21** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame21** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame21** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame21** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame25** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame27** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame7** `getClosestLedge()` → **TODO: no mapping**
- **frame9** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **mario_fla:DashAttack_24** `replaceAttackBoxStats()` → **TODO: no mapping**
- **mario_fla:USpecial_34** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*

### `bounceSpeed`

- **ItemDashAttack_51** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **ItemDashAttack_51** `attachEffectOverlay()` → **TODO: no mapping**
- **ItemDashAttack_51** `attachEffectOverlay()` → **TODO: no mapping**
- **ItemDashAttack_51** `bringBehind("getJumpSpeed")` → **TODO: no mapping**
- **frame18** `bringBehind("activateItem")` → **TODO: no mapping**
- **frame23** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**

### `clearListener`

- **frame16** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame44** `bringBehind("attack")` → **TODO: no mapping**
- **frame46** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame66** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*

### `effects`

- **Mario_Symbol** `attachEffectOverlay()` → **TODO: no mapping**
- **Mario_Symbol** `replaceAttackBoxStats()` → **TODO: no mapping**
- **Mario_Symbol** `bringBehind("InteractiveObject")` → **TODO: no mapping**
- **addEffectToList** `removeEventListener()` → **TODO: no mapping**
- **clearEffectsOnStateChange** `getXSpeed()` → **TODO: no mapping**
- **clearEffectsOnStateChange** `getYSpeed()` → **TODO: no mapping**
- **clearEffectsOnStateChange** `faceLeft(1, 0)` → `entity.faceLeft();` *(facing direction)*
- **clearEffectsOnStateChange** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **dairSparkle** `attachEffectOverlay()` → **TODO: no mapping**
- **dairSparkle** `removeEventListener()` → **TODO: no mapping**
- **dairSparkle** `attachEffectOverlay()` → **TODO: no mapping**
- **dairSparkle** `removeEventListener()` → **TODO: no mapping**
- **dairSparkle** `toFlying()` → **TODO: no mapping**
- **jumpToContinue** `attachEffect()` → **TODO: no mapping**
- **jumpToContinue** `attachEffectOverlay()` → **TODO: no mapping**
- **pushEffectBehind** `faceLeft(1, 0)` → `entity.faceLeft();` *(facing direction)*
- **pushEffectBehind** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **setLandingLag** `attachEffectOverlay()` → **TODO: no mapping**

### `fireball_wall_hit`

- **frame10** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame12** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame14** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame18** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame24** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame24** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame24** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame24** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame115`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame17`

- **frame16** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame19`

- **frame21** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `frame198`

- **groundRef_mc_2** `addEventListener()` → **TODO: no mapping**
- **mario_fla:groundRef_mc_2** `getY("global_dust_spiral")` → **TODO: no mapping**

### `frame29`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `frame32`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `bringBehind("regular")` → **TODO: no mapping**
- **frame4** `bringBehind("metal_land_m")` → **TODO: no mapping**
- **frame66** `getPlayer()` → **TODO: no mapping**
- **mario_fla:FAir_42** `getPlayer()` → **TODO: no mapping**

### `frame33`

- **SpecialFall_20** `bringBehind("adobe.utils")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame36`

- **frame21** `removeEventListener()` → **TODO: no mapping**
- **frame30** `removeEventListener()` → **TODO: no mapping**
- **frame38** `removeEventListener()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**

### `frame60`

- **frame14** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame25** `bringBehind("done2")` → **TODO: no mapping**
- **frame35** `bringBehind("downed")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame42** `bringBehind("ball")` → **TODO: no mapping**
- **frame62** `bringBehind("faint")` → **TODO: no mapping**
- **mario_fla:DSmash_31** `bringBehind("hurt3")` → **TODO: no mapping**
- **mario_fla:Frozen_92** `bringBehind("fromState")` → **TODO: no mapping**
- **mario_fla:Grab_Pummel_71** `bringBehind("item_firedash")` → **TODO: no mapping**
- **mario_fla:Guard_82** `setRotation("jab2", 0)` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:Idle_3** `bringBehind("global_dust_swirl")` → **TODO: no mapping**

### `frame67`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame47** `bringBehind("attack")` → **TODO: no mapping**
- **frame52** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame9** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **mario_fla:Grab_Pummel_71** `replaceAttackBoxStats()` → **TODO: no mapping**

### `getAttackStats`

- **addEventListener** `addEventListener()` → **TODO: no mapping**
- **applyKnockback** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to a target — likely only needed for grabs/special cases)*
- **applyKnockbackSpeed** `applyKnockbackSpeed()` → `attackData.applyKnockback(target);` *(apply knockback to a target — likely only needed for grabs/special cases)*
- **applyPalette** `applyPalette()` → **TODO: no mapping**
- **attachEffect** `attachEffect()` → **TODO: no mapping**
- **attachEffectOverlay** `attachEffectOverlay()` → **TODO: no mapping**
- **attachToGround** `attachToGround()` → **TODO: no mapping**
- **bringBehind** `bringBehind()` → **TODO: no mapping**
- **bringInFront** `bringInFront()` → **TODO: no mapping**
- **createSelfPlatform** `createSelfPlatform()` → **TODO: no mapping**
- **createSelfPlatformWithMC** `createSelfPlatformWithMC()` → **TODO: no mapping**
- **createTimer** `createTimer()` → `// createTimer — use Fraymakers frame counters or onUpdate callbacks` *(SSF2 timer; approximate with frame counting in onUpdate)*
- **dealDamage** `dealDamage()` → **TODO: no mapping**
- **destroyTimer** `destroyTimer()` → **TODO: no mapping**
- **faceLeft** `faceLeft()` → `entity.faceLeft();` *(facing direction)*
- **faceRight** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **fadeIn** `fadeIn()` → **TODO: no mapping**
- **fadeOut** `fadeOut()` → **TODO: no mapping**
- **flip** `flip()` → `entity.flipFacing();` *(flip facing)*
- **forceAttack** `forceAttack()` → **TODO: no mapping**
- **forceHitStun** `forceHitStun()` → **TODO: no mapping**
- **forceOnGround** `forceOnGround()` → **TODO: no mapping**
- **getAttackBoxStat** `getAttackBoxStat()` → **TODO: no mapping**
- **getAttackStat** `getAttackStat()` → **TODO: no mapping**
- **getClosestLedge** `getClosestLedge()` → **TODO: no mapping**
- **getCounterAttackBoxStats** `getCounterAttackBoxStats()` → **TODO: no mapping**
- **getCurrentAnimation** `getCurrentAnimation()` → **TODO: no mapping**
- **getGlobalVariable** `getGlobalVariable()` → **TODO: no mapping**
- **getHeight** `getHeight()` → **TODO: no mapping**
- **getIntangibility** `getIntangibility()` → **TODO: no mapping**
- **getInvincibility** `getInvincibility()` → **TODO: no mapping**
- **getLinkageID** `getLinkageID()` → **TODO: no mapping**
- **getNearest** `getNearest()` → **TODO: no mapping**
- **getNearestLedge** `getNearestLedge()` → **TODO: no mapping**
- **getNearestPath** `getNearestPath()` → **TODO: no mapping**
- **getPreviousAnimation** `getPreviousAnimation()` → **TODO: no mapping**
- **getScale** `getScale()` → **TODO: no mapping**
- **getSizeRatio** `getSizeRatio()` → **TODO: no mapping**
- **getState** `getState()` → **TODO: no mapping**
- **getUID** `getUID()` → **TODO: no mapping**
- **getWidth** `getWidth()` → **TODO: no mapping**
- **getX** `getX()` → **TODO: no mapping**
- **getXScale** `getXScale()` → **TODO: no mapping**
- **getXSpeed** `getXSpeed()` → **TODO: no mapping**
- **getY** `getY()` → **TODO: no mapping**
- **getYScale** `getYScale()` → **TODO: no mapping**
- **getYSpeed** `getYSpeed()` → **TODO: no mapping**
- **hasEventListener** `hasEventListener()` → **TODO: no mapping**
- **homeTowardsTarget** `homeTowardsTarget()` → **TODO: no mapping**
- **inHitStun** `inHitStun()` → **TODO: no mapping**
- **inParalysis** `inParalysis()` → **TODO: no mapping**
- **inState** `inState()` → **TODO: no mapping**
- **isFacingRight** `isFacingRight()` → `entity.isFacingRight()` *(facing query)*
- **isFading** `isFading()` → **TODO: no mapping**
- **isOnGround** `isOnGround()` → **TODO: no mapping**
- **refreshAttackID** `refreshAttackID()` → `attackData.refreshId();` *(refreshes attack hit ID so it can hit same target again)*
- **remove** `getRotation()` → **TODO: no mapping**
- **removeEventListener** `removeEventListener()` → **TODO: no mapping**
- **removeFromCamera** `removeFromCamera()` → **TODO: no mapping**
- **removeSelfPlatform** `removeSelfPlatform()` → **TODO: no mapping**
- **replaceAttackBoxStats** `replaceAttackBoxStats()` → **TODO: no mapping**
- **replaceAttackStats** `replaceAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **resetFade** `resetFade()` → **TODO: no mapping**
- **resetKnockback** `resetKnockback()` → `attackData.resetKnockback();` *(reset knockback to base values)*
- **resetKnockbackDecay** `resetKnockbackDecay()` → **TODO: no mapping**
- **resetRotation** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **safeMove** `safeMove()` → **TODO: no mapping**
- **setCamBoxSize** `setCamBoxSize()` → **TODO: no mapping**
- **setColorFilters** `setColorFilters()` → **TODO: no mapping**
- **setDamage** `setDamage()` → `attackData.damage = /* damage */;` *(override attack damage this frame)*
- **setGlobalVariable** `setGlobalVariable()` → **TODO: no mapping**
- **setIntangibility** `setIntangibility()` → **TODO: no mapping**
- **setInvincibility** `setInvincibility()` → **TODO: no mapping**
- **setKnockbackDecay** `setKnockbackDecay()` → `attackData.knockbackGrowth = /* kbg */;` *(override knockback growth)*
- **setPosition** `setPosition()` → **TODO: no mapping**
- **setRotation** `setRotation()` → `// SSF2 hitbox frame: '' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **setScale** `setScale()` → **TODO: no mapping**
- **setState** `setState()` → `entity.setState("/* state */");` *(explicit state set)*
- **setTargetInterrupt** `setTargetInterrupt()` → **TODO: no mapping**
- **setVisibility** `setVisibility()` → **TODO: no mapping**
- **setX** `setX()` → `entity.position.x = /* value */;` *(position set)*
- **setXSpeed** `setXSpeed()` → `entity.physics.velocity.x = /* value */;` *(direct velocity set)*
- **setY** `setY()` → `entity.position.y = /* value */;` *(position set)*
- **setYSpeed** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **stancePlayFrame** `stancePlayFrame()` → **TODO: no mapping**
- **stopSound** `stopSound()` → **TODO: no mapping**
- **unnattachFromGround** `unnattachFromGround()` → **TODO: no mapping**
- **updateAttackBoxStats** `updateAttackBoxStats()` → **TODO: no mapping**
- **updateAttackStats** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*

### `getFallthrough`

- **forceHitStun** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **getNearestPath** `stancePlayFrame()` → **TODO: no mapping**
- **getYScale** `setY()` → `entity.position.y = /* value */;` *(position set)*
- **removeIgnoreObject** `getY()` → **TODO: no mapping**
- **setYSpeed** `getNearest()` → **TODO: no mapping**

### `getMidground`

- **faceLeft** `faceLeft()` → `entity.faceLeft();` *(facing direction)*
- **getStartingPositionMCs** `destroyTimer()` → **TODO: no mapping**

### `getUses`

- **isZDropped** `toFlying()` → **TODO: no mapping**
- **setFrameInterrupt** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **toToss** `setFrameInterrupt()` → `entity.setInterruptFrame(0);` *(allow cancel after this frame)*

### `glideAway`

- **frame11** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame16** `attachEffectOverlay()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("reflect_sfx", 0)` → `// SSF2 hitbox frame: 'reflect_sfx' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `bringBehind()` → **TODO: no mapping**
- **mario_fla:SSpecial_36** `getYScale()` → **TODO: no mapping**
- **mario_fla:ScrewAttack_64** `attachEffectOverlay()` → **TODO: no mapping**
- **mario_fla:ScrewAttack_64** `setYSpeed(9)` → `entity.physics.velocity.y = 9;` *(direct velocity set)*
- **mario_fla:ScrewAttack_64** `replaceAttackBoxStats()` → **TODO: no mapping**

### `hitBox2`

- **frame16** `getClosestLedge()` → **TODO: no mapping**
- **frame16** `removeEventListener()` → **TODO: no mapping**
- **frame26** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame45** `toFlying()` → **TODO: no mapping**
- **frame45** `bringBehind("global_dust_blast")` → **TODO: no mapping**

### `hitBox6`

- **Guard_82** `getYScale()` → **TODO: no mapping**
- **Guard_82** `getYScale()` → **TODO: no mapping**
- **Guard_82** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **Guard_82** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame20** `getYScale()` → **TODO: no mapping**
- **frame20** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame20** `removeEventListener()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getYScale()` → **TODO: no mapping**
- **frame4** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame41** `bringBehind("global_dust_spin")` → **TODO: no mapping**
- **frame41** `getItem()` → **TODO: no mapping**
- **frame42** `bringBehind("mario_kick_l")` → **TODO: no mapping**
- **frame47** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame47** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **mario_fla:BAir_43** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **mario_fla:Guard_82** `bringBehind("mario_kick_l")` → **TODO: no mapping**

### `hitTestPoint`

- **getXSpeed** `setXSpeed()` → `entity.physics.velocity.x = /* value */;` *(direct velocity set)*
- **getYSpeed** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **hitTestRect** `getXScale()` → **TODO: no mapping**
- **setY** `getYScale()` → **TODO: no mapping**

### `mario_fla:DAir_44`

- **fireball_land** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:DTilt_70`

- **frame14** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getItem()` → **TODO: no mapping**
- **frame4** `bringInFront()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:Dizzy_83`

- **frame16** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setYSpeed(14)` → `entity.physics.velocity.y = 14;` *(direct velocity set)*
- **frame9** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*

### `mario_fla:Egg_99`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame46** `bringBehind("global_dust_spiral")` → **TODO: no mapping**

### `mario_fla:Entrance_7`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:FSmash_26`

- **frame25** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame25** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame80** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:BAir_43** `replaceAttackBoxStats()` → **TODO: no mapping**

### `mario_fla:FTilt_25`

- **frame10** `forceHitStun(-341)` → **TODO: no mapping**
- **frame10** `forceHitStun(341)` → **TODO: no mapping**
- **frame13** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame13** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame13** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame13** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame13** `unnattachFromGround()` → **TODO: no mapping**
- **frame13** `forceHitStun(250)` → **TODO: no mapping**
- **frame13** `forceHitStun(6)` → **TODO: no mapping**
- **frame14** `bringInFront()` → **TODO: no mapping**
- **frame14** `resetKnockback(9)` → `attackData.resetKnockback();` *(reset knockback to base values)*
- **frame25** `bringInFront()` → **TODO: no mapping**
- **frame25** `forceHitStun(248)` → **TODO: no mapping**
- **frame25** `forceHitStun(8)` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to a different attack definition)*
- **frame4** `attachToGround()` → **TODO: no mapping**
- **frame4** `forceHitStun(252)` → **TODO: no mapping**
- **frame4** `forceHitStun(4)` → **TODO: no mapping**
- **frame7** `forceHitStun(247)` → **TODO: no mapping**
- **frame7** `forceHitStun(9)` → **TODO: no mapping**
- **frame9** `attachToGround()` → **TODO: no mapping**
- **frame9** `forceHitStun(245)` → **TODO: no mapping**
- **frame9** `forceHitStun(11)` → **TODO: no mapping**

### `mario_fla:Fall_19`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame7** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame7** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame7** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame7** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:FinalSmash_MarioFinale_106`

- **frame23** `bringBehind("adobe.utils")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `bringBehind("adobe.utils")` → **TODO: no mapping**

### `mario_fla:GetUpAttack_90`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:GetUpRoll_89`

- **frame23** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:HangClimb_79`

- **frame14** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame14** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame18** `getClosestLedge()` → **TODO: no mapping**
- **frame25** `setYSpeed(-0.2)` → `entity.physics.velocity.y = -0.2;` *(direct velocity set)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:HangRoll_80`

- **frame10** `setYSpeed(6)` → `entity.physics.velocity.y = 6;` *(direct velocity set)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**
- **mario_fla:DashAttack_24** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:Hang_78`

- **frame22** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:Hurts_72`

- **frame10** `bringBehind("global_dust_spiral")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:ItemFan_59`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemFireDash_67`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemHeavyShoot_61`

- **frame10** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame12** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemHome_Run_55`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemPickup_49`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **mario_fla:BThrow_48** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **mario_fla:BThrow_48** `replaceAttackBoxStats()` → **TODO: no mapping**
- **mario_fla:ChargeSpark_27** `replaceAttackBoxStats()` → **TODO: no mapping**

### `mario_fla:ItemRaise_62`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemShoot_60`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemSmash_53`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemThrowsAir_215`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:ItemTilt_52`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:Jab_23`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:MarioCut_InPATriangle_244`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:NSpecialAir_33`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame9** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*

### `mario_fla:Roll_74`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:Skid_16`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:Sleep_86`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:SpecialLand_22`

- **frame16** `bringBehind("adobe.utils")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:SpotDodge_76`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:Star_100`

- **frame12** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame7** `getClosestLedge()` → **TODO: no mapping**

### `mario_fla:Taunts_94`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:TechRoll_213`

- **frame14** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:TumbleFall_87`

- **frame14** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:Turn_15`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:UAir_41`

- **frame24** `bringBehind("skid")` → **TODO: no mapping**
- **frame26** `bringBehind("skid")` → **TODO: no mapping**
- **frame27** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame27** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame27** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame80** `bringBehind("skid")` → **TODO: no mapping**
- **mario_fla:DashAttack_24** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:DashAttack_24** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:DashAttack_24** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `mario_fla:USmash_29`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:USpecialAir_35`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame47** `bringBehind("attack")` → **TODO: no mapping**
- **frame52** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame9** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*

### `mario_fla:UThrow_45`

- **fireball_land** `getClosestLedge()` → **TODO: no mapping**
- **fireball_land** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **fireball_land** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **fireball_land** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **fireball_land** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **fireball_land** `removeEventListener()` → **TODO: no mapping**
- **frame10** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame11** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame12** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame13** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame14** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame21** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame21** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame21** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame21** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame25** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame25** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame27** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame7** `getClosestLedge()` → **TODO: no mapping**
- **frame9** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **mario_fla:DashAttack_24** `replaceAttackBoxStats()` → **TODO: no mapping**
- **mario_fla:USpecial_34** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*

### `mario_fla:UTilt_30`

- **frame18** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame18** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame18** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame18** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getItem()` → **TODO: no mapping**
- **frame4** `bringInFront()` → **TODO: no mapping**

### `mario_fla:Walk_14`

- **frame16** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `mario_fla:Win_12`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `moveUp`

- **frame12** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame12** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame12** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame16** `faceLeft(1, 10)` → `entity.faceLeft();` *(facing direction)*
- **frame21** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame21** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame21** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame21** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame26** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame7** `getYScale()` → **TODO: no mapping**
- **frame7** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **mario_fla:SentFlying_77** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **mario_fla:SentFlying_77** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*

### `playsound`

- **fireball_land** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **fireball_land** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **fireball_land** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **fireball_land** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame11** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame30** `setScale(2)` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `rand`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `bringBehind("metal")` → **TODO: no mapping**

### `reflected`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **mario_fla:NSpecial_32** `attachEffectOverlay()` → **TODO: no mapping**
- **mario_fla:NSpecial_32** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:NSpecial_32** `setRotation("reflect_sfx")` → `// SSF2 hitbox frame: 'reflect_sfx' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:SSpecial_36** `getYScale()` → **TODO: no mapping**

### `register`

- **Main** `removeEventListener("graphics")` → **TODO: no mapping**

### `riseAmtMax`

- **DThrow_47** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **DThrow_47** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame11** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame12** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame14** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame15** `attachEffectOverlay()` → **TODO: no mapping**
- **frame16** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame16** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame16** `faceLeft(1, 0)` → `entity.faceLeft();` *(facing direction)*
- **frame20** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame20** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame20** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame21** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame22** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame23** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame24** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame24** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame26** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame28** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getNearestPath()` → **TODO: no mapping**
- **frame9** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **mario_fla:ChargeSpark_27** `removeEventListener()` → **TODO: no mapping**
- **mario_fla:ChargeSpark_27** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **mario_fla:DThrow_47** `replaceAttackBoxStats()` → **TODO: no mapping**

### `shootOutOpponent`

- **getCharacterStat** `getCharacterStat()` → **TODO: no mapping**
- **getGrabbedOpponent** `getGrabbedOpponent()` → **TODO: no mapping**
- **getGrabbedOpponents** `getGrabbedOpponents()` → **TODO: no mapping**
- **getItem** `getItem()` → **TODO: no mapping**
- **getSizeStatus** `getSizeStatus()` → **TODO: no mapping**
- **pickupItem** `pickupItem()` → **TODO: no mapping**
- **setAttackEnabled** `setAttackEnabled()` → `attackData.setEnabled(true);` *(enable/disable attack hitboxes)*
- **setHitLag** `setHitLag()` → **TODO: no mapping**
- **setLastUsed** `setLastUsed()` → **TODO: no mapping**
- **setMetalStatus** `setMetalStatus()` → **TODO: no mapping**
- **setSizeStatus** `setSizeStatus()` → **TODO: no mapping**
- **switchAttack** `switchAttack()` → `entity.setAttack("/* attackName */");` *(switch to a different attack definition)*
- **switchAttackData** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to a different attack definition)*
- **toBarrel** `toBarrel()` → **TODO: no mapping**
- **toBounce** `toBounce()` → **TODO: no mapping**
- **toCrashLand** `toCrashLand()` → **TODO: no mapping**
- **toDodgeRoll** `toDodgeRoll()` → **TODO: no mapping**
- **toDoubleJump** `toDoubleJump()` → `entity.setState(FighterState.AirJump);` *(double jump)*
- **toFlying** `toFlying()` → **TODO: no mapping**
- **toGrabbing** `toGrabbing()` → **TODO: no mapping**
- **toHeavyLand** `toHeavyLand()` → **TODO: no mapping**
- **toHelpless** `toHelpless()` → `entity.setState(FighterState.Helpless);` *(helpless fall)*
- **toIdle** `toIdle()` → `entity.setState(FighterState.Idle);` *(transition to idle)*
- **toJump** `toJump()` → `entity.setState(FighterState.Jump);` *(jump state)*
- **toLand** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **toRoll** `toRoll()` → **TODO: no mapping**
- **toToss** `toToss()` → **TODO: no mapping**
- **tossItem** `tossItem()` → **TODO: no mapping**

### `show`

- **getOwnStats** `playSound()` → `entity.playSound("/* sound */");` *(play sound effect)*

### `standCountdown`

- **frame26** `bringBehind("dead2")` → **TODO: no mapping**
- **frame37** `setRotation("collapse")` → `// SSF2 hitbox frame: 'collapse' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame37** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame51** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **mario_fla:DThrow_47** `getClosestLedge()` → **TODO: no mapping**
- **mario_fla:DashAttack_24** `getClosestLedge()` → **TODO: no mapping**
- **mario_fla:Grab_Pummel_71** `takeDamage()` → **TODO: no mapping**

### `uncrouch`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `attachEffect()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame65** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame65** `bringBehind("ItemBubbleBounce_68")` → **TODO: no mapping**
- **frame65** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*

### `updateCameraParameters`

- **addTimedTarget** `addTimedTarget()` → **TODO: no mapping**

### `updateEnemyStats`

- **warioWareEffect** `addMovement()` → **TODO: no mapping**

### `used`

- **Jump_17** `bringBehind("lastUsedJab")` → **TODO: no mapping**
- **checkForGoToJab2** `bringBehind("hit3")` → **TODO: no mapping**
- **checkForGoToJab2** `bringBehind("lastUsedJab")` → **TODO: no mapping**
- **frame11** `faceLeft(1, 5)` → `entity.faceLeft();` *(facing direction)*
- **frame12** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame12** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame12** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame12** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame12** `setRotation("midair")` → `// SSF2 hitbox frame: 'midair' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame12** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame12** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame16** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame16** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame22** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame22** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame22** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame22** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame22** `setRotation("midair")` → `// SSF2 hitbox frame: 'midair' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame22** `resetRotation()` → `// resetRotation — deactivate hitbox shape (clear active hitbox frame)` *(SSF2 hitbox deactivation — handled by disabling collision boxes in FrayTools)*
- **frame22** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame22** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame23** `faceLeft(1, 6)` → `entity.faceLeft();` *(facing direction)*
- **frame24** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame24** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data; in Fraymakers this is done via AttackData fields)*
- **frame24** `setYSpeed(7)` → `entity.physics.velocity.y = 7;` *(direct velocity set)*
- **frame24** `setRotation("BThrow_48", 1)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("BThrow_48", 2)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("BThrow_48", 3)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame24** `setRotation("BThrow_48", 4)` → `// SSF2 hitbox frame: 'BThrow_48' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — defines which hitbox geometry is active; set via FrayTools entity editor)*
- **frame26** `faceLeft(1, 6)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 39)` → `entity.faceLeft();` *(facing direction)*
- **frame9** `faceLeft(1, 6)` → `entity.faceLeft();` *(facing direction)*
- **newStats** `bringBehind("hit3")` → **TODO: no mapping**

### `wallBounce`

- **mario_fs_cutin** `setY()` → `entity.position.y = /* value */;` *(position set)*
- **mario_fs_cutin** `attachEffectOverlay()` → **TODO: no mapping**

### `xframe`

- **frame10** `forceHitStun(-341)` → **TODO: no mapping**
- **frame10** `forceHitStun(341)` → **TODO: no mapping**
- **frame12** `unnattachFromGround()` → **TODO: no mapping**
- **frame12** `forceHitStun(-351)` → **TODO: no mapping**
- **frame12** `forceHitStun(351)` → **TODO: no mapping**
- **frame14** `forceHitStun(252)` → **TODO: no mapping**
- **frame14** `forceHitStun(4)` → **TODO: no mapping**
- **frame16** `forceHitStun(247)` → **TODO: no mapping**
- **frame16** `forceHitStun(9)` → **TODO: no mapping**
- **frame18** `forceHitStun(247)` → **TODO: no mapping**
- **frame18** `forceHitStun(9)` → **TODO: no mapping**
- **frame20** `forceHitStun(-341)` → **TODO: no mapping**
- **frame20** `forceHitStun(341)` → **TODO: no mapping**
- **frame22** `unnattachFromGround()` → **TODO: no mapping**
- **frame22** `forceHitStun(-351)` → **TODO: no mapping**
- **frame22** `forceHitStun(351)` → **TODO: no mapping**
- **frame24** `forceHitStun(252)` → **TODO: no mapping**
- **frame24** `forceHitStun(4)` → **TODO: no mapping**
- **frame26** `attachToGround()` → **TODO: no mapping**
- **frame26** `forceHitStun(245)` → **TODO: no mapping**
- **frame26** `forceHitStun(11)` → **TODO: no mapping**
- **frame28** `forceHitStun(247)` → **TODO: no mapping**
- **frame28** `forceHitStun(9)` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to a different attack definition)*
- **frame4** `attachToGround()` → **TODO: no mapping**
- **frame4** `forceHitStun(253)` → **TODO: no mapping**
- **frame4** `forceHitStun(3)` → **TODO: no mapping**
- **frame9** `attachToGround()` → **TODO: no mapping**
- **frame9** `forceHitStun(245)` → **TODO: no mapping**
- **frame9** `forceHitStun(11)` → **TODO: no mapping**
- **mario_fla:BAir_43** `resetKnockback(9)` → `attackData.resetKnockback();` *(reset knockback to base values)*
- **mario_fla:BAir_43** `attachToGround()` → **TODO: no mapping**
- **mario_fla:BAir_43** `forceHitStun(245)` → **TODO: no mapping**
- **mario_fla:BAir_43** `forceHitStun(11)` → **TODO: no mapping**
- **mario_fla:ChargeSpark_27** `getAttackBoxStat()` → **TODO: no mapping**

