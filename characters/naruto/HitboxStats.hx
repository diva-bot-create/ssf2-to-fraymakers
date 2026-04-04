// HitboxStats for Naruto (converted from SSF2)
// Source: JPEXS-decompiled naruto.ssf
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
		hitbox0: { damage: 4, angle: 55, baseKnockback: 15, knockbackGrowth: 100, hitstop: 2, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 55, baseKnockback: 15, knockbackGrowth: 100, hitstop: 2, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 40, baseKnockback: 14, knockbackGrowth: 140, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 40, baseKnockback: 14, knockbackGrowth: 140, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 8, angle: 90, baseKnockback: 47, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 90, baseKnockback: 47, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 280, baseKnockback: 17.25, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 280, baseKnockback: 17.25, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 17, angle: 50, baseKnockback: 45, knockbackGrowth: 101, hitstop: 4, selfHitstop: 2 },
		hitbox1: { damage: 17, angle: 50, baseKnockback: 45, knockbackGrowth: 101, hitstop: 4, selfHitstop: 2 },
		hitbox2: { damage: 17, angle: 50, baseKnockback: 45, knockbackGrowth: 101, hitstop: 4, selfHitstop: 2 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 14, angle: 90, baseKnockback: 30, knockbackGrowth: 118, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 14, angle: 35, baseKnockback: 40, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 10, angle: 55, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 55, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 10, angle: 55, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 14, angle: 290, baseKnockback: 12.8, knockbackGrowth: 80, hitstop: 5, selfHitstop: 2 },
		hitbox1: { damage: 14, angle: 290, baseKnockback: 12.8, knockbackGrowth: 80, hitstop: 5, selfHitstop: 2 }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 50, baseKnockback: 38, knockbackGrowth: 105, hitstop: 4, selfHitstop: 1 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 90, baseKnockback: 25, knockbackGrowth: 107, hitstop: 5, selfHitstop: 2, hitstun: -1.07  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 9, angle: 60, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 9, angle: 60, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 2, angle: 30, baseKnockback: 30, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: 0.93  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 2, angle: 30, baseKnockback: 30, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: 0.93  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 8, angle: 0, baseKnockback: 20, knockbackGrowth: 1, hitstop: 1, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 8, angle: 0, baseKnockback: 20, knockbackGrowth: 1, hitstop: 1, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 12, angle: 75, baseKnockback: 120, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 75, baseKnockback: 120, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 12, angle: 75, baseKnockback: 120, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 75, baseKnockback: 120, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: special
		hitbox0: { damage: 5, angle: 55, baseKnockback: 79, knockbackGrowth: 25, hitstop: 2, selfHitstop: 0 },
		hitbox1: { damage: 2, angle: 55, baseKnockback: 79, knockbackGrowth: 25, hitstop: 2, selfHitstop: 0 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 1, angle: 90, baseKnockback: 20, knockbackGrowth: 15, hitstop: 1, selfHitstop: 0, hitstun: 15  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 50, baseKnockback: 30, knockbackGrowth: 108, hitstop: -1, selfHitstop: -1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 0, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 20, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 40, baseKnockback: 60, knockbackGrowth: 50, hitstop: 2, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 40, baseKnockback: 43, knockbackGrowth: 101, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 10, angle: 31, baseKnockback: 69, knockbackGrowth: 25, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 31, baseKnockback: 69, knockbackGrowth: 25, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}