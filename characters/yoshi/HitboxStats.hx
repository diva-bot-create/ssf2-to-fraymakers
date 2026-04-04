// HitboxStats for Yoshi (converted from SSF2)
// Source: JPEXS-decompiled yoshi.ssf
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
		hitbox0: { damage: 3, angle: 80, baseKnockback: 8, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 9, angle: 65, baseKnockback: 35, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 10, angle: 80, baseKnockback: 72, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 72, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 35, baseKnockback: 65, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 9, angle: 60, baseKnockback: 70, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 16, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 12, angle: 30, baseKnockback: 50, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 12, angle: 120, baseKnockback: 50, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 14, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 15, angle: 280, baseKnockback: 30, knockbackGrowth: 85, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 15, angle: 280, baseKnockback: 30, knockbackGrowth: 85, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 4, angle: 145, baseKnockback: 10, knockbackGrowth: 100, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 145, baseKnockback: 10, knockbackGrowth: 100, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 90, baseKnockback: 30, knockbackGrowth: 95, hitstop: 4, selfHitstop: 2, hitstun: -1.08  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 2, angle: 270, baseKnockback: 15, knockbackGrowth: 40, hitstop: 2, selfHitstop: 2, hitstun: -1.25  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 10, angle: 45, baseKnockback: 50, knockbackGrowth: 10, hitstop: -1, selfHitstop: -1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 10, angle: 45, baseKnockback: 50, knockbackGrowth: 10, hitstop: -1, selfHitstop: -1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 10, angle: 75, baseKnockback: 70, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 10, angle: 75, baseKnockback: 50, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 6, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 6, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 4, angle: 80, baseKnockback: 70, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 80, baseKnockback: 70, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 9, angle: 80, baseKnockback: 65, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 80, baseKnockback: 65, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 5, angle: 90, baseKnockback: 65, knockbackGrowth: 95, hitstop: 0, selfHitstop: 0 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 6, angle: 80, baseKnockback: 75, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 7, angle: 45, baseKnockback: 55, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 7, angle: 135, baseKnockback: 55, knockbackGrowth: 70, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 50, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}