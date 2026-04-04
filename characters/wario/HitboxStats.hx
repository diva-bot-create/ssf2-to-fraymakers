// HitboxStats for Wario (converted from SSF2)
// Source: JPEXS-decompiled wario.ssf
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
		hitbox0: { damage: 5, angle: 60, baseKnockback: 15, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 13, angle: 45, baseKnockback: 26, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 11, angle: 90, baseKnockback: 60, knockbackGrowth: 75, hitstop: 4, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 90, baseKnockback: 60, knockbackGrowth: 75, hitstop: 4, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 11, angle: 80, baseKnockback: 70, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 5, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: -1, selfHitstop: 0 },
		hitbox2: { damage: 11, angle: 80, baseKnockback: 70, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox3: { damage: 11, angle: 80, baseKnockback: 70, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 11, angle: 50, baseKnockback: 25, knockbackGrowth: 123, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 0.6, angle: 120, baseKnockback: 40, knockbackGrowth: 10, hitstop: 1, selfHitstop: 1 },
		hitbox1: { damage: 0.6, angle: 240, baseKnockback: 40, knockbackGrowth: 10, hitstop: 1, selfHitstop: 1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 10, angle: 270, baseKnockback: 30, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 10, angle: 270, baseKnockback: 30, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 9, angle: 40, baseKnockback: 40, knockbackGrowth: 118, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 40, baseKnockback: 35, knockbackGrowth: 109, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 9, angle: 61, baseKnockback: 37, knockbackGrowth: 70, hitstop: 3, selfHitstop: 1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 45, baseKnockback: 20, knockbackGrowth: 110, hitstop: 4, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 16, angle: 83, baseKnockback: 25, knockbackGrowth: 97, hitstop: 7, selfHitstop: 6, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 2, angle: 80, baseKnockback: 16, knockbackGrowth: 40, hitstop: 2, selfHitstop: 1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 2, angle: 10, baseKnockback: 60, knockbackGrowth: 70, hitstop: 1, selfHitstop: 1, hitstun: -2  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 2, angle: 10, baseKnockback: 60, knockbackGrowth: 70, hitstop: 1, selfHitstop: 1, hitstun: -2  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 8, angle: 40, baseKnockback: 40, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 8, angle: 40, baseKnockback: 40, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 1, angle: 84, baseKnockback: 90, knockbackGrowth: 30, hitstop: 1, selfHitstop: 1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 1, angle: 84, baseKnockback: 90, knockbackGrowth: 30, hitstop: 1, selfHitstop: 1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 17, angle: 43, baseKnockback: 75, knockbackGrowth: 16, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 17, angle: 35, baseKnockback: 75, knockbackGrowth: 16, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 6, angle: 90, baseKnockback: 60, knockbackGrowth: 80, hitstop: 2, selfHitstop: 2, hitstun: -1.14  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 78, baseKnockback: 50, knockbackGrowth: 170, hitstop: 1, selfHitstop: 3 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 65, baseKnockback: 70, knockbackGrowth: 62, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 10, angle: 155, baseKnockback: 70, knockbackGrowth: 60, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 5, angle: 40, baseKnockback: 55, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}