// Hitbox stats for fox — converted from SSF2
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
		hitbox0: { damage: 2, angle: 70, baseKnockback: 40, knockbackGrowth: 50, hitstop: 1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 2, angle: 70, baseKnockback: 40, knockbackGrowth: 50, hitstop: 1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox2: { damage: 1, angle: 45, baseKnockback: 50, knockbackGrowth: 50, hitstop: 5, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	jab2: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	jab3: {
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST }
	},
	dash_attack: {
		hitbox0: { damage: 8, angle: 75, baseKnockback: 57, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 75, baseKnockback: 57, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	tilt_forward: {
		hitbox0: { damage: 5, angle: 40, baseKnockback: 10, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 7, angle: 40, baseKnockback: 10, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	tilt_up: {
		hitbox0: { damage: 9, angle: 80, baseKnockback: 18, knockbackGrowth: 140, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
		hitbox1: { damage: 9, angle: 80, baseKnockback: 18, knockbackGrowth: 140, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FIST },
	},
	tilt_down: {
		hitbox0: { damage: 9, angle: 75, baseKnockback: 45, knockbackGrowth: 113, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},

	//STRONG ATTACKS
	strong_forward_attack: {
		hitbox0: { damage: 15, angle: 40, baseKnockback: 20, knockbackGrowth: 98, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 15, angle: 40, baseKnockback: 20, knockbackGrowth: 98, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_up_attack: {
		hitbox0: { damage: 16, angle: 80, baseKnockback: 45, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
		hitbox1: { damage: 16, angle: 80, baseKnockback: 45, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	strong_down_attack: {
		hitbox0: { damage: 12, angle: 40, baseKnockback: 30, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 40, baseKnockback: 30, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox2: { damage: 14, angle: 25, baseKnockback: 30, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox3: { damage: 14, angle: 25, baseKnockback: 30, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//AERIAL ATTACKS
	aerial_neutral: {
		hitbox0: { damage: 12, angle: 47, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 12, angle: 47, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_forward: {
		hitbox0: { damage: 6, angle: 45, baseKnockback: 15, knockbackGrowth: 50, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_back: {
		hitbox0: { damage: 15, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: 4, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	aerial_up: {
		hitbox0: { damage: 5, angle: 92, baseKnockback: 0, knockbackGrowth: 120, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
		hitbox1: { damage: 5, angle: 92, baseKnockback: 0, knockbackGrowth: 120, hitstop: -1, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	aerial_down: {
		hitbox0: { damage: 3, angle: 291, baseKnockback: 0, knockbackGrowth: 100, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
		hitbox1: { damage: 3, angle: 291, baseKnockback: 0, knockbackGrowth: 100, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},

	//SPECIAL ATTACKS
	special_neutral: {
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_neutral_air: {
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0, knockbackGrowth: 16, hitstop: 3, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	special_side: {
		hitbox0: { damage: 7, angle: 75, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_side_air: {
		hitbox0: { damage: 7, angle: 125, baseKnockback: 60, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_up: {
		hitbox0: { damage: 1, angle: 90, baseKnockback: 28, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_up_air: {
		hitbox0: { damage: 1, angle: 90, baseKnockback: 28, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FIST },
	},
	special_down: {
		hitbox0: { damage: 6, angle: 0, baseKnockback: 65, knockbackGrowth: 0, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
	},
	special_down_air: {
		hitbox0: { damage: 6, angle: 0, baseKnockback: 65, knockbackGrowth: 0, hitstop: 2, selfHitstop: -1, limb: AttackLimb.FOOT },
	},

	//THROWS
	throw_up: {
		hitbox0: { damage: 3, angle: 90, baseKnockback: 75, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_down: {
		hitbox0: { damage: 5, angle: 270, baseKnockback: 80, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, limb: AttackLimb.BODY },
	},
	throw_forward: {
		hitbox0: { damage: 8, angle: 45, baseKnockback: 54, knockbackGrowth: 78, hitstop: 1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},
	throw_back: {
		hitbox0: { damage: 7, angle: 45, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.BODY },
	},

	//MISC ATTACKS
	ledge_attack: {
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	crash_attack: {
		hitbox0: { damage: 5, angle: 45, baseKnockback: 70, knockbackGrowth: 25, hitstop: -1, selfHitstop: -1, hitstun: 0, limb: AttackLimb.FOOT },
	},
	emote: {
		hitbox0: {}
	},
}
