// HitboxStats for Bandanadee (converted from SSF2)
// Source: JPEXS-decompiled bandanadee.ssf
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
		hitbox0: { damage: 2, angle: 50, baseKnockback: 15, knockbackGrowth: 30, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 2, angle: 50, baseKnockback: 15, knockbackGrowth: 30, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 2, angle: 50, baseKnockback: 15, knockbackGrowth: 30, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 9, angle: 40, baseKnockback: 20, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 7, angle: 85, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 7, angle: 85, baseKnockback: 50, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 75, baseKnockback: 35, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 4, angle: 40, baseKnockback: 80, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 40, baseKnockback: 80, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 0.5, angle: 190, baseKnockback: 25, knockbackGrowth: 10, hitstop: -1, selfHitstop: -1, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 13, angle: 75, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 12, angle: 75, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 12, angle: 75, baseKnockback: 30, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 1.5, angle: 60, baseKnockback: 50, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 2, angle: 45, baseKnockback: 30, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox1: { damage: 2, angle: 45, baseKnockback: 30, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 12, angle: 140, baseKnockback: 35, knockbackGrowth: 105, hitstop: 4, selfHitstop: 1 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 88, baseKnockback: 45, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 12, angle: 85, baseKnockback: 40, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 2, angle: 250, baseKnockback: 32, knockbackGrowth: 32, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 2, angle: 250, baseKnockback: 32, knockbackGrowth: 32, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 2, angle: 60, baseKnockback: 30, knockbackGrowth: 50, hitstop: 1, selfHitstop: 1 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 2, angle: 60, baseKnockback: 30, knockbackGrowth: 50, hitstop: 1, selfHitstop: 1 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 23, angle: 45, baseKnockback: 65, knockbackGrowth: 72, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 17, angle: 35, baseKnockback: 50, knockbackGrowth: 70, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 13, angle: 85, baseKnockback: 70, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 13, angle: 85, baseKnockback: 70, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 15, angle: 70, baseKnockback: 45, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 2, angle: 310, baseKnockback: 40, knockbackGrowth: 70, hitstop: 1, selfHitstop: 1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 1, angle: 85, baseKnockback: 50, knockbackGrowth: 83, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 10, angle: 75, baseKnockback: 40, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1.07  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 9, angle: 63, baseKnockback: 40, knockbackGrowth: 75, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 8, angle: 200, baseKnockback: 50, knockbackGrowth: 10, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 55, baseKnockback: 100, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}