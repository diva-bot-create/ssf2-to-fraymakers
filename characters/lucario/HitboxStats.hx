// HitboxStats for Lucario (converted from SSF2)
// Source: JPEXS-decompiled lucario.ssf
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
		hitbox0: { damage: 2, angle: 291, baseKnockback: 24, knockbackGrowth: 38, hitstop: 3, selfHitstop: 1 },
		hitbox1: { damage: 2, angle: 291, baseKnockback: 24, knockbackGrowth: 38, hitstop: 3, selfHitstop: 1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 4, angle: 20, baseKnockback: 20, knockbackGrowth: 15, hitstop: 2, selfHitstop: 4, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 20, baseKnockback: 20, knockbackGrowth: 15, hitstop: 2, selfHitstop: 4, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 5, angle: 88, baseKnockback: 42, knockbackGrowth: 116, hitstop: 3, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox1: { damage: 5, angle: 88, baseKnockback: 42, knockbackGrowth: 116, hitstop: 3, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 6, angle: 65, baseKnockback: 48, knockbackGrowth: 90, hitstop: 4, selfHitstop: 1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 8, angle: 50, baseKnockback: 70, knockbackGrowth: 60, hitstop: 3, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 50, baseKnockback: 70, knockbackGrowth: 60, hitstop: 3, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 3, angle: 110, baseKnockback: 100, knockbackGrowth: 0, hitstop: 0, selfHitstop: 2, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 14.5, angle: 155, baseKnockback: 42, knockbackGrowth: 95, hitstop: -1.05, selfHitstop: 2 },
		hitbox1: { damage: 14.5, angle: 25, baseKnockback: 42, knockbackGrowth: 95, hitstop: -1.05, selfHitstop: 2 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 10, angle: 65, baseKnockback: 40, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1.18  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 65, baseKnockback: 40, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1.18  // SSF2 hitLag multiplier },
		hitbox2: { damage: 10, angle: 65, baseKnockback: 40, knockbackGrowth: 80, hitstop: 2, selfHitstop: 1, hitstun: -1.18  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 9, angle: 72, baseKnockback: 50, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 72, baseKnockback: 50, knockbackGrowth: 70, hitstop: 2, selfHitstop: 1, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 15, angle: 150, baseKnockback: 40, knockbackGrowth: 85, hitstop: 5, selfHitstop: 3, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 15, angle: 150, baseKnockback: 40, knockbackGrowth: 85, hitstop: 5, selfHitstop: 3, hitstun: -1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 12, angle: 90, baseKnockback: 50, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 4, angle: 90, baseKnockback: 32, knockbackGrowth: 6, hitstop: 1, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 90, baseKnockback: 50, knockbackGrowth: 8, hitstop: 1, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, hitstop: 2, selfHitstop: 0 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 1, angle: 75, baseKnockback: 20, knockbackGrowth: 50, hitstop: 2, selfHitstop: 0 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 15, angle: 45, baseKnockback: 64, knockbackGrowth: 96, hitstop: 2, selfHitstop: 2 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 15, angle: 291, baseKnockback: 40, knockbackGrowth: 60, hitstop: 2, selfHitstop: 2 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 6, angle: 40, baseKnockback: 80, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 6, angle: 40, baseKnockback: 80, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 8, angle: 75, baseKnockback: 40, knockbackGrowth: 105, hitstop: 7, selfHitstop: 7, hitstun: -0.6  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 8, angle: 30, baseKnockback: 30, knockbackGrowth: 95, hitstop: 7, selfHitstop: 7, hitstun: -0.6  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 90, baseKnockback: 58, knockbackGrowth: 55, hitstop: 6, selfHitstop: 3 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 15, angle: 80, baseKnockback: 94, knockbackGrowth: 32, hitstop: 5, selfHitstop: 3 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 40, baseKnockback: 70, knockbackGrowth: 40, hitstop: 1, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 11, angle: 35, baseKnockback: 50, knockbackGrowth: 60, hitstop: 2, selfHitstop: 1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}