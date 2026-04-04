// HitboxStats for Jigglypuff
// Source: JigglypuffExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 70, baseKnockback: 38, knockbackGrowth: 20, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 12, angle: 59, baseKnockback: 58, knockbackGrowth: 80, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 10, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 90, baseKnockback: 45, knockbackGrowth: 120, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 22, baseKnockback: 40, knockbackGrowth: 30, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 40, baseKnockback: 20, knockbackGrowth: 100, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 15, angle: 90, baseKnockback: 20, knockbackGrowth: 110, limb: AttackLimb.FIST },
		hitbox1: { damage: 15, angle: 90, baseKnockback: 20, knockbackGrowth: 110, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 15, baseKnockback: 25, knockbackGrowth: 95, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 95, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 95, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 45, baseKnockback: 15, knockbackGrowth: 120, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 75, baseKnockback: 40, knockbackGrowth: 80, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 2, angle: 64, baseKnockback: 50, knockbackGrowth: 20, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 8, angle: 75, baseKnockback: 30, knockbackGrowth: 102, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 8, angle: 75, baseKnockback: 30, knockbackGrowth: 102, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 9, angle: 100, baseKnockback: 55, knockbackGrowth: 75, hitstun: -1, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 9, angle: 100, baseKnockback: 52, knockbackGrowth: 75, hitstun: -1, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 0, angle: 85, baseKnockback: 0, knockbackGrowth: 0, hitstop: 0, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 0, angle: 85, baseKnockback: 0, knockbackGrowth: 0, hitstop: 0, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 18, angle: 45, baseKnockback: 110, knockbackGrowth: 115, hitstop: 15, selfHitstop: 15, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 18, angle: 45, baseKnockback: 110, knockbackGrowth: 115, hitstop: 15, selfHitstop: 15, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 8, angle: 95, baseKnockback: 105, knockbackGrowth: 35, hitstop: 0, selfHitstop: 0, hitstun: -1, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 12, angle: 45, baseKnockback: 40, knockbackGrowth: 105, hitstop: 3, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 10, angle: 135, baseKnockback: 90, knockbackGrowth: 40, hitstop: 3, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 4, angle: 75, baseKnockback: 60, knockbackGrowth: 100, hitstop: 1, selfHitstop: 0, hitstun: -1, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 9, angle: 40, baseKnockback: 0, knockbackGrowth: 110, baseKnockback: 100, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 0, angle: 25, baseKnockback: 10, knockbackGrowth: 20, hitstop: 0, selfHitstop: 0, baseKnockback: 210, limb: AttackLimb.FIST },
	},
}