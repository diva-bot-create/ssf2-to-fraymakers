// HitboxStats for Goku
// Source: GokuExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 75, baseKnockback: 25, knockbackGrowth: 20, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 75, baseKnockback: 25, knockbackGrowth: 20, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 4, angle: 50, baseKnockback: 70, knockbackGrowth: 0, hitstop: 6, selfHitstop: 3, limb: AttackLimb.FOOT },
		hitbox1: { damage: 4, angle: 50, baseKnockback: 70, knockbackGrowth: 0, hitstop: 6, selfHitstop: 3, limb: AttackLimb.FOOT },
		hitbox2: { damage: 4, angle: 150, baseKnockback: 45, knockbackGrowth: 0, hitstop: 6, selfHitstop: 3, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 3, angle: 60, baseKnockback: 35, knockbackGrowth: 0, hitstop: 3, selfHitstop: 1, reversibleAngle: false, baseKnockback: 10, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 120, baseKnockback: 30, knockbackGrowth: 0, hitstop: 3, selfHitstop: 1, reversibleAngle: false, baseKnockback: 10, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 11, angle: 58, baseKnockback: 81, knockbackGrowth: 68, hitstop: 5, selfHitstop: 5, hitstun: -1, baseKnockback: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 58, baseKnockback: 81, knockbackGrowth: 68, hitstop: 5, selfHitstop: 5, hitstun: -1, baseKnockback: 0, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 36, baseKnockback: 40, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 8, angle: 45, baseKnockback: 111, knockbackGrowth: 2, hitstop: 5, selfHitstop: 4, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 2, hitstop: 5, selfHitstop: 4, reversibleAngle: false, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 15, angle: 75, baseKnockback: 40, knockbackGrowth: 100, hitstop: 8, selfHitstop: 7, limb: AttackLimb.FIST },
		hitbox1: { damage: 9, angle: 75, baseKnockback: 40, knockbackGrowth: 70, hitstop: 7, selfHitstop: 6, limb: AttackLimb.FIST },
		hitbox2: { damage: 5, angle: 75, baseKnockback: 40, knockbackGrowth: 50, hitstop: 6, selfHitstop: 5, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 10, angle: 30, baseKnockback: 40, knockbackGrowth: 99, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 4, angle: 50, baseKnockback: 65, knockbackGrowth: 10, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 11, angle: 280, baseKnockback: 20, knockbackGrowth: 72, hitstop: 6, selfHitstop: 5, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 280, baseKnockback: 20, knockbackGrowth: 72, hitstop: 6, selfHitstop: 5, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 35, baseKnockback: 25, knockbackGrowth: 100, hitstop: 6, selfHitstop: 4, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 35, baseKnockback: 25, knockbackGrowth: 100, hitstop: 6, selfHitstop: 4, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 10, angle: 75, baseKnockback: 40, knockbackGrowth: 95, hitstop: 5, selfHitstop: 3, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 75, baseKnockback: 40, knockbackGrowth: 95, hitstop: 5, selfHitstop: 3, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 8, angle: 50, baseKnockback: 60, knockbackGrowth: 100, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 75, baseKnockback: 90, knockbackGrowth: 80, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox2: { damage: 10, angle: 75, baseKnockback: 90, knockbackGrowth: 80, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 2, angle: 31, baseKnockback: 35, knockbackGrowth: 49, hitstop: -1, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 2, angle: 31, baseKnockback: 35, knockbackGrowth: 49, hitstop: -1, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 7, angle: 65, baseKnockback: 65, knockbackGrowth: 0, hitstop: 8, selfHitstop: 7, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 7, angle: 65, baseKnockback: 65, knockbackGrowth: 0, hitstop: 8, selfHitstop: 7, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 7, angle: 38, baseKnockback: 40, knockbackGrowth: 95, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 7, angle: 38, baseKnockback: 40, knockbackGrowth: 95, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 3, angle: -3, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 50, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 3, angle: -3, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 50, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 9, angle: 85, baseKnockback: 60, knockbackGrowth: 40, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 12, angle: 30, baseKnockback: 70, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 14, angle: 135, baseKnockback: 75, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 15, angle: 40, baseKnockback: 60, knockbackGrowth: 80, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 30, baseKnockback: 0, knockbackGrowth: 110, baseKnockback: 100, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 13, angle: 55, baseKnockback: 120, knockbackGrowth: 120, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FIST },
	},
}