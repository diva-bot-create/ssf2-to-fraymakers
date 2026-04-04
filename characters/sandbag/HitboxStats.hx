// HitboxStats for Sandbag (converted from SSF2)
// Source: JPEXS-decompiled sandbag.ssf
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
		hitbox0: { damage: 9, angle: 40, baseKnockback: 46, knockbackGrowth: 145, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 40, baseKnockback: 46, knockbackGrowth: 145, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 13, angle: 30, baseKnockback: 20, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 13, angle: 30, baseKnockback: 20, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 85, baseKnockback: 30, knockbackGrowth: 130, hitstop: -1, selfHitstop: -1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 70, baseKnockback: 90, knockbackGrowth: 50, hitstop: 5, selfHitstop: 3 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 14, angle: 70, baseKnockback: 40, knockbackGrowth: 125, hitstop: 6, selfHitstop: 3, hitstun: -1.25  // SSF2 hitLag multiplier },
		hitbox1: { damage: 14, angle: 70, baseKnockback: 40, knockbackGrowth: 125, hitstop: 6, selfHitstop: 3, hitstun: -1.25  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 8, angle: 90, baseKnockback: 60, knockbackGrowth: 50, hitstop: 5, selfHitstop: 2, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 9, angle: 270, baseKnockback: 43, knockbackGrowth: 84, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 22, knockbackGrowth: 85, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 11, angle: 30, baseKnockback: 30, knockbackGrowth: 110, hitstop: 7, selfHitstop: 3, hitstun: -1.08  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 9, angle: 66, baseKnockback: 30, knockbackGrowth: 90, hitstop: 5, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 9, angle: 90, baseKnockback: 50, knockbackGrowth: 55, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 20, angle: 291, baseKnockback: 80, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 20, angle: 285, baseKnockback: 80, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 1, selfHitstop: 1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 1, selfHitstop: 1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 7, angle: 35, baseKnockback: 60, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 7, angle: 35, baseKnockback: 60, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 12, angle: 29, baseKnockback: 68, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 2, angle: 80, baseKnockback: 75, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 28, angle: 325, baseKnockback: 80, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 28, angle: 325, baseKnockback: 80, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 11, angle: 80, baseKnockback: 90, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 90, baseKnockback: 40, knockbackGrowth: 60, hitstop: 3, selfHitstop: 1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 13, angle: 40, baseKnockback: 130, knockbackGrowth: 33, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 9, angle: 30, baseKnockback: 50, knockbackGrowth: 110, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 30, baseKnockback: 110, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

}