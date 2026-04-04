// HitboxStats for Zamus (converted from SSF2)
// Source: JPEXS-decompiled zamus.ssf
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
		hitbox0: { damage: 2, angle: 61, baseKnockback: 20, knockbackGrowth: 35, hitstop: 3, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 5, angle: 120, baseKnockback: 37, knockbackGrowth: 46, hitstop: 2, selfHitstop: 2 },
		hitbox1: { damage: 5, angle: 130, baseKnockback: 50, knockbackGrowth: 46, hitstop: 2, selfHitstop: 2 },
		hitbox2: { damage: 5, angle: 80, baseKnockback: 37, knockbackGrowth: 55, hitstop: 2, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 75, baseKnockback: 65, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 13, angle: 45, baseKnockback: 40, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 60, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 1, angle: 110, baseKnockback: 70, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 1, angle: 300, baseKnockback: 10, knockbackGrowth: 20, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 11, angle: 75, baseKnockback: 40, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 55, baseKnockback: 45, knockbackGrowth: 52, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 55, baseKnockback: 45, knockbackGrowth: 52, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 7, angle: 50, baseKnockback: 35, knockbackGrowth: 85, hitstop: 5, selfHitstop: 2 },
		hitbox1: { damage: 10, angle: 50, baseKnockback: 40, knockbackGrowth: 110, hitstop: 5, selfHitstop: 2 }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 45, baseKnockback: 42, knockbackGrowth: 98, hitstop: 5, selfHitstop: 4, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 42, knockbackGrowth: 98, hitstop: 5, selfHitstop: 4, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: 4, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 80, baseKnockback: 40, knockbackGrowth: 90, hitstop: 4, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 5, angle: 275, baseKnockback: 45, knockbackGrowth: 90, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, hitstop: -1, selfHitstop: -1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 30, knockbackGrowth: 16, hitstop: -1, selfHitstop: -1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 3, angle: 15, baseKnockback: 80, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 3, angle: 15, baseKnockback: 40, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 3, angle: 15, baseKnockback: 30, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 3, angle: 15, baseKnockback: 80, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 3, angle: 15, baseKnockback: 40, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 3, angle: 15, baseKnockback: 30, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 4, angle: 110, baseKnockback: 110, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 95, baseKnockback: 110, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 4, angle: 110, baseKnockback: 110, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 95, baseKnockback: 110, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10 },
		hitbox1: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10 },
		hitbox2: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10 },
		hitbox3: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10 },
		hitbox1: { damage: 12, angle: 290, baseKnockback: 60, knockbackGrowth: 85, hitstop: 10, selfHitstop: 10 },
		hitbox2: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10 },
		hitbox3: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 70, hitstop: 10, selfHitstop: 10 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 88, baseKnockback: 75.736, knockbackGrowth: 36.667, hitstop: 4, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 50, baseKnockback: 100, knockbackGrowth: 35, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 56.18, knockbackGrowth: 57.778, hitstop: 4, selfHitstop: 2 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 50, baseKnockback: 60, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}