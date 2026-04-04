# Ganondorf SSF2 → Fraymakers Conversion Report

## Attack Mapping (SSF2 → Fraymakers)

SSF2 → Fraymakers stat mapping:
- `power` → `baseKnockback` &nbsp; `kbConstant` → `knockbackGrowth` &nbsp; `hitStun` → `hitstop` &nbsp; `hitLag` → `hitstun` &nbsp; `direction` → `angle`

| SSF2 Attack | FM Name | baseKnockback (power) | knockbackGrowth (kbConstant) | hitstop (hitStun) | hitstun (hitLag) | angle (direction) |
|-------------|---------|----------------------|------------------------------|-------------------|------------------|-------------------|

## Movement Stats Extracted

| SSF2 Stat | Value |
|-----------|-------|

## Timeline Calls by Method

Each SSF2 method mapped to its Fraymakers equivalent (or TODO).

### `BeastGanonProjectile_199`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame8** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame8** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame8** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame8** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*

### `DThrow_126`

- **DSpecial_116** `bringBehind("swapChildren")` → **TODO: no mapping**
- **DSpecial_116** `attachEffectOverlay()` → **TODO: no mapping**
- **frame13** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame13** `setYSpeed(5)` → `entity.physics.velocity.y = 5;` *(direct velocity set)*
- **frame14** `setYSpeed(1.25)` → `entity.physics.velocity.y = 1.25;` *(direct velocity set)*
- **frame16** `setYSpeed(8)` → `entity.physics.velocity.y = 8;` *(direct velocity set)*
- **frame17** `faceLeft(1, 9)` → `entity.faceLeft();` *(facing direction)*
- **frame17** `removeEventListener()` → **TODO: no mapping**
- **frame17** `removeEventListener()` → **TODO: no mapping**
- **frame17** `getXSpeed()` → **TODO: no mapping**
- **frame17** `getYSpeed()` → **TODO: no mapping**
- **frame21** `setYSpeed(6.8)` → `entity.physics.velocity.y = 6.8;` *(direct velocity set)*
- **frame28** `attachEffectOverlay()` → **TODO: no mapping**
- **frame32** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame33** `setYSpeed(6.5)` → `entity.physics.velocity.y = 6.5;` *(direct velocity set)*
- **frame37** `setAttackEnabled()` → `attackData.setEnabled(true);` *(enable/disable attack hitboxes)*
- **frame37** `setYSpeed(248)` → `entity.physics.velocity.y = 248;` *(direct velocity set)*
- **frame37** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame37** `attachEffectOverlay()` → **TODO: no mapping**
- **frame37** `removeEventListener()` → **TODO: no mapping**
- **frame37** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame46** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame53** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame53** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame53** `getYScale()` → **TODO: no mapping**
- **frame53** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame53** `attachEffectOverlay()` → **TODO: no mapping**
- **frame58** `attachEffectOverlay()` → **TODO: no mapping**
- **frame58** `bringBehind("platforms")` → **TODO: no mapping**
- **frame65** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame9** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame9** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ganondorf_fla:BThrow_127** `attachEffectOverlay()` → **TODO: no mapping**
- **ganondorf_fla:BThrow_127** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:BackAir_121** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ganondorf_fla:Crouch_150** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:Crouch_150** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

### `Dash_15`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame5** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame5** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame5** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame5** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame6** `faceLeft(1, 6)` → `entity.faceLeft();` *(facing direction)*
- **ganon_fs_cutin** `setYSpeed(12)` → `entity.physics.velocity.y = 12;` *(direct velocity set)*
- **ganondorf_fla:Dash_15** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

### `DodgeRoll_155`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*

### `DoubleJump_18`

- **frame13** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame5** `getClosestLedge()` → **TODO: no mapping**

### `SSF2Utils`

- **static::getCharacterStats** `getCharacterStats()` → **TODO: no mapping**
- **static::getCharacters** `getWidth()` → **TODO: no mapping**
- **static::setFrameRate** `setFrameRate()` → **TODO: no mapping**

### `SideSpecial_Ground__113`

- **Pitfall_192** `bringBehind("unland")` → **TODO: no mapping**
- **frame14** `faceLeft(1, 8)` → `entity.faceLeft();` *(facing direction)*
- **frame14** `removeEventListener()` → **TODO: no mapping**
- **frame20** `setRotation("currentFrame")` → `// SSF2 hitbox frame: 'currentFrame' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame43** `attachEffectOverlay()` → **TODO: no mapping**
- **frame43** `removeEventListener()` → **TODO: no mapping**
- **frame43** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame43** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame43** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame43** `bringBehind("release")` → **TODO: no mapping**
- **frame44** `getNearestPath()` → **TODO: no mapping**
- **frame44** `bringBehind("uspecSparkle")` → **TODO: no mapping**
- **frame65** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame65** `getYScale()` → **TODO: no mapping**
- **frame65** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame72** `bringBehind("deactivateItem")` → **TODO: no mapping**
- **ganon_fs_cutin** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:BackAir_121** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **ganondorf_fla:DoubleJump_18** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:DoubleJump_18** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ganondorf_fla:SideSpecial_Ground__113** `replaceAttackBoxStats()` → **TODO: no mapping**

### `UpSmash_48`

- **frame14** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame14** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame14** `replaceAttackStats(3)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame16** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame21** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame21** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame21** `replaceAttackStats(3)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `addMovement`

- **warioWareEffect** `flip()` → `entity.flipFacing();` *(flip facing)*

### `attackBox4`

- **frame14** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame51** `bringBehind("attack")` → **TODO: no mapping**
- **frame52** `faceRight()` → `entity.faceRight();` *(facing direction)*

### `attackBox6`

- **frame21** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame49** `bringBehind("attack")` → **TODO: no mapping**
- **frame50** `faceRight()` → `entity.faceRight();` *(facing direction)*

### `bounceSpeed`

- **ItemDashAttack_130** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **ItemDashAttack_130** `attachEffectOverlay()` → **TODO: no mapping**
- **ItemDashAttack_130** `attachEffectOverlay()` → **TODO: no mapping**
- **ItemDashAttack_130** `bringBehind("getJumpSpeed")` → **TODO: no mapping**
- **frame18** `bringBehind("deactivateItem")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:Crouch_150** `replaceAttackBoxStats()` → **TODO: no mapping**

### `camera`

- **ForwardAir_120** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ForwardAir_120** `tossItem()` → **TODO: no mapping**
- **frame105** `bringBehind("dashLoop")` → **TODO: no mapping**
- **frame105** `bringBehind("grab_swing5")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `createTimer(20)` → `// createTimer — use Fraymakers frame counters or onUpdate callbacks` *(SSF2 timer; approximate with frame counting in onUpdate)*
- **frame4** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame6** `getXScale()` → **TODO: no mapping**

### `checkRelease`

- **Walk_14** `getXSpeed()` → **TODO: no mapping**
- **Walk_14** `getYSpeed()` → **TODO: no mapping**
- **Walk_14** `getXSpeed()` → **TODO: no mapping**
- **Walk_14** `getYSpeed()` → **TODO: no mapping**
- **Walk_14** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame21** `bringBehind("shieldDamage")` → **TODO: no mapping**
- **frame27** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **frame27** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame27** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame27** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame27** `replaceAttackStats(3)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 6)` → `entity.faceLeft();` *(facing direction)*
- **frame65** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame65** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame65** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame65** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame72** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame72** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame72** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame73** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame80** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:BackAir_121** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:ItemThrows_148** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:ItemThrows_148** `replaceAttackStats(3)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

### `continuePlaying`

- **frame12** `faceLeft(1, 0)` → `entity.faceLeft();` *(facing direction)*
- **frame13** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame17** `faceLeft(2, 3)` → `entity.faceLeft();` *(facing direction)*
- **frame17** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame20** `getItem()` → **TODO: no mapping**
- **frame20** `bringBehind("sspeccancel")` → **TODO: no mapping**
- **frame20** `faceLeft(3, 2)` → `entity.faceLeft();` *(facing direction)*
- **frame25** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame39** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame39** `attachEffectOverlay()` → **TODO: no mapping**
- **frame39** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getYScale()` → **TODO: no mapping**
- **frame4** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame4** `getNearestPath()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame42** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame42** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **frame48** `toIdle()` → `entity.setState(FighterState.Idle);` *(transition to idle)*
- **frame48** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:BackAir_121** `toFlying()` → **TODO: no mapping**
- **ganondorf_fla:BackAir_121** `setRotation("up")` → `// SSF2 hitbox frame: 'up' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **ganondorf_fla:BackAir_121** `toLand()` → `entity.setState(FighterState.Landing);` *(landing state)*
- **ganondorf_fla:BeastGanonProjectile_199** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ganondorf_fla:Dash_15** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:Dash_15** `faceLeft(1, 3)` → `entity.faceLeft();` *(facing direction)*
- **ganondorf_fla:Dash_15** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **ganondorf_fla:Dash_15** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:DoubleJump_18** `toIdle()` → `entity.setState(FighterState.Idle);` *(transition to idle)*
- **ganondorf_fla:DoubleJump_18** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:HeavyLand_22** `toBarrel(1, 0)` → **TODO: no mapping**
- **ganondorf_fla:HeavyLand_22** `replaceAttackBoxStats()` → **TODO: no mapping**

### `done`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame134`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame29`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame31`

- **frame17** `bringBehind("skid")` → **TODO: no mapping**
- **frame39** `bringBehind("skid")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **ganondorf_fla:Dizzy_165** `bringBehind("skid")` → **TODO: no mapping**

### `frame61`

- **frame22** `bringBehind("hurt3")` → **TODO: no mapping**
- **frame39** `bringBehind("hurt4")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame52** `bringBehind("ball")` → **TODO: no mapping**
- **frame62** `bringBehind("global_dust_blast")` → **TODO: no mapping**
- **frame81** `bringBehind("direction")` → **TODO: no mapping**
- **frame82** `bringBehind("faint")` → **TODO: no mapping**
- **frame99** `bringBehind("spin")` → **TODO: no mapping**
- **ganondorf_fla:Dash_15** `bringBehind("done2")` → **TODO: no mapping**
- **ganondorf_fla:HeavyLand_22** `bringBehind("hurt5")` → **TODO: no mapping**
- **ganondorf_fla:Idle_3** `bringBehind("fromState")` → **TODO: no mapping**

### `frame64`

- **frame128** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `frame67`

- **frame12** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame47** `bringBehind("attack")` → **TODO: no mapping**
- **frame48** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame52** `replaceAttackBoxStats()` → **TODO: no mapping**

### `ganondorf_fla:DSpecialAir_117`

- **frame16** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*

### `ganondorf_fla:DashAttack_24`

- **frame13** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame13** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame13** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame13** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to different attack definition)*

### `ganondorf_fla:DownSmash_72`

- **frame14** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame14** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame14** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame14** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Entrance_7`

- **frame12** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame12** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame12** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame12** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:FThrow_125`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Fall_19`

- **frame14** `addTimedTarget(6)` → **TODO: no mapping**
- **frame14** `getXSpeed()` → **TODO: no mapping**
- **frame14** `getYSpeed()` → **TODO: no mapping**
- **frame14** `getXSpeed()` → **TODO: no mapping**
- **frame14** `getYSpeed()` → **TODO: no mapping**
- **frame14** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame21** `getXSpeed()` → **TODO: no mapping**
- **frame21** `getYSpeed()` → **TODO: no mapping**
- **frame21** `getXSpeed()` → **TODO: no mapping**
- **frame21** `getYSpeed()` → **TODO: no mapping**
- **frame21** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame22** `getXSpeed()` → **TODO: no mapping**
- **frame22** `getYSpeed()` → **TODO: no mapping**
- **frame22** `getXSpeed()` → **TODO: no mapping**
- **frame22** `getYSpeed()` → **TODO: no mapping**
- **frame22** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame27** `getXSpeed()` → **TODO: no mapping**
- **frame27** `getYSpeed()` → **TODO: no mapping**
- **frame27** `getXSpeed()` → **TODO: no mapping**
- **frame27** `getYSpeed()` → **TODO: no mapping**
- **frame27** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame33** `getXSpeed()` → **TODO: no mapping**
- **frame33** `getYSpeed()` → **TODO: no mapping**
- **frame33** `getXSpeed()` → **TODO: no mapping**
- **frame33** `getYSpeed()` → **TODO: no mapping**
- **frame33** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame33** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame33** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame33** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame33** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:FinalSmash_188`

- **frame13** `bringBehind("afterHit")` → **TODO: no mapping**
- **frame23** `bringBehind("afterHit")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ForwardSmash_26`

- **frame21** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame21** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame21** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame21** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:GanondorfCut_InPATriangle_201`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:GetupRoll_170`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**
- **ganondorf_fla:Crouch_150** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:Grab_152`

- **frame17** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:Helpless_20`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:HurtFrames_153`

- **frame20** `bringBehind("reg")` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("up")` → `// SSF2 hitbox frame: 'up' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `bringBehind("reg")` → **TODO: no mapping**
- **frame4** `bringBehind("hurt1")` → **TODO: no mapping**
- **ganondorf_fla:Dash_15** `bringBehind("hurt1")` → **TODO: no mapping**

### `ganondorf_fla:ItemAssist_142`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemBubbleBounce_147`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemFan_139`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemFireDash_146`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemHome_Run_134`

- **frame14** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame21** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemJab_129`

- **frame35** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **ganondorf_fla:BackAir_121** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **ganondorf_fla:BackAir_121** `replaceAttackBoxStats()` → **TODO: no mapping**

### `ganondorf_fla:ItemPickup_128`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemScrew_143`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemSmash_132`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:ItemTilt_131`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Jab_23`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Jump_17`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Land_21`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab")` → `// SSF2 hitbox frame: 'jab' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*

### `ganondorf_fla:LedgeAttack_162`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:LedgeGetup_160`

- **frame13** `setYSpeed(9)` → `entity.physics.velocity.y = 9;` *(direct velocity set)*
- **frame17** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame17** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame17** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame17** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame18** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:LedgeHang_159`

- **frame23** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**
- **ganondorf_fla:Dash_15** `setYSpeed(7)` → `entity.physics.velocity.y = 7;` *(direct velocity set)*

### `ganondorf_fla:LedgeRoll_161`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:NeutralAir_118`

- **frame24** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:RevivalPlatform_8`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:SentFlying_158`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Shield_163`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:SideSpecial_Air__115`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Skid_16`

- **frame22** `getXSpeed()` → **TODO: no mapping**
- **frame22** `getYSpeed()` → **TODO: no mapping**
- **frame22** `getXSpeed()` → **TODO: no mapping**
- **frame22** `getYSpeed()` → **TODO: no mapping**
- **frame22** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame28** `getXSpeed()` → **TODO: no mapping**
- **frame28** `getYSpeed()` → **TODO: no mapping**
- **frame28** `getXSpeed()` → **TODO: no mapping**
- **frame28** `getYSpeed()` → **TODO: no mapping**
- **frame28** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame33** `faceLeft(1, 9)` → `entity.faceLeft();` *(facing direction)*
- **frame33** `removeEventListener()` → **TODO: no mapping**
- **frame35** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame35** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setYSpeed(231)` → `entity.physics.velocity.y = 231;` *(direct velocity set)*
- **frame4** `setRotation("currentFrame")` → `// SSF2 hitbox frame: 'currentFrame' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame43** `attachEffectOverlay()` → **TODO: no mapping**
- **frame43** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame43** `getYScale()` → **TODO: no mapping**
- **frame43** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame43** `bringBehind("release")` → **TODO: no mapping**
- **frame51** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame6** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **ganon_fs_cutin** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:DSpecial_116** `getYScale()` → **TODO: no mapping**
- **ganondorf_fla:DSpecial_116** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:DoubleJump_18** `getXSpeed()` → **TODO: no mapping**
- **ganondorf_fla:DoubleJump_18** `getYSpeed()` → **TODO: no mapping**
- **ganondorf_fla:DoubleJump_18** `getXSpeed()` → **TODO: no mapping**
- **ganondorf_fla:DoubleJump_18** `getYSpeed()` → **TODO: no mapping**
- **ganondorf_fla:DoubleJump_18** `setGlobalVariable(0)` → **TODO: no mapping**

### `ganondorf_fla:Spotdodge_157`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `ganondorf_fla:Stunned_164`

- **frame14** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame6** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:Taunt_172`

- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `setRotation("jab2")` → `// SSF2 hitbox frame: 'jab2' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `setRotation("crouchdown")` → `// SSF2 hitbox frame: 'crouchdown' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*

### `ganondorf_fla:Tech_193`

- **frame13** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:USpecial_112`

- **frame13** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getClosestLedge()` → **TODO: no mapping**

### `ganondorf_fla:UpAir_119`

- **frame26** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to different attack definition)*
- **frame28** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **frame28** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to different attack definition)*

### `ganondorf_fla:Win_12`

- **frame4** `getPlayer()` → **TODO: no mapping**

### `getAttackStats`

- **addEventListener** `addEventListener()` → **TODO: no mapping**
- **applyKnockback** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **applyKnockbackSpeed** `applyKnockbackSpeed()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
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
- **refreshAttackID** `refreshAttackID()` → `attackData.refreshId();` *(refreshes attack hit ID)*
- **remove** `getRotation()` → **TODO: no mapping**
- **removeEventListener** `removeEventListener()` → **TODO: no mapping**
- **removeFromCamera** `removeFromCamera()` → **TODO: no mapping**
- **removeSelfPlatform** `removeSelfPlatform()` → **TODO: no mapping**
- **replaceAttackBoxStats** `replaceAttackBoxStats()` → **TODO: no mapping**
- **replaceAttackStats** `replaceAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **resetFade** `resetFade()` → **TODO: no mapping**
- **resetKnockback** `resetKnockback()` → `attackData.resetKnockback();` *(reset knockback to base values)*
- **resetKnockbackDecay** `resetKnockbackDecay()` → **TODO: no mapping**
- **resetRotation** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **safeMove** `safeMove()` → **TODO: no mapping**
- **setCamBoxSize** `setCamBoxSize()` → **TODO: no mapping**
- **setColorFilters** `setColorFilters()` → **TODO: no mapping**
- **setDamage** `setDamage()` → `attackData.damage = /* damage */;` *(override attack damage this frame)*
- **setGlobalVariable** `setGlobalVariable()` → **TODO: no mapping**
- **setIntangibility** `setIntangibility()` → **TODO: no mapping**
- **setInvincibility** `setInvincibility()` → **TODO: no mapping**
- **setKnockbackDecay** `setKnockbackDecay()` → `attackData.knockbackGrowth = /* kbg */;` *(override knockback growth)*
- **setPosition** `setPosition()` → **TODO: no mapping**
- **setRotation** `setRotation()` → `// SSF2 hitbox frame: '' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
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
- **updateAttackStats** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

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

### `glow`

- **DownTilt_151** `setState()` → `entity.setState("/* state */");` *(explicit state set)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame45** `bringBehind("attack")` → **TODO: no mapping**
- **frame46** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame5** `faceLeft(4, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame72** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame72** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*

### `groundReverseStats`

- **Pitfall_192** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **Pitfall_192** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame35** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame35** `setYSpeed(24)` → `entity.physics.velocity.y = 24;` *(direct velocity set)*
- **frame35** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame36** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame42** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame71** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame71** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame71** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame71** `bringBehind("swapChildren")` → **TODO: no mapping**
- **frame72** `getAttackBoxStat()` → **TODO: no mapping**
- **frame8** `bringBehind("land")` → **TODO: no mapping**
- **frame8** `replaceAttackBoxStats()` → **TODO: no mapping**
- **ganondorf_fla:DSpecial_116** `setYSpeed(10)` → `entity.physics.velocity.y = 10;` *(direct velocity set)*
- **ganondorf_fla:Pitfall_192** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:Pitfall_192** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

### `hitBox2`

- **effect_darkhit** `toFlying()` → **TODO: no mapping**
- **effect_darkhit** `bringBehind("global_dust_swirl")` → **TODO: no mapping**
- **frame26** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame5** `getClosestLedge()` → **TODO: no mapping**
- **frame5** `removeEventListener()` → **TODO: no mapping**

### `hitBox6`

- **HeavyLand_22** `getYScale()` → **TODO: no mapping**
- **HeavyLand_22** `getYScale()` → **TODO: no mapping**
- **HeavyLand_22** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **HeavyLand_22** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame20** `getYScale()` → **TODO: no mapping**
- **frame20** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame20** `removeEventListener()` → **TODO: no mapping**
- **frame30** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `getYScale()` → **TODO: no mapping**
- **frame4** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **frame42** `bringBehind("metal_step_m2")` → **TODO: no mapping**
- **frame44** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame44** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*

### `hitTestPoint`

- **getXSpeed** `setXSpeed()` → `entity.physics.velocity.x = /* value */;` *(direct velocity set)*
- **getYSpeed** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **hitTestRect** `getXScale()` → **TODO: no mapping**
- **setY** `getYScale()` → **TODO: no mapping**

### `jumpToContinue`

- **GanondorfExt** `getXScale("The King of Evil has arrisen. Ganondorf initialized.")` → **TODO: no mapping**
- **_animationLock** `attachEffectOverlay()` → **TODO: no mapping**
- **_getWeight** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **_moveOpp** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **_notArmoured** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **_notArmoured** `playSound(4)` → `entity.playSound("/* sound */");` *(play sound effect)*
- **_notArmoured** `getXScale("canReceiveHits")` → **TODO: no mapping**
- **_notArmoured** `getXScale("gravity")` → **TODO: no mapping**
- **_notArmoured** `getXSpeed()` → **TODO: no mapping**
- **_notArmoured** `getYScale()` → **TODO: no mapping**
- **_notArmoured** `getYScale()` → **TODO: no mapping**
- **_notArmoured** `getYSpeed()` → **TODO: no mapping**
- **_notArmoured** `getNearestPath()` → **TODO: no mapping**
- **_notArmoured** `getXScale("attackBoxData")` → **TODO: no mapping**
- **_notArmoured** `resetKnockbackDecay()` → **TODO: no mapping**
- **_notArmoured** `applyKnockbackSpeed()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **_notArmoured** `setState()` → `entity.setState("/* state */");` *(explicit state set)*
- **_xOffset** `getInvincibility()` → **TODO: no mapping**
- **_xOffset** `removeEventListener()` → **TODO: no mapping**
- **addEffectToList** `removeEventListener()` → **TODO: no mapping**
- **applyPaletteToEffect** `attachEffect()` → **TODO: no mapping**
- **applyPaletteToEffect** `attachEffectOverlay()` → **TODO: no mapping**
- **clearListener** `attachEffectOverlay()` → **TODO: no mapping**
- **clearListener** `removeEventListener()` → **TODO: no mapping**
- **clearListener** `attachEffectOverlay()` → **TODO: no mapping**
- **clearListener** `removeEventListener()` → **TODO: no mapping**
- **clearListener** `toFlying()` → **TODO: no mapping**
- **effects** `attachEffectOverlay()` → **TODO: no mapping**
- **effects** `replaceAttackBoxStats()` → **TODO: no mapping**
- **effects** `bringBehind("swapChildren")` → **TODO: no mapping**
- **updateAutolinkFunction** `attachEffect()` → **TODO: no mapping**
- **updateAutolinkFunction** `attachEffectOverlay()` → **TODO: no mapping**
- **updateAutolinkTarget** `applyKnockback()` → `attackData.applyKnockback(target);` *(apply knockback to target)*
- **updateAutolinkTarget** `removeEventListener()` → **TODO: no mapping**

### `method_3471`

- **unknown** `attachEffectOverlay()` → **TODO: no mapping**

### `method_3914`

- **unknown** `faceRight()` → `entity.faceRight();` *(facing direction)*

### `moveUp`

- **frame14** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame14** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame14** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame17** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame17** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame17** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame17** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **frame26** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame5** `faceLeft(1, 10)` → `entity.faceLeft();` *(facing direction)*
- **frame6** `getYScale()` → **TODO: no mapping**
- **frame6** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:ItemShoot_140** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:ItemShoot_140** `replaceAttackStats(2)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*

### `multiplier`

- **DSpecial_116** `bringBehind("swapChildren")` → **TODO: no mapping**
- **DSpecial_116** `attachEffectOverlay()` → **TODO: no mapping**
- **frame14** `faceLeft(1, 7)` → `entity.faceLeft();` *(facing direction)*
- **frame28** `attachEffectOverlay()` → **TODO: no mapping**
- **frame28** `attachEffectOverlay()` → **TODO: no mapping**
- **frame28** `removeEventListener()` → **TODO: no mapping**
- **frame33** `replaceAttackBoxStats()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **frame6** `setYSpeed(0)` → `entity.physics.velocity.y = 0;` *(direct velocity set)*
- **frame9** `setYSpeed()` → `entity.physics.velocity.y = /* value */;` *(direct velocity set)*
- **ganondorf_fla:DSpecial_116** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **ganondorf_fla:DSpecial_116** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **ganondorf_fla:DSpecial_116** `resetRotation()` → `// resetRotation — deactivate hitbox shape` *(SSF2 hitbox deactivation)*
- **ganondorf_fla:DSpecial_116** `replaceAttackBoxStats()` → **TODO: no mapping**

### `reflected`

- **frame16** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame16** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `replaceAttackStats(1)` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame4** `removeEventListener()` → **TODO: no mapping**
- **ganondorf_fla:NeutralSpecial_89** `getYScale()` → **TODO: no mapping**

### `register`

- **Main** `removeEventListener("graphics")` → **TODO: no mapping**

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
- **switchAttack** `switchAttack()` → `entity.setAttack("/* attackName */");` *(switch to different attack definition)*
- **switchAttackData** `switchAttackData()` → `entity.setAttack("/* attackName */");` *(switch to different attack definition)*
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

- **frame15** `setRotation("collapse", -1)` → `// SSF2 hitbox frame: 'collapse' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame15** `faceRight()` → `entity.faceRight();` *(facing direction)*
- **frame23** `getClosestLedge()` → **TODO: no mapping**
- **frame26** `bringBehind("dead2")` → **TODO: no mapping**
- **frame30** `getClosestLedge()` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame40** `faceLeft(1, 255)` → `entity.faceLeft();` *(facing direction)*
- **frame52** `takeDamage()` → **TODO: no mapping**

### `testPalettes`

- **frame11** `updateAttackStats()` → `// updateAttackStats — apply attackData object to active hitboxes` *(update live hitbox data via AttackData fields in Fraymakers)*
- **frame28** `stopSound(15)` → **TODO: no mapping**
- **frame28** `setY("ganondorf_final_03")` → `entity.position.y = /* value */;` *(position set)*
- **frame47** `setY("ganondorf_fsmash")` → `entity.position.y = /* value */;` *(position set)*
- **ganondorf_fla:BThrow_127** `setY("ganondorf_final_04")` → `entity.position.y = /* value */;` *(position set)*

### `touchBox`

- **frame23** `getXSpeed()` → **TODO: no mapping**
- **frame23** `getYSpeed()` → **TODO: no mapping**
- **frame23** `getXSpeed()` → **TODO: no mapping**
- **frame23** `getYSpeed()` → **TODO: no mapping**
- **frame23** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `getXSpeed()` → **TODO: no mapping**
- **frame25** `getYSpeed()` → **TODO: no mapping**
- **frame25** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame26** `getXSpeed()` → **TODO: no mapping**
- **frame26** `getYSpeed()` → **TODO: no mapping**
- **frame26** `getXSpeed()` → **TODO: no mapping**
- **frame26** `getYSpeed()` → **TODO: no mapping**
- **frame26** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame26** `setRotation("eff", 1)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 2)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 3)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame26** `setRotation("eff", 4)` → `// SSF2 hitbox frame: 'eff' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame27** `getXSpeed()` → **TODO: no mapping**
- **frame27** `getYSpeed()` → **TODO: no mapping**
- **frame27** `getXSpeed()` → **TODO: no mapping**
- **frame27** `getYSpeed()` → **TODO: no mapping**
- **frame27** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame30** `getXSpeed()` → **TODO: no mapping**
- **frame30** `getYSpeed()` → **TODO: no mapping**
- **frame30** `getXSpeed()` → **TODO: no mapping**
- **frame30** `getYSpeed()` → **TODO: no mapping**
- **frame30** `setGlobalVariable(0)` → **TODO: no mapping**
- **frame4** `getPlayer()` → **TODO: no mapping**

### `uncrouch`

- **frame113** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame113** `bringBehind("frame110")` → **TODO: no mapping**
- **frame113** `setRotation("loop")` → `// SSF2 hitbox frame: 'loop' (handled by entity asset collision boxes in FrayTools)` *(SSF2 hitbox shape selector — set via FrayTools entity editor)*
- **frame4** `getPlayer()` → **TODO: no mapping**
- **frame4** `attachEffect()` → **TODO: no mapping**
- **frame4** `removeEventListener()` → **TODO: no mapping**

### `updateCameraParameters`

- **addTimedTarget** `addTimedTarget()` → **TODO: no mapping**

### `updateEnemyStats`

- **warioWareEffect** `addMovement()` → **TODO: no mapping**

