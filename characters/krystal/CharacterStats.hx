// CharacterStats for Krystal
// Source: KrystalExt.as → getOwnStats()
{
	spriteContent: self.getResource().getContent("krystal"),

	//GENERIC STATS
	baseScaleX: 1.0,
	baseScaleY: 1.0,
	//GENERIC STATS
	weight: 77, // SSF2: weight1
	gravity: 1.85, // SSF2: gravity
	shortHopSpeed: 14, // SSF2: shortHopSpeed
	jumpSpeed: 22, // SSF2: jumpSpeed
	jumpSpeedForwardInitialXSpeed: 3,
	jumpSpeedBackwardInitialXSpeed: -3,
	doubleJumpSpeeds: [21], // SSF2: jumpSpeedMidair → array
	terminalVelocity: 15.5, // SSF2: max_ySpeed
	fastFallSpeed: 19, // SSF2: fastFallSpeed
	friction: 1.3, // SSF2: abs(decel_rate)
	walkSpeedInitial: 0.333, // SSF2: accel_start
	walkSpeedAcceleration: 0.333, // SSF2: accel_start
	walkSpeedCap: 6, // SSF2: norm_xSpeed
	dashSpeed: 10.8, // SSF2: accel_start_dash (approx) (estimated as 90% of max_xSpeed)
	runSpeedInitial: 6, // SSF2: norm_xSpeed
	runSpeedAcceleration: 1.35, // SSF2: accel_rate
	runSpeedCap: 12, // SSF2: max_xSpeed
	groundSpeedAcceleration: 1.35, // SSF2: accel_rate
	groundSpeedCap: 12, // SSF2: max_xSpeed
	aerialSpeedAcceleration: 0.72, // SSF2: accel_rate_air
	aerialSpeedCap: 12, // SSF2: max_xSpeed
	aerialFriction: 0.3, // SSF2: abs(decel_rate_air)
	wallJumpXSpeed: 8.5,
	wallJumpYSpeed: 14,
	wallJumpLimit: 1,

	//ECB STATS
	floorHeadPosition: 50, // SSF2: height
	floorHipWidth: 31, // SSF2: width
	floorHipXOffset: 0,
	floorHipYOffset: 0,
	floorFootPosition: 0,
	aerialHeadPosition: 50, // SSF2: height
	aerialHipWidth: 31, // SSF2: width
	aerialHipXOffset: 0,
	aerialHipYOffset: 0,
	aerialFootPosition: 16,

	//CAMERA BOX STATS
	cameraBoxOffsetX: 25,
	cameraBoxOffsetY: 75,
	cameraBoxWidth: 200,
	cameraBoxHeight: 250,

	//ROLL AND LEDGE STATS
	techRollSpeed: 18,
	techRollSpeedStartFrame: 5, // SSF2: tech_roll_delay
	techRollSpeedLength: 1,
	dodgeRollSpeed: 17.8, // SSF2: dodgeSpeed
	dodgeRollSpeedStartFrame: 5, // SSF2: getup_roll_delay
	dodgeRollSpeedLength: 1,
	getupRollSpeed: 15.5,
	getupRollSpeedStartFrame: 2,
	getupRollSpeedLength: 1,
	ledgeRollSpeed: 14,
	ledgeRollSpeedStartFrame: 11, // SSF2: climb_roll_delay
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
	shieldCrossupThreshold: 16,
	shieldFrontNineSliceContent: "global::vfx.vfx_shield_front",
	shieldFrontXOffset: 10.5,
	shieldFrontYOffset: 4,
	shieldFrontWidth: 53,
	shieldFrontHeight: 93,
	shieldBackNineSliceContent: "global::vfx.vfx_shield_back",
	shieldBackXOffset: 12.5,
	shieldBackYOffset: 4,
	shieldBackWidth: 49,
	shieldBackHeight: 93,

	//VOICE STATS
	attackVoiceIds: [],  // TODO: populate from per-move attackVoiceN_id fields
	hurtLightVoiceIds: [],
	hurtMediumVoiceIds: ["krystal_hurt2", "krystal_hurt1"],
	hurtHeavyVoiceIds: ["krystal_hurt11", "krystal_hurt12"],
	koVoiceIds: ["krystal_dead1", "krystal_dead2", "krystal_hurt1", "krystal_star"],
	attackVoiceSilenceRate: 0.5,
	hurtLightSilenceRate: 1,
	hurtMediumSilenceRate: 0.5,
	hurtHeavySilenceRate: 0,
	koVoiceSilenceRate: 0,
}