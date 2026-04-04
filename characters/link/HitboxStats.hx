// HitboxStats for Link (converted from SSF2)
// Source: JPEXS-decompiled link.ssf
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
		hitbox0: { damage: 4, angle: 50, baseKnockback: 16, knockbackGrowth: 37, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 13, angle: 30, baseKnockback: 20, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 85, baseKnockback: 50, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 280, baseKnockback: 70, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 60, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox2: { damage: 14, angle: 80, baseKnockback: 60, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 14, angle: 45, baseKnockback: 60, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 60, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 4, angle: 115, baseKnockback: 24, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.25  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 115, baseKnockback: 24, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.25  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 17, angle: 75, baseKnockback: 40, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 14, angle: 75, baseKnockback: 40, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 40, baseKnockback: 22, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 40, baseKnockback: 22, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 8, angle: 30, baseKnockback: 5, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 4, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 15, angle: 90, baseKnockback: 28, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 19, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 1, selfHitstop: -1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 0, angle: 210, baseKnockback: 2, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 2, angle: 210, baseKnockback: 2, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 14, angle: 45, baseKnockback: 60, knockbackGrowth: 86, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 3, angle: 88, baseKnockback: 65, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 3, angle: 88, baseKnockback: 65, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: special
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 30, selfHitstop: 0, hitstun: 0  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 30, selfHitstop: 0, hitstun: 0  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 0, angle: -2, baseKnockback: 2, knockbackGrowth: 10, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 5, angle: 20, baseKnockback: 50, knockbackGrowth: 100, hitstop: 3, selfHitstop: 5, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 7, angle: 90, baseKnockback: 45, knockbackGrowth: 100, hitstop: 2, selfHitstop: 4, hitstun: -1  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 110, baseKnockback: 60, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 25, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 50, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}