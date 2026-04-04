// HitboxStats for Donkeykong (converted from SSF2)
// Source: JPEXS-decompiled donkeykong.ssf
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
		hitbox0: { damage: 4, angle: 45, baseKnockback: 20, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 10, angle: 33, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 11, angle: 90, baseKnockback: 35, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 90, baseKnockback: 35, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 37, baseKnockback: 40, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 11, angle: 60, baseKnockback: 100, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 18, angle: 90, baseKnockback: 42.8, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 17, angle: 115, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.07  // SSF2 hitLag multiplier },
		hitbox1: { damage: 17, angle: 115, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.07  // SSF2 hitLag multiplier }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox2: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 140, baseKnockback: 21.4, knockbackGrowth: 89, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 140, baseKnockback: 21.4, knockbackGrowth: 89, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 80, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 80, baseKnockback: 32, knockbackGrowth: 90, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 16, angle: 270, baseKnockback: 30, knockbackGrowth: 90, hitstop: 5, selfHitstop: 2 },
		hitbox1: { damage: 16, angle: 270, baseKnockback: 30, knockbackGrowth: 90, hitstop: 5, selfHitstop: 2 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 10, angle: 45, baseKnockback: 15, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 7, angle: 45, baseKnockback: 15, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 10, angle: 271, baseKnockback: 20, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 11, angle: 271, baseKnockback: 30, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 14, angle: 45, baseKnockback: 50, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 50, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 11, angle: 80, baseKnockback: 85, knockbackGrowth: 30, hitstop: 2, selfHitstop: 0 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 25  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 9, angle: 85, baseKnockback: 55, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 7, angle: 75, baseKnockback: 60, knockbackGrowth: 80, hitstop: 3, selfHitstop: 1, hitstun: -1.07  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 48, baseKnockback: 80, knockbackGrowth: 56, hitstop: 1, selfHitstop: 0, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 11, angle: 50, baseKnockback: 54, knockbackGrowth: 95, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 50, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}