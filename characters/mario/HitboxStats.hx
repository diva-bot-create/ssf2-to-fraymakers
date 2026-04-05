// HitboxStats.hx for mario — converted from SSF2
// SSF2 → Fraymakers mapping:
//   damage        → damage
//   direction     → angle
//   power/weightKB → baseKnockback
//   kbConstant    → knockbackGrowth
//   hitStun       → hitstop
//   selfHitStun   → selfHitstop
//   hitLag        → hitstun
{

	// ── LIGHT ATTACKS ─────────────────────────────────────
	jab1: {
		hitbox0: { damage: 3, angle: 80, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 0, hitstun: -1 },
		hitbox1: { damage: 3, angle: 80, baseKnockback: 20, knockbackGrowth: 100, hitstop: 3, selfHitstop: 0, hitstun: -1 },
	},
	jab2: { hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1 } },
	jab3: { hitbox0: { damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1 } },
	dash_attack: {
		hitbox0: { damage: 9, angle: 75, baseKnockback: 70, knockbackGrowth: 50, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	tilt_forward: {
		hitbox0: { damage: 9, angle: 35, baseKnockback: 10, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	tilt_up: {
		hitbox0: { damage: 8, angle: 96, baseKnockback: 26, knockbackGrowth: 125, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	tilt_down: {
		hitbox0: { damage: 10, angle: 70, baseKnockback: 30, knockbackGrowth: 80, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},

	// ── STRONG ATTACKS ─────────────────────────────────────
	strong_forward_attack: {
		hitbox0: { damage: 17, angle: 50, baseKnockback: 25, knockbackGrowth: 103, hitstop: 0, selfHitstop: 0, hitstun: 0 },
		hitbox1: { damage: 14, angle: 60, baseKnockback: 25, knockbackGrowth: 99, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	strong_up_attack: {
		hitbox0: { damage: 15, angle: 83, baseKnockback: 32, knockbackGrowth: 97, hitstop: 0, selfHitstop: 0, hitstun: -1 },
		hitbox1: { damage: 15, angle: 83, baseKnockback: 32, knockbackGrowth: 97, hitstop: 0, selfHitstop: 0, hitstun: -1 },
		hitbox2: { damage: 15, angle: 83, baseKnockback: 32, knockbackGrowth: 97, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	strong_down_attack: {
		hitbox0: { damage: 14, angle: 30, baseKnockback: 30, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},

	// ── AERIAL ATTACKS ─────────────────────────────────────
	aerial_neutral: {
		hitbox0: { damage: 12, angle: 40, baseKnockback: 20, knockbackGrowth: 99, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	aerial_forward: {
		hitbox0: { damage: 16, angle: 55, baseKnockback: 20, knockbackGrowth: 100, hitstop: 0, selfHitstop: 0, hitstun: -1 },
		hitbox1: { damage: 16, angle: 300, baseKnockback: 20, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	aerial_back: {
		hitbox0: { damage: 13, angle: 40, baseKnockback: 15, knockbackGrowth: 110, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	aerial_up: {
		hitbox0: { damage: 7, angle: 60, baseKnockback: 10, knockbackGrowth: 110, hitstop: 0, selfHitstop: 0, hitstun: -1 },
		hitbox1: { damage: 7, angle: 45, baseKnockback: 10, knockbackGrowth: 110, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	aerial_down: {
		hitbox0: { damage: 2, angle: 80, baseKnockback: 30, knockbackGrowth: 100, hitstop: 2, selfHitstop: 0, hitstun: -1 },
		hitbox1: { damage: 2, angle: 80, baseKnockback: 30, knockbackGrowth: 100, hitstop: 2, selfHitstop: 0, hitstun: -1 },
	},

	// ── SPECIALS ─────────────────────────────────────
	special_neutral: {
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	special_neutral_air: {
		hitbox0: { damage: 0, angle: 30, baseKnockback: 0, knockbackGrowth: 1, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	special_side: {
		hitbox0: { damage: 8, angle: 180, baseKnockback: 40, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	special_side_air: {
		hitbox0: { damage: 8, angle: 180, baseKnockback: 40, knockbackGrowth: 0, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	special_up: {
		hitbox0: { damage: 5, angle: 78, baseKnockback: 120, knockbackGrowth: 100, hitstop: 2, selfHitstop: 0, hitstun: 0 },
	},
	special_up_air: {
		hitbox0: { damage: 4, angle: 78, baseKnockback: 120, knockbackGrowth: 100, hitstop: 2, selfHitstop: 0, hitstun: 0 },
	},
	special_down: {
		hitbox0: { damage: 1, angle: 120, baseKnockback: 45, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, hitstun: 0 },
	},
	special_down_air: {
		hitbox0: { damage: 1, angle: 120, baseKnockback: 45, knockbackGrowth: 0, hitstop: 2, selfHitstop: 0, hitstun: -1 },
	},

	// ── THROWS ─────────────────────────────────────
	throw_up: {
		hitbox0: { damage: 8, angle: 85, baseKnockback: 80, knockbackGrowth: 90, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	throw_down: {
		hitbox0: { damage: 9, angle: 80, baseKnockback: 75, knockbackGrowth: 30, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},
	throw_forward: {
		hitbox0: { damage: 9, angle: 45, baseKnockback: 60, knockbackGrowth: 72, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},
	throw_back: {
		hitbox0: { damage: 12, angle: 145, baseKnockback: 80, knockbackGrowth: 65, hitstop: 0, selfHitstop: 0, hitstun: 0 },
	},

	// ── MISC ─────────────────────────────────────
	ledge_attack: {
		hitbox0: { damage: 6, angle: 45, baseKnockback: 75, knockbackGrowth: 25, hitstop: 2, selfHitstop: 0, hitstun: 0 },
	},
	crash_attack: {
		hitbox0: { damage: 8, angle: 50, baseKnockback: 80, knockbackGrowth: 50, hitstop: 0, selfHitstop: 0, hitstun: -1 },
	},

	// ── EXTRA (SSF2-specific) ─────────────────────────────────────
	special: {
		hitbox0: { damage: 0, angle: 0, baseKnockback: 2, knockbackGrowth: 1, hitstop: 1, selfHitstop: 0, hitstun: 0 },
	},
}
