// HitboxStats for Tails (converted from SSF2)
// Source: JPEXS-decompiled tails.ssf
//
// SSF2 → Fraymakers stat mapping:
//   damage      → damage        (percent dealt)
//   power       → baseKnockback (base force, weight-independent)
//   weightKB    → baseKnockback (alt: weight-based base KB)
//   kbConstant  → knockbackGrowth (scales with damage%)
//   direction   → angle
//   hitStun     → hitstop       (frames target is frozen)
//   selfHitStun → selfHitstop
//   hitLag      → hitstun       (frames unable to act after knockback)
{

	//LIGHT ATTACKS  
	jab1: {  // SSF2: a
		hitbox0: { damage: 2, angle: 55, baseKnockback: 0 /*TODO*/, knockbackGrowth: 75, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 2, angle: 55, baseKnockback: 0 /*TODO*/, knockbackGrowth: 75, hitstop: 3, selfHitstop: 1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 45, baseKnockback: 30, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 1.25, angle: 90, baseKnockback: 38, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 25, baseKnockback: 25, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 7, angle: 25, baseKnockback: 25, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 8, angle: 45, baseKnockback: 45, knockbackGrowth: 90, hitstop: 2, selfHitstop: 3 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 16, angle: 90, baseKnockback: 36, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 16, angle: 90, baseKnockback: 36, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 11, angle: 35, baseKnockback: 45, knockbackGrowth: 62, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 1.2, angle: 90, baseKnockback: 30, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 9  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1.2, angle: 90, baseKnockback: 30, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 9  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 9, angle: 45, baseKnockback: 27, knockbackGrowth: 117, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 27, knockbackGrowth: 117, hitstop: 2, selfHitstop: 1 }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 6, angle: 35, baseKnockback: 34, knockbackGrowth: 152, hitstop: 4, selfHitstop: 1 },
		hitbox1: { damage: 6, angle: 35, baseKnockback: 34, knockbackGrowth: 152, hitstop: 4, selfHitstop: 1 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 9, angle: 60, baseKnockback: 35, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 60, baseKnockback: 35, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 286, baseKnockback: 15, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 286, baseKnockback: 15, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 10, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 10, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 12, angle: 33, baseKnockback: 70, knockbackGrowth: 62, hitstop: 1, selfHitstop: 0 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 12, angle: 33, baseKnockback: 70, knockbackGrowth: 62, hitstop: 1, selfHitstop: 0 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 0.5, angle: 90, baseKnockback: 35, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -0.8  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 0.5, angle: 90, baseKnockback: 35, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -0.8  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 8, angle: 65, baseKnockback: 60, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 8, angle: 65, baseKnockback: 60, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 80, baseKnockback: 60, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: -0.8  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 8, angle: 270, baseKnockback: 40, knockbackGrowth: 0, hitstop: 4, selfHitstop: 3 },
		hitbox1: { damage: 8, angle: 270, baseKnockback: 40, knockbackGrowth: 0, hitstop: 4, selfHitstop: 3 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 9, angle: 35, baseKnockback: 75, knockbackGrowth: 69, hitstop: 0, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 12, angle: 130, baseKnockback: 70, knockbackGrowth: 45, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 25, baseKnockback: 100, knockbackGrowth: 110, hitstop: 3, selfHitstop: 1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}