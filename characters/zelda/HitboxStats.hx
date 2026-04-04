// HitboxStats for Zelda
// Source: ZeldaExt.as → getAttackStats()
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
		hitbox0: { damage: 2, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 2, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	dash_attack: { // SSF2: a_forward
		hitbox0: { damage: 10, angle: 75, baseKnockback: 62, knockbackGrowth: 63, hitstop: 4, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 75, baseKnockback: 62, knockbackGrowth: 63, hitstop: 4, selfHitstop: 1, hitstun: -1, limb: AttackLimb.FOOT },
	},

	//TILT ATTACKS
	tilt_forward: { // SSF2: a_forward_tilt
		hitbox0: { damage: 13, angle: 110, baseKnockback: 70, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 110, baseKnockback: 70, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_up: { // SSF2: a_up_tilt
		hitbox0: { damage: 13, angle: 75, baseKnockback: 70, knockbackGrowth: 60, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 75, baseKnockback: 70, knockbackGrowth: 60, hitstun: -1, limb: AttackLimb.FIST },
	},
	tilt_down: { // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 65, baseKnockback: 40, knockbackGrowth: 90, limb: AttackLimb.FOOT },
		hitbox1: { damage: 13, angle: 275, baseKnockback: 55, knockbackGrowth: 55, hitstop: 10, selfHitstop: 10, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: { // SSF2: a_forwardsmash
		hitbox0: { damage: 2, angle: 40, baseKnockback: 0, knockbackGrowth: 100, limb: AttackLimb.FOOT },
		hitbox1: { damage: 2, angle: 180, baseKnockback: 0, knockbackGrowth: 100, limb: AttackLimb.FOOT },
	},
	strong_up_attack: { // SSF2: a_up
		hitbox0: { damage: 1.5, angle: 130, baseKnockback: 0, knockbackGrowth: 105, baseKnockback: 25, limb: AttackLimb.FIST },
	},
	strong_down_attack: { // SSF2: a_down
		hitbox0: { damage: 14.5, angle: 24, baseKnockback: 28, knockbackGrowth: 103, limb: AttackLimb.FOOT },
		hitbox1: { damage: 14.5, angle: 24, baseKnockback: 28, knockbackGrowth: 103, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: { // SSF2: a_air
		hitbox0: { damage: 2, angle: 90, baseKnockback: 28, knockbackGrowth: 100, hitstop: 2, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 115, baseKnockback: 26, knockbackGrowth: 100, hitstop: 2, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 1, angle: 115, baseKnockback: 26, knockbackGrowth: 100, hitstop: 2, selfHitstop: 2, hitstun: -1, limb: AttackLimb.FIST },
	},
	aerial_forward: { // SSF2: a_air_forward
		hitbox0: { damage: 7, angle: 68, baseKnockback: 43, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 45, knockbackGrowth: 102, hitstop: 15, selfHitstop: 14, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 7, angle: 68, baseKnockback: 43, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox3: { damage: 7, angle: 68, baseKnockback: 43, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_back: { // SSF2: a_air_backward
		hitbox0: { damage: 6, angle: 55, baseKnockback: 32, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 40, knockbackGrowth: 85, hitstop: 15, selfHitstop: 14, hitstun: -1, limb: AttackLimb.FIST },
		hitbox2: { damage: 6, angle: 55, baseKnockback: 32, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
		hitbox3: { damage: 6, angle: 55, baseKnockback: 32, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FIST },
	},
	aerial_up: { // SSF2: a_air_up
		hitbox0: { damage: 2, angle: 270, baseKnockback: 25, knockbackGrowth: 10, hitstop: 0, selfHitstop: 0, hitstun: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: { // SSF2: a_air_down
		hitbox0: { damage: 5, angle: 275, baseKnockback: 28, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 16, angle: 270, baseKnockback: 40, knockbackGrowth: 90, hitstop: 16, selfHitstop: 12, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: { // SSF2: b
		hitbox0: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
		hitbox2: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox3: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
	},
	special_neutral_air: { // SSF2: b_air
		hitbox0: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
		hitbox1: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
		hitbox2: { hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
		hitbox3: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, limb: AttackLimb.FIST },
	},
	special_side: { // SSF2: b_forward
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 2, selfHitstop: 2, hitstun: 1, limb: AttackLimb.FIST },
	},
	special_side_air: { // SSF2: b_forward_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 2, selfHitstop: 2, hitstun: 1, limb: AttackLimb.FIST },
	},
	special_up: { // SSF2: b_up
		hitbox0: { damage: 5, angle: 91, baseKnockback: 59, reversibleAngle: false, baseKnockback: 92.5, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 32, baseKnockback: 80, knockbackGrowth: 80, hitstop: 6, selfHitstop: 4, baseKnockback: 0, limb: AttackLimb.FIST },
	},
	special_up_air: { // SSF2: b_up_air
		hitbox0: { damage: 5, angle: 80, baseKnockback: 59, reversibleAngle: false, baseKnockback: 92.5, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 32, baseKnockback: 80, knockbackGrowth: 80, hitstop: 6, selfHitstop: 4, baseKnockback: 0, limb: AttackLimb.FIST },
	},
	special_down: { // SSF2: b_down
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 25, limb: AttackLimb.FOOT },
	},
	special_down_air: { // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 25, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: { // SSF2: throw_up
		hitbox0: { damage: 9, angle: 90, baseKnockback: 55, knockbackGrowth: 68, hitstop: 0, selfHitstop: 0, hitstun: -1, limb: AttackLimb.BODY },
	},
	throw_forward: { // SSF2: throw_forward
		hitbox0: { damage: 12, angle: 30, baseKnockback: 82, knockbackGrowth: 25, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_back: { // SSF2: throw_back
		hitbox0: { damage: 11, angle: 120, baseKnockback: 45, knockbackGrowth: 125, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},
	throw_down: { // SSF2: throw_down
		hitbox0: { damage: 0.5, angle: 112, baseKnockback: 48, knockbackGrowth: 120, hitstop: 0, selfHitstop: 0, reversibleAngle: false, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: { // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 5, selfHitstop: 5, limb: AttackLimb.FOOT },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1, limb: AttackLimb.FOOT },
	},
	crash_attack: { // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	emote: { // SSF2: special
		hitbox0: { damage: 1, angle: 90, baseKnockback: 0, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, limb: AttackLimb.FIST },
	},
}