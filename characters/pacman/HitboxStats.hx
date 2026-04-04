// HitboxStats for Pacman (converted from SSF2)
// Source: JPEXS-decompiled pacman.ssf
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
		hitbox0: { damage: 3, angle: 100, baseKnockback: 20, knockbackGrowth: 15, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 100, baseKnockback: 20, knockbackGrowth: 15, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox2: { damage: 3, angle: 100, baseKnockback: 20, knockbackGrowth: 15, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 46, baseKnockback: 45, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 46, baseKnockback: 45, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 80, baseKnockback: 60, knockbackGrowth: 85, hitstop: 4, selfHitstop: 1 },
		hitbox1: { damage: 7, angle: 80, baseKnockback: 60, knockbackGrowth: 85, hitstop: 4, selfHitstop: 1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 65, baseKnockback: 65, knockbackGrowth: 55, hitstop: 3, selfHitstop: 2 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 45, baseKnockback: 40, knockbackGrowth: 97, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 15, angle: 45, baseKnockback: 40, knockbackGrowth: 97, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 15, angle: 45, baseKnockback: 40, knockbackGrowth: 97, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 3, angle: 105, baseKnockback: 120, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 105, baseKnockback: 120, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 13, angle: 30, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 13, angle: 30, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 11, angle: 45, baseKnockback: 20, knockbackGrowth: 123, hitstop: 3, selfHitstop: 1 }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 8, angle: 45, baseKnockback: 15, knockbackGrowth: 105, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 15, knockbackGrowth: 105, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 4, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 10, angle: 80, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 10, angle: 80, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 4, angle: 55, baseKnockback: 50, knockbackGrowth: 13, hitstop: 4, selfHitstop: 2, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 55, baseKnockback: 50, knockbackGrowth: 13, hitstop: 4, selfHitstop: 2, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 2, angle: 45, baseKnockback: 65, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 2, angle: 45, baseKnockback: 65, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 8, angle: 60, baseKnockback: 70, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 8, angle: 60, baseKnockback: 70, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 11, angle: 80, baseKnockback: 91, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, hitstun: -1.11  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 11, angle: 80, baseKnockback: 91, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1, hitstun: -1.11  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 5, angle: 88, baseKnockback: 110, knockbackGrowth: 10, hitstop: 0, selfHitstop: 0 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 3, angle: 85, baseKnockback: 78, knockbackGrowth: 42, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 6, angle: 38, baseKnockback: 50, knockbackGrowth: 78, hitstop: 0, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 11, angle: 145, baseKnockback: 50, knockbackGrowth: 80, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: 3, selfHitstop: 0 },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: 3, selfHitstop: 0 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}