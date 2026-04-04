// HitboxStats for Donkeykong
// Source: DonkeykongExt.as → getAttackStats()
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
		hitbox0: { damage: 4, angle: 45, baseKnockback: 20, knockbackGrowth: 60, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 11, angle: 60, baseKnockback: 100, knockbackGrowth: 30, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 10, angle: 33, baseKnockback: 30, knockbackGrowth: 90, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 11, angle: 90, baseKnockback: 35, knockbackGrowth: 105, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 90, baseKnockback: 35, knockbackGrowth: 105, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 37, baseKnockback: 40, knockbackGrowth: 60, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 20, angle: 45, baseKnockback: 30, knockbackGrowth: 91, hitstun: -1, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 18, angle: 90, baseKnockback: 42.8, knockbackGrowth: 85, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 17, angle: 115, baseKnockback: 35, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 17, angle: 115, baseKnockback: 35, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 140, baseKnockback: 21.4, knockbackGrowth: 89, hitstop: 4, selfHitstop: 2, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 140, baseKnockback: 21.4, knockbackGrowth: 89, hitstop: 4, selfHitstop: 2, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 80, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 80, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 16, angle: 270, baseKnockback: 30, knockbackGrowth: 90, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox1: { damage: 16, angle: 270, baseKnockback: 30, knockbackGrowth: 90, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 10, angle: 45, baseKnockback: 15, knockbackGrowth: 100, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 7, angle: 45, baseKnockback: 15, knockbackGrowth: 100, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 10, angle: 271, baseKnockback: 20, knockbackGrowth: 40, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 11, angle: 271, baseKnockback: 30, knockbackGrowth: 40, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 14, angle: 45, baseKnockback: 50, knockbackGrowth: 70, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 50, knockbackGrowth: 70, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 11, angle: 80, baseKnockback: 85, knockbackGrowth: 30, hitstop: 2, selfHitstop: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 25, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 9, angle: 85, baseKnockback: 55, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 48, baseKnockback: 80, knockbackGrowth: 56, hitstop: 1, selfHitstop: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 11, angle: 50, baseKnockback: 54, knockbackGrowth: 95, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 7, angle: 75, baseKnockback: 60, knockbackGrowth: 80, hitstop: 3, selfHitstop: 1, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 50, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 0, angle: 0, baseKnockback: 2, knockbackGrowth: 1, hitstop: 1, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
}