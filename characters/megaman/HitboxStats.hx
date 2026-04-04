// HitboxStats for Megaman
// Source: MegamanExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 60, baseKnockback: 20, knockbackGrowth: 60, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 1, angle: 28, baseKnockback: 38, knockbackGrowth: 0, hitstun: -1, reversibleAngle: false, baseKnockback: 70, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 14, angle: 45, baseKnockback: 30, knockbackGrowth: 90, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 17, angle: 85, baseKnockback: 38, knockbackGrowth: 107, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 65, baseKnockback: 65, knockbackGrowth: 55, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 50, baseKnockback: 35, knockbackGrowth: 95, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 2, angle: 115, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 160, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 17, angle: 90, baseKnockback: 30, knockbackGrowth: 99, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox1: { damage: 17, angle: 90, baseKnockback: 30, knockbackGrowth: 99, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 4, angle: 70, baseKnockback: 50, knockbackGrowth: 95, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 80, baseKnockback: 50, knockbackGrowth: 95, limb: AttackLimb.FIST },
		hitbox2: { damage: 4, angle: 80, baseKnockback: 50, knockbackGrowth: 95, limb: AttackLimb.FIST },
		hitbox3: { damage: 4, angle: 70, baseKnockback: 50, knockbackGrowth: 95, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 20, knockbackGrowth: 60, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 15, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 5, selfHitstop: 3, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 270, baseKnockback: 35, knockbackGrowth: 85, hitstop: 3, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox1: { damage: 6, angle: 80, baseKnockback: 35, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
		hitbox2: { damage: 6, angle: 80, baseKnockback: 35, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: -1, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: -1, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 4, angle: 45, baseKnockback: 30, knockbackGrowth: 105, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 4, angle: 45, baseKnockback: 30, knockbackGrowth: 105, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 0, angle: 20, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 0, angle: 20, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 0, angle: 80, baseKnockback: 0, knockbackGrowth: 16, hitstop: 1, selfHitstop: 1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 270, baseKnockback: 0, knockbackGrowth: 16, hitstop: 1, selfHitstop: 1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 7, angle: 90, baseKnockback: 80, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 40, baseKnockback: 50, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 11, angle: 120, baseKnockback: 60, knockbackGrowth: 100, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 60, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: {}
	},
}