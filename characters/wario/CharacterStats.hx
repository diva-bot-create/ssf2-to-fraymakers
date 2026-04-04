// CharacterStats for Wario
// Source: WarioExt.as → getOwnStats()
{
	spriteContent: self.getResource().getContent("wario"),

	//GENERIC STATS
	baseScaleX: 1.0,
	baseScaleY: 1.0,
	//GENERIC STATS
	weight: 107, // SSF2: weight1
	gravity: 1.55, // SSF2: gravity
	shortHopSpeed: 11.6, // SSF2: shortHopSpeed
	jumpSpeed: 18.4, // SSF2: jumpSpeed
	jumpSpeedForwardInitialXSpeed: 3,
	jumpSpeedBackwardInitialXSpeed: -3,
	doubleJumpSpeeds: [16.68], // SSF2: jumpSpeedMidair → array
	terminalVelocity: 12.91, // SSF2: max_ySpeed
	fastFallSpeed: 14, // SSF2: fastFallSpeed
	friction: 0.89, // SSF2: abs(decel_rate)
	walkSpeedInitial: 0.34, // SSF2: accel_start
	walkSpeedAcceleration: 0.34, // SSF2: accel_start
	walkSpeedCap: 5.93, // SSF2: norm_xSpeed
	dashSpeed: 7.93, // SSF2: accel_start_dash (approx) (estimated as 90% of max_xSpeed)
	runSpeedInitial: 5.93, // SSF2: norm_xSpeed
	runSpeedAcceleration: 0.91, // SSF2: accel_rate
	runSpeedCap: 8.81, // SSF2: max_xSpeed
	groundSpeedAcceleration: 0.91, // SSF2: accel_rate
	groundSpeedCap: 8.81, // SSF2: max_xSpeed
	aerialSpeedAcceleration: 1.75, // SSF2: accel_rate_air
	aerialSpeedCap: 8.81, // SSF2: max_xSpeed
	aerialFriction: 0.3, // SSF2: abs(decel_rate_air)
	wallJumpXSpeed: 8.5,
	wallJumpYSpeed: 14,
	wallJumpLimit: 1,

	//ECB STATS
	floorHeadPosition: 49, // SSF2: height
	floorHipWidth: 31, // SSF2: width
	floorHipXOffset: 0,
	floorHipYOffset: 0,
	floorFootPosition: 0,
	aerialHeadPosition: 49, // SSF2: height
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
	techRollSpeedStartFrame: 4, // SSF2: tech_roll_delay
	techRollSpeedLength: 1,
	dodgeRollSpeed: 15, // SSF2: dodgeSpeed
	dodgeRollSpeedStartFrame: 5, // SSF2: getup_roll_delay
	dodgeRollSpeedLength: 1,
	getupRollSpeed: 15.5,
	getupRollSpeedStartFrame: 2,
	getupRollSpeedLength: 1,
	ledgeRollSpeed: 14,
	ledgeRollSpeedStartFrame: 6, // SSF2: climb_roll_delay
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
	hurtMediumVoiceIds: ["wario_hurt1", "wario_hurt2"],
	hurtHeavyVoiceIds: ["wario_hurtBad1", "wario_hurtBad2"],
	koVoiceIds: ["wario_death1", "wario_death2", "wario_hurt1", "wario_starko"],
	attackVoiceSilenceRate: 0.5,
	hurtLightSilenceRate: 1,
	hurtMediumSilenceRate: 0.5,
	hurtHeavySilenceRate: 0,
	koVoiceSilenceRate: 0,
}