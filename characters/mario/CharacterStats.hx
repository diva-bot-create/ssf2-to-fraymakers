// CharacterStats for Mario (converted from SSF2)
// SSF2 movement stats are approximate — verify against original character feel.
{
	spriteContent: self.getResource().getContent("mario"),

	//GENERIC STATS
	baseScaleX: 1.0,
	baseScaleY: 1.0,
	weight: 100,
	gravity: 0.8,
	shortHopSpeed: 8.25,   // TODO: tune from SSF2
	jumpSpeed: 15,
	jumpSpeedForwardInitialXSpeed: 3,
	jumpSpeedBackwardInitialXSpeed: -3,
	doubleJumpSpeeds: [13.0], // TODO: SSF2 double jump stats
	terminalVelocity: 9.25,
	fastFallSpeed: 13.75,
	friction: 0.57,
	walkSpeedInitial: 1.0,
	walkSpeedAcceleration: 0.3,
	walkSpeedCap: 3.25,
	dashSpeed: 7.5,
	runSpeedInitial: 4.72,
	runSpeedAcceleration: 0.45,
	runSpeedCap: 7.5,
	groundSpeedAcceleration: 0.45,
	groundSpeedCap: 7.5,
	aerialSpeedAcceleration: 0.41,
	aerialSpeedCap: 6.53,
	aerialFriction: 0.22,

	wallJumpXSpeed: 8.5,
	wallJumpYSpeed: 14,
	wallJumpLimit: 1,

	//ECB STATS (adjust to match SSF2 collision box sizes)
	floorHeadPosition: 86,
	floorHipWidth: 29,
	floorHipXOffset: 0,
	floorHipYOffset: 0,
	floorFootPosition: 0,
	aerialHeadPosition: 86,
	aerialHipWidth: 29,
	aerialHipXOffset: 0,
	aerialHipYOffset: 0,
	aerialFootPosition: 25,

	//VOICE STATS
	attackVoiceIds: [],  // TODO: add SSF2 voice clip IDs
	hurtLightVoiceIds: [],
	hurtMediumVoiceIds: [],
	hurtHeavyVoiceIds: [],
	koVoiceIds: [],
	attackVoiceSilenceRate: 0.5,
	hurtLightSilenceRate: 1,
	hurtMediumSilenceRate: 0.5,
	hurtHeavySilenceRate: 0,
	koVoiceSilenceRate: 0,
}
