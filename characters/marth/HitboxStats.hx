// HitboxStats for Marth (converted from SSF2)
// Source: JPEXS-decompiled marth.ssf
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
		hitbox0: { damage: 4, angle: 45, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 4, angle: 45, baseKnockback: 20, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1 },
		hitbox2: { damage: 6, angle: 45, baseKnockback: 20, knockbackGrowth: 40, hitstop: 3, selfHitstop: 2 },
		hitbox3: { damage: 6, angle: 45, baseKnockback: 20, knockbackGrowth: 40, hitstop: 3, selfHitstop: 2 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 9, angle: 45, baseKnockback: 30, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 30, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1 },
		hitbox2: { damage: 13, angle: 45, baseKnockback: 60, knockbackGrowth: 70, hitstop: 9, selfHitstop: 4 },
		hitbox3: { damage: 13, angle: 45, baseKnockback: 60, knockbackGrowth: 70, hitstop: 9, selfHitstop: 4 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 110, baseKnockback: 40, knockbackGrowth: 120, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 40, knockbackGrowth: 116, hitstop: 2, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox2: { damage: 12, angle: 110, baseKnockback: 50, knockbackGrowth: 100, hitstop: 4, selfHitstop: 3, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox3: { damage: 12, angle: 110, baseKnockback: 50, knockbackGrowth: 100, hitstop: 4, selfHitstop: 3, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox4: { damage: 12, angle: 110, baseKnockback: 50, knockbackGrowth: 100, hitstop: 4, selfHitstop: 3, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 9, angle: 30, baseKnockback: 40, knockbackGrowth: 40, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 8, angle: 30, baseKnockback: 20, knockbackGrowth: 40, hitstop: 4, selfHitstop: 3 },
		hitbox2: { damage: 10, angle: 30, baseKnockback: 50, knockbackGrowth: 40, hitstop: 4, selfHitstop: 3 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 14, angle: 45, baseKnockback: 60, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2 },
		hitbox1: { damage: 14, angle: 45, baseKnockback: 60, knockbackGrowth: 70, hitstop: 4, selfHitstop: 2 },
		hitbox2: { damage: 20, angle: 45, baseKnockback: 80, knockbackGrowth: 70, hitstop: 8, selfHitstop: 6 },
		hitbox3: { damage: 20, angle: 45, baseKnockback: 80, knockbackGrowth: 70, hitstop: 8, selfHitstop: 6 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 2, angle: 100, baseKnockback: 100, knockbackGrowth: 100, hitstop: 0, selfHitstop: 3 },
		hitbox1: { damage: 17, angle: 90, baseKnockback: 60, knockbackGrowth: 75, hitstop: 9, selfHitstop: 9 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 14, angle: 75, baseKnockback: 56, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 16, angle: 70, baseKnockback: 50, knockbackGrowth: 80, hitstop: 6, selfHitstop: 4 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 4, angle: 100, baseKnockback: 30, knockbackGrowth: 40, hitstop: 3, selfHitstop: 2, hitstun: -1.05  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 100, baseKnockback: 30, knockbackGrowth: 40, hitstop: 3, selfHitstop: 2, hitstun: -1.05  // SSF2 hitLag multiplier },
		hitbox2: { damage: 4, angle: 100, baseKnockback: 30, knockbackGrowth: 40, hitstop: 5, selfHitstop: 4, hitstun: -1.05  // SSF2 hitLag multiplier },
		hitbox3: { damage: 4, angle: 100, baseKnockback: 30, knockbackGrowth: 40, hitstop: 5, selfHitstop: 4, hitstun: -1.05  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 70, hitstop: 3, selfHitstop: 2, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 20, knockbackGrowth: 70, hitstop: 3, selfHitstop: 2, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 13, angle: 67, baseKnockback: 42, knockbackGrowth: 70, hitstop: 4, selfHitstop: 3, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox3: { damage: 13, angle: 67, baseKnockback: 42, knockbackGrowth: 70, hitstop: 4, selfHitstop: 3, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 10, angle: 45, baseKnockback: 40, knockbackGrowth: 75, hitstop: 3, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 40, knockbackGrowth: 75, hitstop: 3, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 90, hitstop: 7, selfHitstop: 6, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox3: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 90, hitstop: 7, selfHitstop: 6, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 10, angle: 80, baseKnockback: 40, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 80, baseKnockback: 40, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox2: { damage: 13, angle: 90, baseKnockback: 50, knockbackGrowth: 80, hitstop: 5, selfHitstop: 4, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox3: { damage: 13, angle: 90, baseKnockback: 50, knockbackGrowth: 80, hitstop: 5, selfHitstop: 4, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 80, baseKnockback: 40, knockbackGrowth: 70, hitstop: 4, selfHitstop: 1 },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 40, knockbackGrowth: 70, hitstop: 4, selfHitstop: 1 },
		hitbox2: { damage: 13, angle: 291, baseKnockback: 40, knockbackGrowth: 70, hitstop: 7, selfHitstop: 5 },
		hitbox3: { damage: 13, angle: 291, baseKnockback: 40, knockbackGrowth: 70, hitstop: 7, selfHitstop: 5 },
		hitbox4: { damage: 13, angle: 291, baseKnockback: 40, knockbackGrowth: 70, hitstop: 7, selfHitstop: 5 },
		hitbox5: { damage: 9, angle: 45, baseKnockback: 30, knockbackGrowth: 70, hitstop: 4, selfHitstop: 1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 8, angle: 50, baseKnockback: 50, knockbackGrowth: 60, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 12, angle: 50, baseKnockback: 50, knockbackGrowth: 65, hitstop: 6, selfHitstop: 5 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 8, angle: 50, baseKnockback: 50, knockbackGrowth: 60, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 12, angle: 50, baseKnockback: 50, knockbackGrowth: 65, hitstop: 6, selfHitstop: 5 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 5, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 },
		hitbox1: { damage: 6, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 },
		hitbox2: { damage: 6, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 5, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 },
		hitbox1: { damage: 6, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 },
		hitbox2: { damage: 6, angle: 60, baseKnockback: 35, knockbackGrowth: 10, hitstop: 2, selfHitstop: 0 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 13, angle: 45, baseKnockback: 80, knockbackGrowth: 70, hitstop: 7, selfHitstop: 5 },
		hitbox1: { damage: 10, angle: 75, baseKnockback: 60, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 },
		hitbox2: { damage: 10, angle: 75, baseKnockback: 60, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 13, angle: 45, baseKnockback: 80, knockbackGrowth: 70, hitstop: 7, selfHitstop: 5 },
		hitbox1: { damage: 10, angle: 75, baseKnockback: 60, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 },
		hitbox2: { damage: 10, angle: 75, baseKnockback: 60, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 7, angle: 50, baseKnockback: 60, knockbackGrowth: 50, hitstop: 4, selfHitstop: 3 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 7, angle: 50, baseKnockback: 60, knockbackGrowth: 50, hitstop: 4, selfHitstop: 3 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 93, baseKnockback: 60, knockbackGrowth: 130, hitstop: 0, selfHitstop: 0, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 4, angle: 135, baseKnockback: 65, knockbackGrowth: 50, hitstop: 1, selfHitstop: 0 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 4, angle: 50, baseKnockback: 70, knockbackGrowth: 45, hitstop: 2, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 7, angle: 117, baseKnockback: 70, knockbackGrowth: 60, hitstop: 2, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 5, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}