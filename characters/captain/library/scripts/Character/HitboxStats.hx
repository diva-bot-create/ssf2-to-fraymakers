// Hitbox stats for captain — converted from SSF2
// SSF2 field mapping:
//   damage → damage
//   direction → angle
//   power/weightKB → baseKnockback
//   kbConstant → knockbackGrowth
//   hitStun → hitstop  (frames of freeze on hit)
//   selfHitStun → selfHitstop
//   hitLag → hitstun   (frames victim can't act)
// limb values inferred from move type — review before use.
{

	//LIGHT ATTACKS
	jab1: {
		hitbox0: { damage: 2, angle: 60, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 2, angle: 60, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	jab2: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	jab3: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	dash_attack: {
		hitbox0: { damage: 10, angle: 60, baseKnockback: 62, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	tilt_forward: {
		hitbox0: { damage: 12, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	tilt_up: {
		hitbox0: { damage: 13, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 13, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 10, angle: 270, baseKnockback: 30, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	tilt_down: {
		hitbox0: { damage: 12, angle: 80, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 70, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox2: { damage: 12, angle: 60, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: {
		hitbox0: { damage: 19, angle: 43, baseKnockback: 25, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_up_attack: {
		hitbox0: { damage: 14, angle: 90, baseKnockback: 20, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 8, angle: 90, baseKnockback: 80, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 8, angle: 125, baseKnockback: 80, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_down_attack: {
		hitbox0: { damage: 18, angle: 38, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: {
		hitbox0: { damage: 5, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 4, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_forward: {
		hitbox0: { damage: 18, angle: 40, baseKnockback: 35, knockbackGrowth: 93, hitstop: 7, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 18, angle: 40, baseKnockback: 35, knockbackGrowth: 93, hitstop: 7, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	aerial_back: {
		hitbox0: { damage: 14, angle: 47, baseKnockback: 20, knockbackGrowth: 100, hitstop: 5, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 47, baseKnockback: 0, knockbackGrowth: 100, hitstop: 3, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_up: {
		hitbox0: { damage: 11, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 3, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 3, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: {
		hitbox0: { damage: 12, angle: 270, baseKnockback: 40, knockbackGrowth: 100, hitstop: 4, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 16, angle: 291, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: {
		hitbox0: { damage: 25, angle: 40, baseKnockback: 45, knockbackGrowth: 100, hitstop: 10, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 25, angle: 40, baseKnockback: 45, knockbackGrowth: 100, hitstop: 10, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_neutral_air: {
		hitbox0: { damage: 23, angle: 40, baseKnockback: 35, knockbackGrowth: 100, hitstop: 9, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 23, angle: 40, baseKnockback: 35, knockbackGrowth: 100, hitstop: 9, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_side: {
		hitbox0: { damage: 9, angle: 90, baseKnockback: 70, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	special_side_air: {
		hitbox0: { damage: 9, angle: 270, baseKnockback: 40, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	special_up: {
		hitbox0: { damage: 14, angle: 45, baseKnockback: 78, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_up_air: {
		hitbox0: { damage: 14, angle: 45, baseKnockback: 78, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_down: {
		hitbox0: { damage: 15, angle: 60, baseKnockback: 40, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: {
		hitbox0: { damage: 15, angle: 60, baseKnockback: 40, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: {
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
		hitbox1: { damage: 7, angle: 80, baseKnockback: 75, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_down: {
		hitbox0: { damage: 7, angle: 65, baseKnockback: 75, knockbackGrowth: 35, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_forward: {
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
		hitbox1: { damage: 4, angle: 30, baseKnockback: 40, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},
	throw_back: {
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
		hitbox1: { damage: 5, angle: 160, baseKnockback: 35, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: {
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	crash_attack: {
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	emote: {
		hitbox0: {}
	},

	//SSF2-SPECIFIC (no direct Fraymakers equivalent — map or remove)
	// SSF2: special: {
		hitbox0: { damage: 30, angle: 45, baseKnockback: 55, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
}
