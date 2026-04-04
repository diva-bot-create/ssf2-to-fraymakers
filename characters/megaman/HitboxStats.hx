// HitboxStats for Megaman (converted from SSF2)
// Source: JPEXS-decompiled megaman.ssf
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
		hitbox0: { damage: 3, angle: 60, baseKnockback: 20, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 14, angle: 45, baseKnockback: 30, knockbackGrowth: 90, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 17, angle: 85, baseKnockback: 38, knockbackGrowth: 107, hitstop: -1, selfHitstop: -1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 8, angle: 65, baseKnockback: 65, knockbackGrowth: 55, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forward
		hitbox0: { damage: 1, angle: 28, baseKnockback: 38, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 2, angle: 115, baseKnockback: 160, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 17, angle: 90, baseKnockback: 30, knockbackGrowth: 99, hitstop: 4, selfHitstop: 2 },
		hitbox1: { damage: 17, angle: 90, baseKnockback: 30, knockbackGrowth: 99, hitstop: 4, selfHitstop: 2 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 4, angle: 70, baseKnockback: 50, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 4, angle: 80, baseKnockback: 50, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 4, angle: 80, baseKnockback: 50, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 },
		hitbox3: { damage: 4, angle: 70, baseKnockback: 50, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1 }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 20, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1, hitstun: -1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 15, angle: 45, baseKnockback: 35, knockbackGrowth: 100, hitstop: 5, selfHitstop: 3 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 0, angle: 0, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0 }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 10, angle: 270, baseKnockback: 35, knockbackGrowth: 85, hitstop: 3, selfHitstop: 2 },
		hitbox1: { damage: 6, angle: 80, baseKnockback: 35, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1 },
		hitbox2: { damage: 6, angle: 80, baseKnockback: 35, knockbackGrowth: 75, hitstop: 2, selfHitstop: 1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: -0.7  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: -0.7  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 4, angle: 45, baseKnockback: 30, knockbackGrowth: 105, hitstop: 2, selfHitstop: 2 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 4, angle: 45, baseKnockback: 30, knockbackGrowth: 105, hitstop: 2, selfHitstop: 2 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 0, angle: 20, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 0, angle: 20, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 0, angle: 80, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 1, selfHitstop: 1, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 0, angle: 270, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 1, selfHitstop: 1, hitstun: 0.9  // SSF2 hitLag multiplier }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 7, angle: 90, baseKnockback: 80, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 60, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 8, angle: 40, baseKnockback: 50, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 11, angle: 120, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 80, knockbackGrowth: 50, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 8, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}