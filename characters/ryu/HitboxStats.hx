// HitboxStats for Ryu (converted from SSF2)
// Source: JPEXS-decompiled ryu.ssf
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
		hitbox0: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 60, hitstop: 8, selfHitstop: 6 },
		hitbox1: { damage: 10, angle: 45, baseKnockback: 30, knockbackGrowth: 60, hitstop: 8, selfHitstop: 6 }
	},

	//TILT ATTACKS  
	tilt_forward: {  // SSF2: a_forward_tilt
		hitbox0: { damage: 7, angle: 55, baseKnockback: 66, knockbackGrowth: 46, hitstop: 7, selfHitstop: 5 }
	},
	tilt_up: {  // SSF2: a_up_tilt
		hitbox0: { damage: 12, angle: 80, baseKnockback: 38, knockbackGrowth: 82, hitstop: -1.8, selfHitstop: -1.8 }
	},
	tilt_down: {  // SSF2: crouch_attack
		hitbox0: { damage: 7, angle: 64, baseKnockback: 70, knockbackGrowth: 23, hitstop: 8, selfHitstop: 5 },
		hitbox1: { damage: 5, angle: 64, baseKnockback: 70, knockbackGrowth: 23, hitstop: 7, selfHitstop: 4 }
	},

	//STRONG ATTACKS  
	strong_forward_attack: {  // SSF2: a_forwardsmash
		hitbox0: { damage: 16, angle: 45, baseKnockback: 25, knockbackGrowth: 94, hitstop: 13, selfHitstop: 8 },
		hitbox1: { damage: 18, angle: 45, baseKnockback: 25, knockbackGrowth: 94, hitstop: 14, selfHitstop: 9 }
	},
	strong_up_attack: {  // SSF2: a_up
		hitbox0: { damage: 17, angle: 82, baseKnockback: 32, knockbackGrowth: 85, hitstop: -1.8, selfHitstop: -1.8 }
	},
	strong_down_attack: {  // SSF2: a_down
		hitbox0: { damage: 15, angle: 45, baseKnockback: 50, knockbackGrowth: 75, hitstop: -1.8, selfHitstop: -1.8 }
	},

	//AERIAL ATTACKS  
	aerial_neutral: {  // SSF2: a_air
		hitbox0: { damage: 8, angle: 45, baseKnockback: 20, knockbackGrowth: 100, hitstop: 8, selfHitstop: 6, hitstun: -1.15  // SSF2 hitLag multiplier }
	},
	aerial_forward: {  // SSF2: a_air_forward
		hitbox0: { damage: 15, angle: 61, baseKnockback: 0 /*TODO*/, knockbackGrowth: 105, hitstop: 11, selfHitstop: 7, hitstun: -1.1  // SSF2 hitLag multiplier },
		hitbox1: { damage: 9, angle: 70, baseKnockback: 0 /*TODO*/, knockbackGrowth: 105, hitstop: 9, selfHitstop: 5, hitstun: -1.1  // SSF2 hitLag multiplier }
	},
	aerial_back: {  // SSF2: a_air_backward
		hitbox0: { damage: 16, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 11, selfHitstop: 8 },
		hitbox1: { damage: 13, angle: 45, baseKnockback: 30, knockbackGrowth: 100, hitstop: 10, selfHitstop: 7 }
	},
	aerial_up: {  // SSF2: a_air_up
		hitbox0: { damage: 5, angle: 100, baseKnockback: 20, knockbackGrowth: 150, hitstop: 5, selfHitstop: 4 }
	},
	aerial_down: {  // SSF2: a_air_down
		hitbox0: { damage: 15, angle: 290, baseKnockback: 10, knockbackGrowth: 80, hitstop: -1.8, selfHitstop: -1.8 },
		hitbox1: { damage: 11, angle: 84, baseKnockback: 14, knockbackGrowth: 60, hitstop: -1.8, selfHitstop: -1.8 }
	},

	//SPECIAL ATTACKS  
	special_neutral: {  // SSF2: b
		hitbox0: { damage: 0, angle: 0, baseKnockback: 40, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0 }
	},
	special_neutral_air: {  // SSF2: b_air
		hitbox0: { damage: 0, angle: 0, baseKnockback: 40, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0 }
	},
	special_side: {  // SSF2: b_forward
		hitbox0: { damage: 9, angle: 55, baseKnockback: 80, knockbackGrowth: 50, hitstop: 12, selfHitstop: 5 }
	},
	special_side_air: {  // SSF2: b_forward_air
		hitbox0: { damage: 9, angle: 50, baseKnockback: 80, knockbackGrowth: 50, hitstop: 12, selfHitstop: 5 }
	},
	special_up: {  // SSF2: b_up
		hitbox0: { damage: 13, angle: 80, baseKnockback: 80, knockbackGrowth: 58, hitstop: 8, selfHitstop: 8 }
	},
	special_up_air: {  // SSF2: b_up_air
		hitbox0: { damage: 12, angle: 80, baseKnockback: 80, knockbackGrowth: 49, hitstop: 8, selfHitstop: 8 }
	},
	special_down: {  // SSF2: b_down
		hitbox0: { damage: 12, angle: 45, baseKnockback: 70, knockbackGrowth: 60, hitstop: 10, selfHitstop: 6 },
		hitbox1: { damage: 12, angle: 45, baseKnockback: 70, knockbackGrowth: 60, hitstop: 10, selfHitstop: 6 }
	},
	special_down_air: {  // SSF2: b_down_air
		hitbox0: { damage: 12, angle: 45, baseKnockback: 70, knockbackGrowth: 60, hitstop: 10, selfHitstop: 6 },
		hitbox1: { damage: 12, angle: 45, baseKnockback: 70, knockbackGrowth: 60, hitstop: 10, selfHitstop: 6 }
	},

	//THROWS  
	throw_up: {  // SSF2: throw_up
		hitbox0: { damage: 3, angle: 45, baseKnockback: 60, knockbackGrowth: 100, hitstop: -1.8, selfHitstop: -1.8 },
		hitbox1: { damage: 8, angle: 85, baseKnockback: 65, knockbackGrowth: 85, hitstop: 0, selfHitstop: 0, hitstun: -1.3  // SSF2 hitLag multiplier }
	},
	throw_down: {  // SSF2: throw_down
		hitbox0: { damage: 5, angle: 78, baseKnockback: 50, knockbackGrowth: 170, hitstop: 1, selfHitstop: 3 }
	},
	throw_forward: {  // SSF2: throw_forward
		hitbox0: { damage: 9, angle: 45, baseKnockback: 60, knockbackGrowth: 72, hitstop: 0, selfHitstop: 0 }
	},
	throw_back: {  // SSF2: throw_back
		hitbox0: { damage: 12, angle: 145, baseKnockback: 55, knockbackGrowth: 70, hitstop: 0, selfHitstop: 0 }
	},

	//MISC  
	getup_attack: {  // SSF2: getup_attack
		hitbox0: { damage: 6, angle: 50, baseKnockback: 100, knockbackGrowth: 110, hitstop: 6, selfHitstop: 5 }
	},
	ledge_attack: {  // SSF2: ledge_attack
		hitbox0: { damage: 7, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 6, selfHitstop: 5 }
	},

}