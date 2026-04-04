// HitboxStats for Pikachu (converted from SSF2)
// Source: JPEXS-decompiled pikachu.ssf
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
		hitbox0: { damage: 2, angle: 20, baseKnockback: 12, knockbackGrowth: 25, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 7, angle: 40, baseKnockback: 45, knockbackGrowth: 100, hitstop: 3, selfHitstop: 1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 8, angle: 90, baseKnockback: 40, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 8, angle: 90, baseKnockback: 40, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 8, angle: 90, baseKnockback: 40, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 51, baseKnockback: 40, knockbackGrowth: 80, hitstop: 3, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 18, angle: 50, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 16, angle: 75, baseKnockback: 60, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 15, angle: 85, baseKnockback: 40, knockbackGrowth: 102, hitstop: 5, selfHitstop: 5, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 15, angle: 85, baseKnockback: 40, knockbackGrowth: 102, hitstop: 5, selfHitstop: 5, hitstun: -1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 2, angle: 170, baseKnockback: 70, knockbackGrowth: 8, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 2, angle: 170, baseKnockback: 70, knockbackGrowth: 8, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 12, angle: 45, baseKnockback: 50, knockbackGrowth: 70, hitstop: 4, selfHitstop: 1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 2, angle: 55, baseKnockback: 25, knockbackGrowth: 100, hitstop: 1, selfHitstop: 2, hitstun: -1.07  // SSF2 hitLag multiplier },
		hitbox1: { damage: 2, angle: 55, baseKnockback: 25, knockbackGrowth: 100, hitstop: 1, selfHitstop: 2, hitstun: -1.07  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 9, angle: 45, baseKnockback: 45, knockbackGrowth: 100, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 4, angle: 80, baseKnockback: 70, knockbackGrowth: 60, hitstop: 2, selfHitstop: 0, hitstun: -1.15  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 80, baseKnockback: 70, knockbackGrowth: 60, hitstop: 2, selfHitstop: 0, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 13, angle: 45, baseKnockback: 50, knockbackGrowth: 85, hitstop: 5, selfHitstop: 2 },
		hitbox1: { damage: 6, angle: 73, baseKnockback: 70, knockbackGrowth: 98, hitstop: 2, selfHitstop: 1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 10, angle: 10, baseKnockback: 20, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 10, angle: 10, baseKnockback: 20, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 12, angle: 39, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 12, angle: 39, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 3, angle: 60, baseKnockback: 70, knockbackGrowth: 1, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 60, baseKnockback: 70, knockbackGrowth: 1, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 3, angle: 60, baseKnockback: 70, knockbackGrowth: 1, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 3, angle: 60, baseKnockback: 70, knockbackGrowth: 1, hitstop: 2, selfHitstop: 0, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 17, angle: 40, baseKnockback: 60, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 17, angle: 40, baseKnockback: 60, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 90, baseKnockback: 60, knockbackGrowth: 75, hitstop: 2, selfHitstop: 2, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 5, angle: 75, baseKnockback: 75, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1, hitstun: -1.08  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 2, angle: 50, baseKnockback: 80, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 9, angle: 135, baseKnockback: 75, knockbackGrowth: 50, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 80, knockbackGrowth: 40, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}