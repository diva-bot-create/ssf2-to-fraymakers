// Hitbox stats for jigglypuff — converted from SSF2
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
		hitbox0: { damage: 3, angle: 70, baseKnockback: 38, knockbackGrowth: 20, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	jab2: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	jab3: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	dash_attack: {
		hitbox0: { damage: 12, angle: 59, baseKnockback: 58, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	tilt_forward: {
		hitbox0: { damage: 10, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	tilt_up: {
		hitbox0: { damage: 7, angle: 90, baseKnockback: 45, knockbackGrowth: 120, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	tilt_down: {
		hitbox0: { damage: 10, angle: 22, baseKnockback: 40, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: {
		hitbox0: { damage: 16, angle: 40, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_up_attack: {
		hitbox0: { damage: 15, angle: 90, baseKnockback: 20, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 15, angle: 90, baseKnockback: 20, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_down_attack: {
		hitbox0: { damage: 12, angle: 15, baseKnockback: 25, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: {
		hitbox0: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_forward: {
		hitbox0: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_back: {
		hitbox0: { damage: 12, angle: 45, baseKnockback: 15, knockbackGrowth: 120, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_up: {
		hitbox0: { damage: 11, angle: 75, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: {
		hitbox0: { damage: 2, angle: 64, baseKnockback: 50, knockbackGrowth: 20, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: {
		hitbox0: { damage: 8, angle: 75, baseKnockback: 30, knockbackGrowth: 102, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_neutral_air: {
		hitbox0: { damage: 8, angle: 75, baseKnockback: 30, knockbackGrowth: 102, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_side: {
		hitbox0: { damage: 9, angle: 100, baseKnockback: 55, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	special_side_air: {
		hitbox0: { damage: 9, angle: 100, baseKnockback: 52, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	special_up: {
		hitbox0: { damage: 0, angle: 85, baseKnockback: 0, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_up_air: {
		hitbox0: { damage: 0, angle: 85, baseKnockback: 0, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_down: {
		hitbox0: { damage: 18, angle: 45, baseKnockback: 110, knockbackGrowth: 115, hitstop: 15, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_down_air: {
		hitbox0: { damage: 18, angle: 45, baseKnockback: 110, knockbackGrowth: 115, hitstop: 15, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: {
		hitbox0: { damage: 8, angle: 95, baseKnockback: 105, knockbackGrowth: 35, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_down: {
		hitbox0: { damage: 4, angle: 75, baseKnockback: 60, knockbackGrowth: 100, hitstop: 1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_forward: {
		hitbox0: { damage: 12, angle: 45, baseKnockback: 40, knockbackGrowth: 105, hitstop: 3, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},
	throw_back: {
		hitbox0: { damage: 10, angle: 135, baseKnockback: 90, knockbackGrowth: 40, hitstop: 3, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: {
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	crash_attack: {
		hitbox0: { damage: 9, angle: 40, baseKnockback: 100, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	emote: {
		hitbox0: {}
	},

	//SSF2-SPECIFIC (no direct Fraymakers equivalent — map or remove)
	// SSF2: special: {
		hitbox0: { damage: 0, angle: 25, baseKnockback: 210, knockbackGrowth: 20, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
}
