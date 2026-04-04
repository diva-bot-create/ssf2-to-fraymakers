// HitboxStats for Pit (converted from SSF2)
// Source: JPEXS-decompiled pit.ssf
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
		hitbox0: { damage: 2, angle: 100, baseKnockback: 40, knockbackGrowth: 15, hitstop: -1, selfHitstop: -1, hitstun: -0.7  // SSF2 hitLag multiplier },
		hitbox1: { damage: 2, angle: 100, baseKnockback: 40, knockbackGrowth: 15, hitstop: -1, selfHitstop: -1, hitstun: -0.7  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 7, angle: 100, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 95, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 4, angle: 100, baseKnockback: 60, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 100, baseKnockback: 40, knockbackGrowth: 100, hitstop: 1, selfHitstop: 1, hitstun: -1.35  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 83, baseKnockback: 70, knockbackGrowth: 46, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 83, baseKnockback: 70, knockbackGrowth: 46, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 11, angle: 60, baseKnockback: 80, knockbackGrowth: 74, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 60, baseKnockback: 90, knockbackGrowth: 74, hitstop: -1, selfHitstop: -1, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 3, angle: 90, baseKnockback: 15, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1.25  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 90, baseKnockback: 15, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1.25  // SSF2 hitLag multiplier },
		hitbox2: { damage: 3, angle: 90, baseKnockback: 15, knockbackGrowth: 100, hitstop: 5, selfHitstop: 1, hitstun: -1.25  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 12, angle: 40, baseKnockback: 40, knockbackGrowth: 98, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 40, baseKnockback: 35, knockbackGrowth: 93, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 1, angle: 75, baseKnockback: 50, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1, angle: 75, baseKnockback: 50, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 2.5, angle: 45, baseKnockback: 45, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 43, baseKnockback: 45, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 66, baseKnockback: 30, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 1.5, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 55, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 270, baseKnockback: 10, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 10, angle: 55, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 11, angle: 90, baseKnockback: 100, knockbackGrowth: 77, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 9, angle: 90, baseKnockback: 90, knockbackGrowth: 77, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 5, angle: 45, baseKnockback: 90, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 5, angle: 45, baseKnockback: 90, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 },
		hitbox1: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 },
		hitbox1: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 88, baseKnockback: 63.018, knockbackGrowth: 69.231, hitstop: -1, selfHitstop: -1 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 2, angle: 73, baseKnockback: 70, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 65, baseKnockback: 85.508, knockbackGrowth: 42.5, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 8, angle: 60, baseKnockback: 53, knockbackGrowth: 76, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 60, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 60, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}