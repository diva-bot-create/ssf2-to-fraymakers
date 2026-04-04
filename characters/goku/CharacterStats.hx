// CharacterStats for Goku
// Source: GokuExt.as → getOwnStats()
{
	spriteContent: self.getResource().getContent("goku"),

	//GENERIC STATS
	baseScaleX: 1.0,
	baseScaleY: 1.0,
	//GENERIC STATS
	weight: 103, // SSF2: weight1
	gravity: 1.3, // SSF2: gravity
	shortHopSpeed: 9.5, // SSF2: shortHopSpeed
	jumpSpeed: 15, // SSF2: jumpSpeed
	jumpSpeedForwardInitialXSpeed: 3,
	jumpSpeedBackwardInitialXSpeed: -3,
	doubleJumpSpeeds: [15], // SSF2: jumpSpeedMidair → array
	terminalVelocity: 14.6, // SSF2: max_ySpeed
	fastFallSpeed: 16, // SSF2: fastFallSpeed
	friction: 1.59, // SSF2: abs(decel_rate)
	walkSpeedInitial: 0.286, // SSF2: accel_start
	walkSpeedAcceleration: 0.286, // SSF2: accel_start
	walkSpeedCap: 7, // SSF2: norm_xSpeed
	dashSpeed: 10.53, // SSF2: accel_start_dash (approx) (estimated as 90% of max_xSpeed)
	runSpeedInitial: 7, // SSF2: norm_xSpeed
	runSpeedAcceleration: 1, // SSF2: accel_rate
	runSpeedCap: 11.7, // SSF2: max_xSpeed
	groundSpeedAcceleration: 1, // SSF2: accel_rate
	groundSpeedCap: 11.7, // SSF2: max_xSpeed
	aerialSpeedAcceleration: 0.7, // SSF2: accel_rate_air
	aerialSpeedCap: 11.7, // SSF2: max_xSpeed
	aerialFriction: 0.15, // SSF2: abs(decel_rate_air)
	wallJumpXSpeed: 8.5,
	wallJumpYSpeed: 14,
	wallJumpLimit: 1,

	//ECB STATS
	floorHeadPosition: 52, // SSF2: height
	floorHipWidth: 20, // SSF2: width
	floorHipXOffset: 0,
	floorHipYOffset: 0,
	floorFootPosition: 0,
	aerialHeadPosition: 52, // SSF2: height
	aerialHipWidth: 20, // SSF2: width
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
	dodgeRollSpeed: 18, // SSF2: dodgeSpeed
	dodgeRollSpeedStartFrame: 5, // SSF2: getup_roll_delay
	dodgeRollSpeedLength: 1,
	getupRollSpeed: 15.5,
	getupRollSpeedStartFrame: 2,
	getupRollSpeedLength: 1,
	ledgeRollSpeed: 14,
	ledgeRollSpeedStartFrame: 9, // SSF2: climb_roll_delay
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
	hurtMediumVoiceIds: ["ssf2_snd_vfx_goku_hurt01", "ssf2_snd_vfx_goku_hurt02"],
	hurtHeavyVoiceIds: ["ssf2_snd_vfx_goku_hurtBad01", "ssf2_snd_vfx_goku_hurtBad02"],
	koVoiceIds: ["ssf2_snd_vfx_goku_dead01", "ssf2_snd_vfx_goku_dead02", "ssf2_snd_vfx_goku_hurtBad01", "ssf2_snd_vfx_goku_starKO"],
	attackVoiceSilenceRate: 0.5,
	hurtLightSilenceRate: 1,
	hurtMediumSilenceRate: 0.5,
	hurtHeavySilenceRate: 0,
	koVoiceSilenceRate: 0,
}