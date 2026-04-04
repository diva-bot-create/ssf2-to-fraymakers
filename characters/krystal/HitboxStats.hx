// HitboxStats for Krystal (converted from SSF2)
// Source: JPEXS-decompiled krystal.ssf
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
		hitbox0: { damage: 2, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: 0, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 2, angle: 40, baseKnockback: 20, knockbackGrowth: 8, hitstop: 1, selfHitstop: 0 },
		hitbox1: { damage: 2, angle: 225, baseKnockback: 20, knockbackGrowth: 8, hitstop: 1, selfHitstop: 0 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 100, baseKnockback: 56, knockbackGrowth: 64, hitstop: 2, selfHitstop: 1 },
		hitbox1: { damage: 9, angle: 100, baseKnockback: 56, knockbackGrowth: 64, hitstop: 2, selfHitstop: 1 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 85, baseKnockback: 42, knockbackGrowth: 90, hitstop: 2, selfHitstop: 0, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 13, angle: 40, baseKnockback: 54, knockbackGrowth: 70, hitstop: 2, selfHitstop: 2 },
		hitbox1: { damage: 18, angle: 35, baseKnockback: 50, knockbackGrowth: 82, hitstop: 6, selfHitstop: 4 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 1, angle: 100, baseKnockback: 25, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1, angle: 100, baseKnockback: 25, knockbackGrowth: 0, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 16, angle: 40, baseKnockback: 50, knockbackGrowth: 92, hitstop: 2, selfHitstop: 2 },
		hitbox1: { damage: 16, angle: 40, baseKnockback: 50, knockbackGrowth: 92, hitstop: 2, selfHitstop: 2 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 13, angle: 65, baseKnockback: 45, knockbackGrowth: 90, hitstop: 2, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier },
		hitbox1: { damage: 13, angle: 65, baseKnockback: 45, knockbackGrowth: 90, hitstop: 2, selfHitstop: 1, hitstun: -1.12  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 5, angle: 35, baseKnockback: 30, knockbackGrowth: 30, hitstop: 6, selfHitstop: 3, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 11, angle: 135, baseKnockback: 40, knockbackGrowth: 88, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 88, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox2: { damage: 11, angle: 45, baseKnockback: 40, knockbackGrowth: 88, hitstop: 4, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 13, angle: 90, baseKnockback: 30, knockbackGrowth: 85, hitstop: 4, selfHitstop: 3 },
		hitbox1: { damage: 16, angle: 90, baseKnockback: 40, knockbackGrowth: 88, hitstop: 6, selfHitstop: 9 }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 14, angle: 75, baseKnockback: 38, knockbackGrowth: 85, hitstop: 4, selfHitstop: 4, hitstun: -1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 18, angle: 270, baseKnockback: 62, knockbackGrowth: 95, hitstop: 6, selfHitstop: 9, hitstun: -1  // SSF2 hitLag multiplier }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 20, angle: 10, baseKnockback: 0 /*TODO*/, knockbackGrowth: 16, hitstop: 3, selfHitstop: 0, hitstun: 0.9  // SSF2 hitLag multiplier }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 55, hitstop: 2, selfHitstop: 8, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 8, angle: 80, baseKnockback: 75, knockbackGrowth: 55, hitstop: 2, selfHitstop: 8, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 4, angle: 270, baseKnockback: 45, knockbackGrowth: 65, hitstop: 6, selfHitstop: 3, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 270, baseKnockback: 45, knockbackGrowth: 65, hitstop: 6, selfHitstop: 3, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 4, angle: 270, baseKnockback: 45, knockbackGrowth: 65, hitstop: 6, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 4, angle: 270, baseKnockback: 45, knockbackGrowth: 65, hitstop: 6, selfHitstop: 2, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 8, angle: 90, baseKnockback: 90, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 8, angle: 90, baseKnockback: 90, knockbackGrowth: 50, hitstop: 2, selfHitstop: 1, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: 0, selfHitstop: 0 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 8, angle: 85, baseKnockback: 95, knockbackGrowth: 45, hitstop: 2, selfHitstop: 1 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 6, angle: 270, baseKnockback: 20, knockbackGrowth: 0, hitstop: 4, selfHitstop: 2, hitstun: 17  // SSF2 hitLag multiplier }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 55, baseKnockback: 82, knockbackGrowth: 50, hitstop: 6, selfHitstop: 1, hitstun: -1.04  // SSF2 hitLag multiplier }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 11, angle: 42, baseKnockback: 44, knockbackGrowth: 85, hitstop: 2, selfHitstop: 2 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 5, angle: -4, baseKnockback: 80, knockbackGrowth: 25, hitstop: 2, selfHitstop: 2 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}