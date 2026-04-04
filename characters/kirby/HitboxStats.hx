// HitboxStats for Kirby (converted from SSF2)
// Source: JPEXS-decompiled kirby.ssf
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
		hitbox0: { damage: 2, angle: 30, baseKnockback: 8, knockbackGrowth: 30, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 9, angle: 45, baseKnockback: 12, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 85, baseKnockback: 50, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 7, angle: 85, baseKnockback: 50, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 35, baseKnockback: 30, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 1.5, angle: 20, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1.5, angle: 20, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 1.5, angle: 20, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox3: { damage: 1.5, angle: 20, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 15, angle: 90, baseKnockback: 34, knockbackGrowth: 98, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 14, angle: 75, baseKnockback: 25, knockbackGrowth: 120, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 25, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 14, angle: 45, baseKnockback: 25, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 12, angle: 47, baseKnockback: 30, knockbackGrowth: 80, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 47, baseKnockback: 30, knockbackGrowth: 80, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 4, angle: 45, baseKnockback: 35, knockbackGrowth: 50, hitstop: 3, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 13, angle: 45, baseKnockback: 20, knockbackGrowth: 104, hitstop: 4, selfHitstop: 2 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 11, angle: 75, baseKnockback: 47, knockbackGrowth: 61, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 75, baseKnockback: 47, knockbackGrowth: 61, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 1.4, angle: 278, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 1.4, angle: 278, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 150, baseKnockback: 60, knockbackGrowth: 9, hitstop: 4, selfHitstop: 0 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 150, baseKnockback: 60, knockbackGrowth: 9, hitstop: 0, selfHitstop: 0 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 23, angle: 55, baseKnockback: 65, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 23, angle: 55, baseKnockback: 65, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 17, angle: 55, baseKnockback: 65, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 17, angle: 55, baseKnockback: 65, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 5, angle: 85, baseKnockback: 117, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 18, angle: 70, baseKnockback: 40, knockbackGrowth: 80, hitstop: 4, selfHitstop: 4 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 18, angle: 70, baseKnockback: 70, knockbackGrowth: 70, hitstop: 4, selfHitstop: 4 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 85, baseKnockback: 60, knockbackGrowth: 88, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 1, angle: 20, baseKnockback: 40, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 9, angle: 63, baseKnockback: 40, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 8, angle: 130, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}