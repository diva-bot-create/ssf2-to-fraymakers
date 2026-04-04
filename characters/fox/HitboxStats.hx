// HitboxStats for Fox
// Source: FoxExt.as → getAttackStats()
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
		hitbox0: { damage: 2, angle: 70, baseKnockback: 40, knockbackGrowth: 50, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 2, angle: 70, baseKnockback: 40, knockbackGrowth: 50, hitstop: 1, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox2: { damage: 1, angle: 45, baseKnockback: 50, knockbackGrowth: 50, hitstop: 5, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 8, angle: 75, baseKnockback: 57, knockbackGrowth: 90, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 75, baseKnockback: 57, knockbackGrowth: 90, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 5, angle: 40, baseKnockback: 10, knockbackGrowth: 110, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 40, baseKnockback: 10, knockbackGrowth: 110, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 80, baseKnockback: 18, knockbackGrowth: 140, limb: AttackLimb.FIST },
		hitbox1: { damage: 9, angle: 80, baseKnockback: 18, knockbackGrowth: 140, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 9, angle: 75, baseKnockback: 45, knockbackGrowth: 113, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 15, angle: 40, baseKnockback: 20, knockbackGrowth: 98, limb: AttackLimb.FOOT },
		hitbox1: { damage: 15, angle: 40, baseKnockback: 20, knockbackGrowth: 98, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 16, angle: 80, baseKnockback: 45, knockbackGrowth: 100, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 80, baseKnockback: 45, knockbackGrowth: 100, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 40, baseKnockback: 30, knockbackGrowth: 75, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 40, baseKnockback: 30, knockbackGrowth: 75, limb: AttackLimb.FOOT },
		hitbox2: { damage: 14, angle: 25, baseKnockback: 30, knockbackGrowth: 75, limb: AttackLimb.FOOT },
		hitbox3: { damage: 14, angle: 25, baseKnockback: 30, knockbackGrowth: 75, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 12, angle: 47, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 12, angle: 47, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 6, angle: 45, baseKnockback: 15, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 14, angle: 45, baseKnockback: 20, knockbackGrowth: 85, hitstop: 5, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 20, knockbackGrowth: 85, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 5, angle: 92, baseKnockback: 0, knockbackGrowth: 120, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 92, baseKnockback: 0, knockbackGrowth: 120, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 3, angle: 300, baseKnockback: 33, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 3, angle: 300, baseKnockback: 33, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 7, angle: 75, baseKnockback: 60, knockbackGrowth: 75, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 7, angle: 125, baseKnockback: 60, knockbackGrowth: 80, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 1, angle: 90, baseKnockback: 28, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 90, baseKnockback: 28, knockbackGrowth: 30, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 6, angle: 0, baseKnockback: 55, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 6, angle: 0, baseKnockback: 55, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 3, angle: 90, baseKnockback: 75, knockbackGrowth: 110, hitstop: 0, selfHitstop: 0, hitstun: -1, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 54, knockbackGrowth: 78, hitstop: 1, selfHitstop: 2, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 7, angle: 45, baseKnockback: 50, knockbackGrowth: 80, hitstop: 0, selfHitstop: 0, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 5, angle: 270, baseKnockback: 80, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 5, angle: 45, baseKnockback: 70, knockbackGrowth: 25, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: {}
	},
}