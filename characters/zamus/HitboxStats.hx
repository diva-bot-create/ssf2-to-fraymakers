// HitboxStats for Zamus
// Source: ZamusExt.as → getAttackStats()
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
		hitbox0: { damage: 2, angle: 61, baseKnockback: 20, knockbackGrowth: 35, hitstop: 3, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 9, angle: 48, baseKnockback: 90, knockbackGrowth: 53, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 5, angle: 120, baseKnockback: 37, knockbackGrowth: 46, hitstop: 2, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 130, baseKnockback: 50, knockbackGrowth: 46, hitstop: 2, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox2: { damage: 5, angle: 80, baseKnockback: 37, knockbackGrowth: 55, hitstop: 2, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 75, baseKnockback: 65, knockbackGrowth: 70, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 13, angle: 45, baseKnockback: 40, knockbackGrowth: 105, limb: AttackLimb.FOOT },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 60, knockbackGrowth: 90, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 1, angle: 110, baseKnockback: 70, knockbackGrowth: 40, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 300, baseKnockback: 10, knockbackGrowth: 20, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 11, angle: 75, baseKnockback: 40, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 11, angle: 55, baseKnockback: 45, knockbackGrowth: 52, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 55, baseKnockback: 45, knockbackGrowth: 52, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 7, angle: 50, baseKnockback: 35, knockbackGrowth: 85, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 10, angle: 50, baseKnockback: 40, knockbackGrowth: 110, hitstop: 5, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 45, baseKnockback: 42, knockbackGrowth: 98, hitstop: 5, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 42, knockbackGrowth: 98, hitstop: 5, selfHitstop: 4, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: 4, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 11, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: 4, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 5, angle: 275, baseKnockback: 45, knockbackGrowth: 90, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 3, angle: 15, baseKnockback: 80, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 15, baseKnockback: 40, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox2: { damage: 3, angle: 15, baseKnockback: 30, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 3, angle: 15, baseKnockback: 80, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 15, baseKnockback: 40, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox2: { damage: 3, angle: 15, baseKnockback: 30, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 4, angle: 110, baseKnockback: 110, knockbackGrowth: 50, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 95, baseKnockback: 110, knockbackGrowth: 50, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 4, angle: 110, baseKnockback: 110, knockbackGrowth: 50, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 95, baseKnockback: 110, knockbackGrowth: 50, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox2: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FOOT },
		hitbox3: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox2: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FOOT },
		hitbox3: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 10, angle: 88, baseKnockback: 75.736, knockbackGrowth: 36.667, hitstop: 4, selfHitstop: 3, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 56.18, knockbackGrowth: 57.778, hitstop: 4, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 8, angle: 50, baseKnockback: 60, knockbackGrowth: 80, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 5, angle: 50, baseKnockback: 100, knockbackGrowth: 35, hitstop: 4, selfHitstop: 2, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 0, angle: 170, baseKnockback: 60, knockbackGrowth: 80, hitstop: 2, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: -6, baseKnockback: 60, knockbackGrowth: 80, hitstop: 2, selfHitstop: 0, limb: AttackLimb.FIST },
	},
}