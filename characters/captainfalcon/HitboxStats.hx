// HitboxStats for Captainfalcon (converted from SSF2)
// Source: JPEXS-decompiled captainfalcon.ssf
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
		hitbox0: { damage: 2, angle: 60, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 2, angle: 60, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 12, angle: 45, baseKnockback: 10, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 13, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 13, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 10, angle: 270, baseKnockback: 30, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 12, angle: 80, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 70, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 12, angle: 60, baseKnockback: 25, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 10, angle: 60, baseKnockback: 62, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 14, angle: 90, baseKnockback: 20, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 90, baseKnockback: 80, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 8, angle: 125, baseKnockback: 80, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 18, angle: 38, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 5, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1.3  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 50, baseKnockback: 50, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 18, angle: 40, baseKnockback: 35, knockbackGrowth: 93, hitstop: 7, selfHitstop: 4 },
		hitbox1: { damage: 18, angle: 40, baseKnockback: 35, knockbackGrowth: 93, hitstop: 7, selfHitstop: 4 }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 14, angle: 47, baseKnockback: 20, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 47, baseKnockback: 0 /*TODO*/, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 12, angle: 270, baseKnockback: 40, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2 },
		hitbox1: { damage: 16, angle: 291, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 25, angle: 40, baseKnockback: 45, knockbackGrowth: 100, hitstop: 10, selfHitstop: 8 },
		hitbox1: { damage: 25, angle: 40, baseKnockback: 45, knockbackGrowth: 100, hitstop: 10, selfHitstop: 8 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 23, angle: 40, baseKnockback: 35, knockbackGrowth: 100, hitstop: 9, selfHitstop: 7 },
		hitbox1: { damage: 23, angle: 40, baseKnockback: 35, knockbackGrowth: 100, hitstop: 9, selfHitstop: 7 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 9, angle: 90, baseKnockback: 70, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 9, angle: 270, baseKnockback: 40, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 14, angle: 45, baseKnockback: 78, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 78, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 15, angle: 60, baseKnockback: 40, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 15, angle: 60, baseKnockback: 40, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 7, angle: 80, baseKnockback: 75, knockbackGrowth: 60, hitstop: 0, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 7, angle: 65, baseKnockback: 75, knockbackGrowth: 35, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 30, baseKnockback: 40, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 160, baseKnockback: 35, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}