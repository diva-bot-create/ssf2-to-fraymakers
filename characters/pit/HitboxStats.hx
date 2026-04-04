// HitboxStats for Pit
// Source: PitExt.as → getAttackStats()
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
		hitbox0: { damage: 2, angle: 100, baseKnockback: 40, knockbackGrowth: 15, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 2, angle: 100, baseKnockback: 40, knockbackGrowth: 15, hitstun: -1, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 11, angle: 60, baseKnockback: 80, knockbackGrowth: 74, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 11, angle: 60, baseKnockback: 90, knockbackGrowth: 74, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 7, angle: 100, baseKnockback: 40, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 10, angle: 95, baseKnockback: 40, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 4, angle: 100, baseKnockback: 0, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, hitstun: -1, baseKnockback: 60, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 100, baseKnockback: 0, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, hitstun: -1, baseKnockback: 40, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 83, baseKnockback: 70, knockbackGrowth: 46, limb: AttackLimb.FOOT },
		hitbox1: { damage: 6, angle: 83, baseKnockback: 70, knockbackGrowth: 46, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 5, angle: 75, baseKnockback: 25, knockbackGrowth: 10, hitstop: 4, selfHitstop: 2, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 285, baseKnockback: 25, knockbackGrowth: 10, hitstop: 4, selfHitstop: 2, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1, baseKnockback: 15, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1, baseKnockback: 15, limb: AttackLimb.FIST },
		hitbox2: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1, baseKnockback: 15, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 40, baseKnockback: 40, knockbackGrowth: 98, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 40, baseKnockback: 35, knockbackGrowth: 93, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 1, angle: 75, baseKnockback: 50, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 75, baseKnockback: 50, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 2.5, angle: 45, baseKnockback: 45, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 43, baseKnockback: 45, knockbackGrowth: 105, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 66, baseKnockback: 30, knockbackGrowth: 96, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 1.5, angle: 0, baseKnockback: 0, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 5, reversibleAngle: false, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 55, baseKnockback: 40, knockbackGrowth: 80, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 270, baseKnockback: 10, knockbackGrowth: 80, limb: AttackLimb.FOOT },
		hitbox2: { damage: 10, angle: 55, baseKnockback: 40, knockbackGrowth: 80, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: {}
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: {}
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 11, angle: 90, baseKnockback: 100, knockbackGrowth: 77, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 9, angle: 90, baseKnockback: 90, knockbackGrowth: 77, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 5, angle: 45, baseKnockback: 90, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 5, angle: 45, baseKnockback: 90, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
		hitbox1: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
		hitbox1: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 11, angle: 88, baseKnockback: 63.018, knockbackGrowth: 69.231, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 6, angle: 65, baseKnockback: 85.508, knockbackGrowth: 42.5, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 8, angle: 60, baseKnockback: 53, knockbackGrowth: 76, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 2, angle: 73, baseKnockback: 70, knockbackGrowth: 85, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 60, knockbackGrowth: 65, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 60, knockbackGrowth: 65, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 15, angle: 45, baseKnockback: 100, knockbackGrowth: 90, hitstop: 15, selfHitstop: 0, hitstun: -1, limb: AttackLimb.FIST },
	},
}