// HitboxStats for Peach
// Source: PeachExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 74, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 20, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 74, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 20, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 8, angle: 80, baseKnockback: 70, knockbackGrowth: 70, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 8, angle: 35, baseKnockback: 40, knockbackGrowth: 45, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 11, angle: 100, baseKnockback: 30, knockbackGrowth: 130, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 100, baseKnockback: 30, knockbackGrowth: 130, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 12, angle: 65, baseKnockback: 60, knockbackGrowth: 70, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 270, baseKnockback: 60, knockbackGrowth: 102, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 270, baseKnockback: 50, knockbackGrowth: 102, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 12, angle: 28, baseKnockback: 65, knockbackGrowth: 60, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 28, baseKnockback: 65, knockbackGrowth: 60, hitstun: -1, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 15, angle: 90, baseKnockback: 80, knockbackGrowth: 70, hitstop: 3, limb: AttackLimb.FIST },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 50, knockbackGrowth: 60, hitstop: 3, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 140, baseKnockback: 38, knockbackGrowth: 80, hitstop: 3, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 5, knockbackGrowth: 116, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 5, knockbackGrowth: 116, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 16, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 14, angle: 80, baseKnockback: 25, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 50, baseKnockback: 15, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 3, angle: 80, baseKnockback: 23, knockbackGrowth: 30, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 3, angle: 40, baseKnockback: 20, knockbackGrowth: 180, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 3, angle: 40, baseKnockback: 20, knockbackGrowth: 180, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 13, angle: 53, baseKnockback: 50, knockbackGrowth: 65, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 13, angle: 53, baseKnockback: 50, knockbackGrowth: 65, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 1, angle: 85, baseKnockback: 75, knockbackGrowth: 20, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 85, baseKnockback: 75, knockbackGrowth: 20, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 85, baseKnockback: 75, knockbackGrowth: 20, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 85, baseKnockback: 75, knockbackGrowth: 20, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 12, angle: 30, baseKnockback: 0, knockbackGrowth: 100, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 25, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 9, angle: 88, baseKnockback: 70, knockbackGrowth: 73, hitstop: 4, selfHitstop: 4, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 41, knockbackGrowth: 105, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 10, angle: 140, baseKnockback: 65, knockbackGrowth: 75, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 11, angle: 100, baseKnockback: 60, knockbackGrowth: 50, reversibleAngle: false, baseKnockback: 0, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 110, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { limb: AttackLimb.FIST },
	},
}