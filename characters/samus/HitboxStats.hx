// HitboxStats for Samus
// Source: SamusExt.as → getAttackStats()
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
		hitbox0: { damage: 3, angle: 0, baseKnockback: 15, knockbackGrowth: 25, hitstop: -1, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 0, baseKnockback: 15, knockbackGrowth: 25, hitstop: -1, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 13, angle: 60, baseKnockback: 31, knockbackGrowth: 95, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 80, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 80, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 13, angle: 270, baseKnockback: 65, knockbackGrowth: 85, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 270, baseKnockback: 65, knockbackGrowth: 85, limb: AttackLimb.FIST },
		hitbox2: { damage: 13, angle: 270, baseKnockback: 65, knockbackGrowth: 85, limb: AttackLimb.FIST },
		hitbox3: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 100, limb: AttackLimb.FIST },
		hitbox4: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 100, limb: AttackLimb.FIST },
		hitbox5: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 100, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 14, angle: 100, baseKnockback: 50, knockbackGrowth: 90, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 14, angle: 100, baseKnockback: 50, knockbackGrowth: 90, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 3, angle: 50, baseKnockback: 0, knockbackGrowth: 90, baseKnockback: 18, limb: AttackLimb.FOOT },
		hitbox1: { damage: 3, angle: 50, baseKnockback: 0, knockbackGrowth: 90, baseKnockback: 18, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 4, angle: 130, baseKnockback: 50, knockbackGrowth: 20, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 4, angle: 130, baseKnockback: 50, knockbackGrowth: 20, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 15, angle: 120, baseKnockback: 90, knockbackGrowth: 65, limb: AttackLimb.FOOT },
		hitbox1: { damage: 15, angle: 120, baseKnockback: 90, knockbackGrowth: 65, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 3, angle: 0, baseKnockback: 0, knockbackGrowth: 0, hitstop: 2, selfHitstop: 2, hitstun: 8, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox1: { damage: 3, angle: 0, baseKnockback: 0, knockbackGrowth: 0, hitstop: 2, selfHitstop: 2, hitstun: 8, reversibleAngle: false, limb: AttackLimb.FIST },
		hitbox2: { damage: 3, angle: 0, baseKnockback: 0, knockbackGrowth: 0, hitstop: 2, selfHitstop: 2, hitstun: 8, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 98, hitstop: 3, selfHitstop: 2, limb: AttackLimb.FIST },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 42, knockbackGrowth: 98, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 30, limb: AttackLimb.FOOT },
		hitbox1: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 30, limb: AttackLimb.FOOT },
		hitbox2: { damage: 3, angle: 90, baseKnockback: 0, knockbackGrowth: 100, baseKnockback: 30, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 15, angle: 270, baseKnockback: 45, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox1: { damage: 15, angle: 270, baseKnockback: 45, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox2: { damage: 15, angle: 270, baseKnockback: 45, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
		hitbox3: { damage: 15, angle: 270, baseKnockback: 45, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 2, selfHitstop: 2, reversibleAngle: false, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 1, angle: 90, baseKnockback: 125, knockbackGrowth: 10, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 90, baseKnockback: 30, knockbackGrowth: 10, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 0, angle: 80, baseKnockback: 20, knockbackGrowth: 16, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 80, baseKnockback: 20, knockbackGrowth: 16, hitstop: 1, selfHitstop: 1, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 1, angle: 80, baseKnockback: 45, knockbackGrowth: 70, hitstop: 2, selfHitstop: 0, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 9, angle: 42, baseKnockback: 60, knockbackGrowth: 50, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 12, angle: 130, baseKnockback: 55, knockbackGrowth: 60, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 10, angle: 85, baseKnockback: 80, knockbackGrowth: 30, hitstun: -1, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, limb: AttackLimb.FOOT },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
}