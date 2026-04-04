// HitboxStats for Rayman
// Source: RaymanExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 40, baseKnockback: 30, knockbackGrowth: 27, hitstop: 3, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 7, angle: 60, baseKnockback: 80, knockbackGrowth: 50, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 7, angle: 45, baseKnockback: 40, knockbackGrowth: 68, hitstop: 6, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 45, baseKnockback: 40, knockbackGrowth: 68, hitstop: 6, selfHitstop: 3, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 85, baseKnockback: 40, knockbackGrowth: 125, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 85, baseKnockback: 40, knockbackGrowth: 125, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 75, baseKnockback: 20, knockbackGrowth: 105, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 75, baseKnockback: 20, knockbackGrowth: 105, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 50, baseKnockback: 45, knockbackGrowth: 100, hitstop: 9, selfHitstop: 9, limb: AttackLimb.FOOT },
		hitbox1: { damage: 14, angle: 50, baseKnockback: 40, knockbackGrowth: 100, hitstop: 6, selfHitstop: 6, limb: AttackLimb.FOOT },
		hitbox2: { damage: 5, angle: 50, baseKnockback: 20, knockbackGrowth: 20, hitstop: 3, selfHitstop: 3, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 16, angle: 83, baseKnockback: 40, knockbackGrowth: 93, hitstop: 5, selfHitstop: 4, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 83, baseKnockback: 40, knockbackGrowth: 93, hitstop: 5, selfHitstop: 4, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 12, angle: 55, baseKnockback: 50, knockbackGrowth: 100, hitstop: 8, selfHitstop: 8, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 55, baseKnockback: 50, knockbackGrowth: 100, hitstop: 8, selfHitstop: 8, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 5, angle: 55, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 55, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox2: { damage: 5, angle: 55, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox3: { damage: 5, angle: 55, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox4: { damage: 5, angle: 55, baseKnockback: 50, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 8, angle: 45, baseKnockback: 15, knockbackGrowth: 120, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 15, knockbackGrowth: 120, hitstop: 3, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 5, angle: 40, baseKnockback: 50, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 5, angle: 40, baseKnockback: 50, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 7, angle: 95, baseKnockback: 55, knockbackGrowth: 95, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 95, baseKnockback: 55, knockbackGrowth: 95, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 2, angle: 55, baseKnockback: 45, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5, reversibleAngle: false, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 1, angle: 55, baseKnockback: 70, knockbackGrowth: 90, hitstop: 1, selfHitstop: 1, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 1, angle: 55, baseKnockback: 70, knockbackGrowth: 90, hitstop: 1, selfHitstop: 1, hitstun: -1, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 3, angle: 35, baseKnockback: 0, knockbackGrowth: 0, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: 0, baseKnockback: 70, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 3, angle: 35, baseKnockback: 0, knockbackGrowth: 0, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: 0, baseKnockback: 70, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 2, angle: 80, baseKnockback: 50, knockbackGrowth: 80, hitstop: 3, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: 0, baseKnockback: 50, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 0, angle: 0, baseKnockback: 25, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox3: { damage: 0, angle: 180, baseKnockback: 25, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox4: { damage: 0, angle: -2, baseKnockback: 25, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox5: { damage: 0, angle: 0, baseKnockback: 10, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox6: { damage: 0, angle: 180, baseKnockback: 10, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox7: { damage: 0, angle: -2, baseKnockback: 19, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 2, angle: 80, baseKnockback: 50, knockbackGrowth: 80, hitstop: 3, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 0, angle: 0, baseKnockback: 50, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 0, angle: 0, baseKnockback: 10, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox3: { damage: 0, angle: 180, baseKnockback: 10, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox4: { damage: 0, angle: -2, baseKnockback: 19, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 5, angle: 45, baseKnockback: 65, knockbackGrowth: 80, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 5, angle: 45, baseKnockback: 65, knockbackGrowth: 80, hitstop: 3, selfHitstop: 1, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 0.5, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 1, angle: 80, baseKnockback: 40, knockbackGrowth: 80, reversibleAngle: false, limb: AttackLimb.BODY },
		hitbox2: { damage: 3, angle: 75, baseKnockback: 75, knockbackGrowth: 105, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 58, baseKnockback: 100, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, limb: AttackLimb.BODY },
		hitbox1: { damage: 8, angle: 40, baseKnockback: 50, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 8, angle: 80, baseKnockback: 45, knockbackGrowth: 100, hitstop: 0, selfHitstop: 1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 25, baseKnockback: 0, knockbackGrowth: 110, hitstop: 3, selfHitstop: 1, baseKnockback: 100, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { limb: AttackLimb.FIST },
		hitbox1: { limb: AttackLimb.FIST },
		hitbox2: { limb: AttackLimb.FIST },
	},
}