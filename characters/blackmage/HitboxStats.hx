// HitboxStats for Blackmage (converted from SSF2)
// Source: JPEXS-decompiled blackmage.ssf
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
		hitbox0: { damage: 2, angle: 80, baseKnockback: 21, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 8, angle: 45, baseKnockback: 28, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 45, baseKnockback: 28, knockbackGrowth: 96, hitstop: -1, selfHitstop: -1 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 9, angle: 85, baseKnockback: 42, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 85, baseKnockback: 42, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 30, baseKnockback: 30, knockbackGrowth: 88, hitstop: -1, selfHitstop: -1 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 14.5, angle: 45, baseKnockback: 42, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 14.5, angle: 45, baseKnockback: 42, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox2: { damage: 14.5, angle: 45, baseKnockback: 42, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 15, angle: 90, baseKnockback: 30, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier },
		hitbox1: { damage: 15, angle: 90, baseKnockback: 30, knockbackGrowth: 105, hitstop: -1, selfHitstop: -1, hitstun: -1.2  // SSF2 hitLag multiplier }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 9, angle: 30, baseKnockback: 50, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 9, angle: 150, baseKnockback: 50, knockbackGrowth: 85, hitstop: -1, selfHitstop: -1 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 1.5, angle: 255, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox1: { damage: 1.5, angle: 255, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier },
		hitbox2: { damage: 1.5, angle: 255, baseKnockback: 40, knockbackGrowth: 0, hitstop: 1, selfHitstop: 1, hitstun: 5  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 9, angle: 40, baseKnockback: 49, knockbackGrowth: 90, hitstop: 5, selfHitstop: 1, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 9, angle: 150, baseKnockback: 35, knockbackGrowth: 110, hitstop: -1, selfHitstop: -1, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 10, angle: 90, baseKnockback: 35, knockbackGrowth: 95, hitstop: -1, selfHitstop: -1, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 8, angle: 270, baseKnockback: 20, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 270, baseKnockback: 20, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 50, baseKnockback: 50, knockbackGrowth: 40, hitstop: 15, selfHitstop: 0 },
		hitbox1: { damage: 0, angle: 50, baseKnockback: 50, knockbackGrowth: 40, hitstop: 15, selfHitstop: 0 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 50, baseKnockback: 50, knockbackGrowth: 40, hitstop: 15, selfHitstop: 0 },
		hitbox1: { damage: 0, angle: 50, baseKnockback: 50, knockbackGrowth: 40, hitstop: 15, selfHitstop: 0 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 2, angle: 40, baseKnockback: 70, knockbackGrowth: 112, hitstop: -1, selfHitstop: -1 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 2, angle: 40, baseKnockback: 70, knockbackGrowth: 112, hitstop: -1, selfHitstop: -1 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 2, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 2, angle: 90, baseKnockback: 0 /*TODO*/, knockbackGrowth: 1, hitstop: -1, selfHitstop: -1 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 6, angle: 80, baseKnockback: 36, knockbackGrowth: 88, hitstop: -1, selfHitstop: -1 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 6, angle: 80, baseKnockback: 36, knockbackGrowth: 88, hitstop: -1, selfHitstop: -1 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 0, angle: 270, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 2, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 2, angle: 50, baseKnockback: 90, knockbackGrowth: 42, hitstop: -1, selfHitstop: -1 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 1, angle: 10, baseKnockback: 80, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1, selfHitstop: -1 },
		hitbox1: { damage: 8, angle: 130, baseKnockback: 90, knockbackGrowth: 80, hitstop: -1, selfHitstop: -1 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 5, angle: 30, baseKnockback: 100, knockbackGrowth: 0, hitstop: -1, selfHitstop: -1 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 1 }
	},

}