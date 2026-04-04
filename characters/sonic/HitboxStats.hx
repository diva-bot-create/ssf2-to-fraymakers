// HitboxStats for Sonic
// Source: SonicExt.as → getAttackStats()
//
// SSF2 → Fraymakers field mapping:
//   damage      → damage
//   power       → baseKnockback
//   kbConstant  → knockbackGrowth
//   direction   → angle
//   hitStun     → hitstop
//   selfHitStun → selfHitstop
//   hitLag      → hitstun (-1 = default multiplier)
{

	//LIGHT ATTACKS
	jab1: { // SSF2: a
		hitbox0: { damage: 2, angle: 80, baseKnockback: 15, knockbackGrowth: 40, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 2, angle: 20, baseKnockback: 30, knockbackGrowth: 50, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 40, baseKnockback: 30, knockbackGrowth: 115, hitstop: 4, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 4, angle: 110, baseKnockback: 25, knockbackGrowth: 0, hitstop: 4, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 110, baseKnockback: 25, knockbackGrowth: 0, hitstop: 4, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 9, angle: 70, baseKnockback: 60, knockbackGrowth: 80, hitstop: 4, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 14, angle: 42, baseKnockback: 30, knockbackGrowth: 101, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 3, angle: 100, baseKnockback: 60, knockbackGrowth: 20, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 120, baseKnockback: 60, knockbackGrowth: 20, hitstun: -1, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 30, baseKnockback: 55, knockbackGrowth: 80, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 7, angle: 45, baseKnockback: 52, knockbackGrowth: 80, hitstop: 2, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 12, angle: 56, baseKnockback: 60, knockbackGrowth: 70, hitstop: 4, selfHitstop: 3, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 51, baseKnockback: 60, knockbackGrowth: 70, hitstop: 4, selfHitstop: 3, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 14, angle: 40, baseKnockback: 30, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 7, angle: 80, baseKnockback: 70, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, reversibleAngle: false, baseKnockback: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 105, baseKnockback: 70, knockbackGrowth: 0, hitstop: 3, selfHitstop: 1, reversibleAngle: false, baseKnockback: 0, limb: AttackLimb.FOOT },
		hitbox2: { damage: 7, angle: 90, baseKnockback: 70, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, reversibleAngle: false, baseKnockback: 0, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 9, angle: 290, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 8, angle: 45, baseKnockback: 45, knockbackGrowth: 70, hitstop: 2, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 8, angle: 45, baseKnockback: 45, knockbackGrowth: 70, hitstop: 2, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 5, angle: 120, baseKnockback: 30, knockbackGrowth: 75, hitstop: 1, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 120, baseKnockback: 30, knockbackGrowth: 75, hitstop: 1, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 5, angle: 120, baseKnockback: 30, knockbackGrowth: 75, hitstop: 1, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 120, baseKnockback: 30, knockbackGrowth: 75, hitstop: 1, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 0, angle: -1, baseKnockback: 0, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 0, angle: -1, baseKnockback: 0, knockbackGrowth: 10, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 6, angle: 57, baseKnockback: 75, knockbackGrowth: 60, hitstop: 2, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 6, angle: 57, baseKnockback: 75, knockbackGrowth: 60, hitstop: 2, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 9, angle: 90, baseKnockback: 75, knockbackGrowth: 90, hitstop: 4, selfHitstop: 3, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 10, angle: 35, baseKnockback: 100, knockbackGrowth: 10, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 11, angle: 145, baseKnockback: 70, knockbackGrowth: 60, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 2, angle: 30, baseKnockback: 60, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 80, knockbackGrowth: 20, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 22, angle: 45, baseKnockback: 50, knockbackGrowth: 74, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
}