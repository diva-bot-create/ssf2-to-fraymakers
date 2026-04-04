// CharacterStats for Ganondorf
// Source: GanondorfExt.as → getOwnStats()
// SSF2 field → Fraymakers field mapping noted inline
{
	spriteContent: self.getResource().getContent("ganondorf"),

	//GENERIC STATS
	baseScaleX: 1.0,
	baseScaleY: 1.0,
	weight: 113,                      // SSF2: weight1
	gravity: 1.6,                     // SSF2: gravity
	shortHopSpeed: 13.5,              // SSF2: shortHopSpeed
	jumpSpeed: 17,                    // SSF2: jumpSpeed
	jumpSpeedForwardInitialXSpeed: 3,
	jumpSpeedBackwardInitialXSpeed: -3,
	doubleJumpSpeeds: [16.5],         // SSF2: jumpSpeedMidair (max_jump: 1 → one double jump)
	terminalVelocity: 13.8,           // SSF2: max_ySpeed
	fastFallSpeed: 18,                // SSF2: fastFallSpeed
	friction: 1.35,                   // SSF2: decel_rate (abs value of -1.35)
	walkSpeedInitial: 0.455,          // SSF2: accel_start
	walkSpeedAcceleration: 0.455,     // SSF2: accel_start
	walkSpeedCap: 4.4,                // SSF2: norm_xSpeed
	dashSpeed: 9.5,                   // SSF2: accel_start_dash scaled to Fraymakers units
	runSpeedInitial: 4.4,             // SSF2: norm_xSpeed
	runSpeedAcceleration: 0.9,        // SSF2: accel_rate
	runSpeedCap: 9.0,                 // SSF2: max_xSpeed
	groundSpeedAcceleration: 0.9,     // SSF2: accel_rate
	groundSpeedCap: 9.0,              // SSF2: max_xSpeed
	aerialSpeedAcceleration: 0.85,    // SSF2: accel_rate_air
	aerialSpeedCap: 9.0,              // SSF2: max_xSpeed (aerial)
	aerialFriction: 0.2,              // SSF2: decel_rate_air (abs value of -0.2)

	wallJumpXSpeed: 8.5,
	wallJumpYSpeed: 14,
	wallJumpLimit: 1,

	//ECB STATS — adjust to match SSF2 collision box: width:22, height:64
	floorHeadPosition: 64,
	floorHipWidth: 22,
	floorHipXOffset: 0,
	floorHipYOffset: 0,
	floorFootPosition: 0,
	aerialHeadPosition: 64,
	aerialHipWidth: 22,
	aerialHipXOffset: 0,
	aerialHipYOffset: 0,
	aerialFootPosition: 16,

	//CAMERA BOX STATS
	cameraBoxOffsetX: 25,
	cameraBoxOffsetY: 64,
	cameraBoxWidth: 200,
	cameraBoxHeight: 250,

	//ROLL AND LEDGE JUMP STATS
	// SSF2: roll_speed:32, roll_decay:0.7, getup_roll_delay:2, tech_roll_delay:5, climb_roll_delay:9
	techRollSpeed: 18,
	techRollSpeedStartFrame: 5,       // SSF2: tech_roll_delay
	techRollSpeedLength: 1,
	dodgeRollSpeed: 16,               // SSF2: dodgeSpeed
	dodgeRollSpeedStartFrame: 2,      // SSF2: getup_roll_delay
	dodgeRollSpeedLength: 1,
	getupRollSpeed: 15.5,
	getupRollSpeedStartFrame: 2,
	getupRollSpeedLength: 1,
	ledgeRollSpeed: 14,
	ledgeRollSpeedStartFrame: 9,      // SSF2: climb_roll_delay
	ledgeRollSpeedLength: 1,
	ledgeJumpXSpeed: 2.5,
	ledgeJumpYSpeed: -10,

	//AIRDASH STATS
	airdashInitialSpeed: 11,
	airdashSpeedCap: 12.5,
	airdashAccelMultiplier: 0.4,
	airdashCancelSpeedConservation: 0.9,

	//BURY VISUAL STATS
	buryAnimation: "hurt_thrown",
	buryFrame: 13,
	buryOffsetY: -10,

	//SHIELD STATS
	// SSF2: maxShieldSize:1.45, shield_scale:1.2
	shieldCrossupThreshold: 16,
	shieldFrontNineSliceContent: "global::vfx.vfx_shield_front",
	shieldFrontXOffset: 10.5,
	shieldFrontYOffset: 4,
	shieldFrontWidth: 62,             // scaled from SSF2 shield_scale 1.2
	shieldFrontHeight: 112,
	shieldBackNineSliceContent: "global::vfx.vfx_shield_back",
	shieldBackXOffset: 12.5,
	shieldBackYOffset: 4,
	shieldBackWidth: 59,
	shieldBackHeight: 112,

	//VOICE STATS
	// SSF2 sounds block from getOwnStats():
	//   hurt: "ganondorf_hurt1", hurt2: "ganondorf_hurt2"
	//   hurtBad: "ganondorf_hurtBad1", hurtBad2: "ganondorf_hurtBad2"
	//   dead: "ganondorf_die1", dead2: "ganondorf_die2"
	//   screenko: "ganondorf_hurt2", starko: "ganondorf_starKO"
	//   ledge_grab: "ganondorf_ledge", winTheme: "ganondorf_victory"
	// Attack voices defined per-move in HitboxStats (attackVoice1_id etc.)
	attackVoiceIds: ["ganondorf_attackvc1", "ganondorf_attackvc2", "ganondorf_attackvc3", "ganondorf_attackvc4", "ganondorf_smash2", "ganondorf_dspec"],
	hurtLightVoiceIds: [],
	hurtMediumVoiceIds: ["ganondorf_hurt1", "ganondorf_hurt2"],
	hurtHeavyVoiceIds: ["ganondorf_hurtBad1", "ganondorf_hurtBad2"],
	koVoiceIds: ["ganondorf_die1", "ganondorf_die2", "ganondorf_starKO"],
	attackVoiceSilenceRate: 0.5,
	hurtLightSilenceRate: 1,
	hurtMediumSilenceRate: 0.5,
	hurtHeavySilenceRate: 0,
	koVoiceSilenceRate: 0,
}
