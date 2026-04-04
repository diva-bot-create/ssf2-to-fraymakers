// HitboxStats for Metaknight (converted from SSF2)
// Source: JPEXS-decompiled metaknight.ssf
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
		hitbox0: { damage: 0.5, angle: 35, baseKnockback: 0 /*TODO*/, knockbackGrowth: 50, hitstop: 1, selfHitstop: 0 },
		hitbox1: { damage: 0.5, angle: 35, baseKnockback: 0 /*TODO*/, knockbackGrowth: 50, hitstop: 1, selfHitstop: 0 },
		hitbox2: { damage: 0.5, angle: 35, baseKnockback: 0 /*TODO*/, knockbackGrowth: 50, hitstop: 1, selfHitstop: 0 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 2, angle: 40, baseKnockback: 8, knockbackGrowth: 22, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 85, baseKnockback: 55, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 7, angle: 85, baseKnockback: 55, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 9, angle: 75, baseKnockback: 60, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 15, angle: 50, baseKnockback: 30, knockbackGrowth: 108, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 15, angle: 50, baseKnockback: 30, knockbackGrowth: 108, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 15, angle: 50, baseKnockback: 30, knockbackGrowth: 108, hitstop: -1, selfHitstop: -1 },
		hitbox3: { damage: 15, angle: 50, baseKnockback: 30, knockbackGrowth: 108, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 3, angle: 150, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 150, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 12, angle: 35, baseKnockback: 36, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 12, angle: 35, baseKnockback: 36, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 1, angle: 50, baseKnockback: 20, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 10  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1, angle: 50, baseKnockback: 20, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 10  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 1, angle: 50, baseKnockback: 20, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 10  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 6, angle: 78, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 6, angle: 78, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 6, angle: 78, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 35, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 35, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 10, angle: 35, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox2: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox2: { damage: 0.5, angle: 105, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 1, angle: 40, baseKnockback: 47, knockbackGrowth: 14, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1, angle: 40, baseKnockback: 47, knockbackGrowth: 14, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 1, angle: 40, baseKnockback: 47, knockbackGrowth: 14, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1, angle: 40, baseKnockback: 47, knockbackGrowth: 14, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 9, angle: 82, baseKnockback: 102, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 82, baseKnockback: 102, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 6, angle: 82, baseKnockback: 102, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 82, baseKnockback: 102, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 11, angle: 70, baseKnockback: 60, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 70, baseKnockback: 60, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 11, angle: 70, baseKnockback: 60, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 70, baseKnockback: 60, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 60, baseKnockback: 60, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 0.5, angle: 20, baseKnockback: 40, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, hitstun: 1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 2, angle: 78, baseKnockback: 40, knockbackGrowth: 180, hitstop: 5, selfHitstop: 5 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 49, baseKnockback: 26.5, knockbackGrowth: 115.5, hitstop: 3, selfHitstop: 2 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 135, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 3, angle: 135, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 7, angle: 115, baseKnockback: 74, knockbackGrowth: 74, hitstop: 2, selfHitstop: 2 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}