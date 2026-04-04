// HitboxStats for Bomberman
// Source: BombermanExt.as → getAttackStats()
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
		hitbox0: { damage: 2, angle: 55, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 9, angle: 30, baseKnockback: 70, knockbackGrowth: 80, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 10, angle: 46, baseKnockback: 25, knockbackGrowth: 100, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 85, baseKnockback: 40, knockbackGrowth: 105, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 85, baseKnockback: 40, knockbackGrowth: 105, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 9, angle: 70, baseKnockback: 45, knockbackGrowth: 105, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 13, angle: 40, baseKnockback: 84, knockbackGrowth: 75, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 40, baseKnockback: 84, knockbackGrowth: 75, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 3, angle: 110, baseKnockback: 90, knockbackGrowth: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 110, baseKnockback: 90, knockbackGrowth: 0, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 18, angle: 60, baseKnockback: 80, knockbackGrowth: 60, limb: AttackLimb.FOOT },
		hitbox1: { damage: 18, angle: 60, baseKnockback: 80, knockbackGrowth: 60, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 10, angle: 80, baseKnockback: 20, knockbackGrowth: 95, hitstop: 5, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 20, knockbackGrowth: 95, hitstop: 5, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 12, angle: 46, baseKnockback: 50, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 12, angle: 46, baseKnockback: 50, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 10, angle: 40, baseKnockback: 40, knockbackGrowth: 90, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 40, baseKnockback: 40, knockbackGrowth: 90, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 82, baseKnockback: 33, knockbackGrowth: 104, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 11, angle: 82, baseKnockback: 33, knockbackGrowth: 104, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 5, angle: 75, baseKnockback: 28, knockbackGrowth: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 75, baseKnockback: 28, knockbackGrowth: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0, knockbackGrowth: 16, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 8, angle: 20, baseKnockback: 45, knockbackGrowth: 29, hitstop: 4, selfHitstop: 3, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 20, baseKnockback: 45, knockbackGrowth: 29, hitstop: 4, selfHitstop: 3, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 7, angle: 60, baseKnockback: 98, knockbackGrowth: 35, hitstop: 4, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 60, baseKnockback: 98, knockbackGrowth: 35, hitstop: 4, selfHitstop: 3, hitstun: -1, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 9, angle: 40, baseKnockback: 107, knockbackGrowth: 60, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 9, angle: 40, baseKnockback: 107, knockbackGrowth: 60, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: {}
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: {}
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 9, angle: 85, baseKnockback: 70, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 10, angle: 35, baseKnockback: 70, knockbackGrowth: 75, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 13, angle: 155, baseKnockback: 80, knockbackGrowth: 55, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 5, angle: 70, baseKnockback: 50, knockbackGrowth: 85, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 18, angle: 50, baseKnockback: 75, knockbackGrowth: 35, hitstop: 2, selfHitstop: 0, hitstun: -1, limb: AttackLimb.FIST },
	},
}