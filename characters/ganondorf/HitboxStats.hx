// HitboxStats for Ganondorf
// Source: GanondorfExt.as → getAttackStats()
//
// SSF2 → Fraymakers field mapping:
//   damage      → damage
//   power       → baseKnockback   (base force component)
//   kbConstant  → knockbackGrowth (scales with damage%)
//   direction   → angle
//   hitStun     → hitstop         (freeze frames on hit)
//   selfHitStun → selfHitstop
//   hitLag      → hitstun         (SSF2 hitLag is a multiplier; -1 = default)
//
// NOTE: SSF2 hitLag values like -1.1 are multipliers on default hitstun,
//       not absolute frame counts. Map to hitstun:-1 (use default) for now.
{
	//LIGHT ATTACKS
	jab1: { // SSF2: a (shock effect, electric)
		hitbox0: { damage: 11, angle: 40, baseKnockback: 40, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 40, baseKnockback: 40, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	dash_attack: { // SSF2: a_forward (xSpeedDecay:-1.3)
		hitbox0: { damage: 14, angle: 85, baseKnockback: 62, knockbackGrowth: 70, hitstop: 6, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FOOT }
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt (xSpeedDecay:-1)
		hitbox0: { damage: 13, angle: 15, baseKnockback: 39, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, hitstun: -1, limb: AttackLimb.FOOT }
	},
	tilt_up: { // SSF2: a_up_tilt — multi-hit launch sequence (refreshRate:3, xSpeedDecay:-2.8)
		hitbox0: { damage: 0, angle: 0,   baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, reversibleAngle: false },
		hitbox1: { damage: 0, angle: 180, baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, reversibleAngle: false },
		hitbox2: { damage: 0, angle: 180, baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, reversibleAngle: false }
	},
	tilt_down: { // SSF2: crouch_attack (xSpeedDecay:-1.9)
		hitbox0: { damage: 13, angle: 75, baseKnockback: 30, knockbackGrowth: 75, hitstop: 6, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 85, baseKnockback: 30, knockbackGrowth: 75, hitstop: 6, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FOOT }
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash (chargetime_max:40, chargeClick)
		hitbox0: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox1: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox2: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox3: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY }
	},
	strong_up_attack: { // SSF2: a_up (chargetime_max:40, chargeClick) — uncharged vs charged hitboxes
		hitbox0: { damage: 21, angle: 75, baseKnockback: 40, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox1: { damage: 21, angle: 75, baseKnockback: 40, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox2: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox3: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox4: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
		hitbox5: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY }
	},
	strong_down_attack: { // SSF2: a_down (chargetime_max:40) — air vs ground variants
		hitbox0: { damage: 5, angle: 90, baseKnockback: 60, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 90, baseKnockback: 60, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FOOT }
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air (maintainSpeed, canFallOff)
		hitbox0: { damage: 12, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST }
	},
	aerial_forward: { // SSF2: a_air_forward (canUseInAir)
		hitbox0: { damage: 17, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 6, selfHitstop: 3, limb: AttackLimb.FIST },
		hitbox1: { damage: 17, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 6, selfHitstop: 3, limb: AttackLimb.FIST }
	},
	aerial_back: { // SSF2: a_air_backward — weak hit then strong sweetspot
		hitbox0: { damage: 17, angle: 45, baseKnockback: 20, knockbackGrowth: 90, hitstop: 5, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 18, angle: 45, baseKnockback: 40, knockbackGrowth: 90, hitstop: 7, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FIST }
	},
	aerial_up: { // SSF2: a_air_up (3 hitboxes, slight damage dropoff)
		hitbox0: { damage: 13, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox2: { damage: 12, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT }
	},
	aerial_down: { // SSF2: a_air_down (spike, shock/electric, camShake:16)
		hitbox0: { damage: 22, angle: 280, baseKnockback: 70, knockbackGrowth: 80, hitstop: 12, selfHitstop: 8, limb: AttackLimb.FOOT }
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b — Warlock Punch (damage:32, massive knockback, darkness)
		hitbox0: { damage: 32, angle: 50, baseKnockback: 120, knockbackGrowth: 46, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FIST }
	},
	special_neutral_air: { // SSF2: b_air — aerial Warlock Punch (damage:38, more base KB)
		hitbox0: { damage: 38, angle: 30, baseKnockback: 30, knockbackGrowth: 100, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FIST }
	},
	special_side: { // SSF2: b_forward — Flame Choke (grabs, direction:270 = meteor, forceTumbleFall)
		hitbox0: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST }
	},
	special_side_air: { // SSF2: b_forward_air (damage:15, air_ease:0)
		hitbox0: { damage: 15, angle: 270, baseKnockback: 60, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST }
	},
	special_up: { // SSF2: b_up — Dark Dive (isRecoveryMove, bypassNonGrabbed:true, damage:1)
		hitbox0: { damage: 1, angle: 20, baseKnockback: 50, knockbackGrowth: 40, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST }
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 20, baseKnockback: 50, knockbackGrowth: 40, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST }
	},
	special_down: { // SSF2: b_down — Wizard's Foot (darkness, xSpeedDecay:-1)
		hitbox0: { damage: 13, angle: 40, baseKnockback: 60, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 40, baseKnockback: 60, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FOOT }
	},
	special_down_air: { // SSF2: b_down_air (direction:291 = spike-ish, reversableAngle:false)
		hitbox0: { damage: 15, angle: 291, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 15, angle: 291, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.FOOT }
	},

	//THROWS
	throw_up: { // SSF2: throw_up — hitbox = bystanders, hitbox2 = grabbed target
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, reversibleAngle: false, limb: AttackLimb.BODY },
		hitbox1: { damage: 4, angle: 70, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, reversibleAngle: false, limb: AttackLimb.HEAD }
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3,  angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, reversibleAngle: false, limb: AttackLimb.BODY },
		hitbox1: { damage: 9,  angle: 45, baseKnockback: 40, knockbackGrowth: 90,  hitstop: 5,  selfHitstop: 4,  reversibleAngle: false, limb: AttackLimb.BODY }
	},
	throw_back: { // SSF2: throw_back (direction:130)
		hitbox0: { damage: 10, angle: 130, baseKnockback: 50, knockbackGrowth: 85, hitstop: 4, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.BODY }
	},
	throw_down: { // SSF2: throw_down (direction:80, forceTumbleFall)
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY }
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack (damage:9, priority:3)
		hitbox0: { damage: 9, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT }
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT }
	},
	emote: {
		hitbox0: {}
	}
}
