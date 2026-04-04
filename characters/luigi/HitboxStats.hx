// HitboxStats for Luigi
// Source: LuigiExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 83, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 20, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 2, angle: 25, baseKnockback: 42, knockbackGrowth: 0, reversibleAngle: false, baseKnockback: 20, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 12, angle: 45, baseKnockback: 55, knockbackGrowth: 65, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 100, baseKnockback: 40, knockbackGrowth: 80, hitstop: 4, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 80, baseKnockback: 70, knockbackGrowth: 25, hitstun: -1, baseKnockback: 0, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 45, baseKnockback: 20, knockbackGrowth: 117, limb: AttackLimb.FOOT },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 20, knockbackGrowth: 117, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 14, angle: 95, baseKnockback: 35, knockbackGrowth: 98, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 95, baseKnockback: 35, knockbackGrowth: 98, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 13, angle: 95, baseKnockback: 35, knockbackGrowth: 98, hitstun: -1, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 14, angle: 83, baseKnockback: 40, knockbackGrowth: 85, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 12, angle: 90, baseKnockback: 30, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 12, angle: 45, baseKnockback: 43, knockbackGrowth: 80, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 9.5, angle: 45, baseKnockback: 12, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 12.5, angle: 45, baseKnockback: 12, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 78, baseKnockback: 30, knockbackGrowth: 85, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 11, angle: 78, baseKnockback: 30, knockbackGrowth: 85, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 12, angle: 47, baseKnockback: 40, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 270, baseKnockback: 40, knockbackGrowth: 80, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 5, angle: 50, baseKnockback: 44, knockbackGrowth: 115, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 5, angle: 50, baseKnockback: 44, knockbackGrowth: 115, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 25, angle: 90, baseKnockback: 50, knockbackGrowth: 75, hitstop: 8, selfHitstop: 8, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 20, angle: 90, baseKnockback: 40, knockbackGrowth: 75, hitstop: 8, selfHitstop: 8, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 9, angle: 90, baseKnockback: 50, knockbackGrowth: 80, baseKnockback: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 9, angle: 90, baseKnockback: 50, knockbackGrowth: 80, baseKnockback: 0, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 11, angle: 85, baseKnockback: 65, knockbackGrowth: 60, hitstop: 0, selfHitstop: 0, baseKnockback: 50, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 7, angle: 42, baseKnockback: 25, knockbackGrowth: 125, hitstop: 0, selfHitstop: 0, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 10, angle: 128, baseKnockback: 45, knockbackGrowth: 75, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 8, angle: 75, baseKnockback: 35, knockbackGrowth: 130, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 5, angle: 45, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 0, angle: 205, baseKnockback: 40, knockbackGrowth: 9, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: 125, baseKnockback: 75, knockbackGrowth: 9, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 0, angle: 180, baseKnockback: 75, knockbackGrowth: 9, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
}