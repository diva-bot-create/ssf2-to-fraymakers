// HitboxStats for Ganondorf (converted from SSF2)
// Source: JPEXS-decompiled ganondorf.ssf
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
		hitbox0: { damage: 11, angle: 40, baseKnockback: 40, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 40, baseKnockback: 40, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 13, angle: 15, baseKnockback: 39, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 0, angle: 0, baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0 },
		hitbox1: { damage: 0, angle: 180, baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0 },
		hitbox2: { damage: 0, angle: 180, baseKnockback: 20, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 13, angle: 75, baseKnockback: 30, knockbackGrowth: 75, hitstop: 6, selfHitstop: 4, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 85, baseKnockback: 30, knockbackGrowth: 75, hitstop: 6, selfHitstop: 4, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox3: { damage: 24, angle: 40, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 21, angle: 75, baseKnockback: 40, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 21, angle: 75, baseKnockback: 40, knockbackGrowth: 82, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1 },
		hitbox3: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1 },
		hitbox4: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1 },
		hitbox5: { damage: 24, angle: 85, baseKnockback: 40, knockbackGrowth: 78, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 5, angle: 90, baseKnockback: 60, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 16  // SSF2 hitLag multiplier },
		hitbox1: { damage: 5, angle: 90, baseKnockback: 60, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 16  // SSF2 hitLag multiplier }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 12, angle: 45, baseKnockback: 25, knockbackGrowth: 100, hitstop: 5, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 17, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 6, selfHitstop: 3 },
		hitbox1: { damage: 17, angle: 45, baseKnockback: 60, knockbackGrowth: 80, hitstop: 6, selfHitstop: 3 }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 17, angle: 45, baseKnockback: 20, knockbackGrowth: 90, hitstop: 5, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 18, angle: 45, baseKnockback: 40, knockbackGrowth: 90, hitstop: 7, selfHitstop: 4, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 12, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 22, angle: 280, baseKnockback: 70, knockbackGrowth: 80, hitstop: 12, selfHitstop: 8 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 32, angle: 50, baseKnockback: 120, knockbackGrowth: 46, hitstop: 10, selfHitstop: 10 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 38, angle: 30, baseKnockback: 30, knockbackGrowth: 100, hitstop: 10, selfHitstop: 10 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 12, angle: 270, baseKnockback: 60, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 15, angle: 270, baseKnockback: 60, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 1, angle: 20, baseKnockback: 50, knockbackGrowth: 40, hitstop: 0, selfHitstop: 0 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 20, baseKnockback: 50, knockbackGrowth: 40, hitstop: 0, selfHitstop: 0 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 13, angle: 40, baseKnockback: 60, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 40, baseKnockback: 60, knockbackGrowth: 60, hitstop: 5, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 15, angle: 291, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 15, angle: 291, baseKnockback: 60, knockbackGrowth: 80, hitstop: 5, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 70, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 45, baseKnockback: 40, knockbackGrowth: 90, hitstop: 5, selfHitstop: 4 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 10, angle: 130, baseKnockback: 50, knockbackGrowth: 85, hitstop: 4, selfHitstop: 3 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 9, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}