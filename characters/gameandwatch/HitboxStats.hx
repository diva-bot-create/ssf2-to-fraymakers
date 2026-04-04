// HitboxStats for Gameandwatch (converted from SSF2)
// Source: JPEXS-decompiled gameandwatch.ssf
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
		hitbox0: { damage: 3, angle: 83, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 10, angle: 30, baseKnockback: 50, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 35, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 95, baseKnockback: 40, knockbackGrowth: 105, hitstop: 4, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 7, angle: 95, baseKnockback: 40, knockbackGrowth: 105, hitstop: 4, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 10, angle: 75, baseKnockback: 58, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0, angle: 90, baseKnockback: 110, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 14, angle: 48, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 18, angle: 48, baseKnockback: 48, knockbackGrowth: 91, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 16, angle: 83, baseKnockback: 40, knockbackGrowth: 93, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 16, angle: 83, baseKnockback: 40, knockbackGrowth: 93, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 13, angle: 20, baseKnockback: 30, knockbackGrowth: 65, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 15, angle: 75, baseKnockback: 60, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 15, angle: 75, baseKnockback: 60, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 3, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox2: { damage: 3, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 10, angle: 40, baseKnockback: 55, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 2, angle: 25, baseKnockback: 20, knockbackGrowth: 40, hitstop: 5, selfHitstop: 3, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 7, angle: 94, baseKnockback: 55, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0, angle: 90, baseKnockback: 60, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0 },
		hitbox2: { damage: 0, angle: 90, baseKnockback: 40, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0 }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 11, angle: 270, baseKnockback: 50, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 5, angle: 10, baseKnockback: 60, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 5, angle: 10, baseKnockback: 60, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 3, angle: 35, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 3, angle: 35, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 6, angle: 80, baseKnockback: 135, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 6, angle: 80, baseKnockback: 135, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: special
		hitbox0: { damage: 16, angle: 45, baseKnockback: 50, knockbackGrowth: 80, hitstop: -1, selfHitstop: 1 },
		hitbox1: { damage: 16, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: 1 },
		hitbox2: { damage: 16, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: 1 },
		hitbox3: { damage: 16, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: 1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 5, angle: 45, baseKnockback: 65, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 8, angle: 85, baseKnockback: 90, knockbackGrowth: 35, hitstop: 0, selfHitstop: 0 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 8, angle: 270, baseKnockback: 35, knockbackGrowth: 115, hitstop: 0, selfHitstop: 0, hitstun: -0.15  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 58, baseKnockback: 80, knockbackGrowth: 30, hitstop: 0, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 8, angle: 122, baseKnockback: 110, knockbackGrowth: 45, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}