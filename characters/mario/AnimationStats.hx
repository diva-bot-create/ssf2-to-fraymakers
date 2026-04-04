// AnimationStats for Mario (converted from SSF2)
// Fill in SSF2-specific timing and flags below.
{
	//MOTIONS
	stand: {},
	stand_turn: {},
	walk_in: {},
	walk_loop: {},
	walk_out: {},
	dash: {},
	run: {},
	run_turn: {},
	skid: {},
	jump_squat: {},
	jump_in: {},
	jump_midair: {},
	jump_out: {},
	fall_loop: {},
	fall_special: {},
	land_light: {},
	land_heavy: {},
	crouch_in: {},
	crouch_loop: {},
	crouch_out: {},

	//LIGHT ATTACKS
	jab1: {},
	jab2: {},
	jab3: {},
	dash_attack: {xSpeedConservation: 1},
	tilt_forward: {},
	tilt_up: {},
	tilt_down: {},

	//STRONG ATTACKS
	strong_forward_in: {},
	strong_forward_charge: {},
	strong_forward_attack: {},
	strong_up_in: {},
	strong_up_charge: {},
	strong_up_attack: {},
	strong_down_in: {},
	strong_down_charge: {},
	strong_down_attack: {},

	//AERIAL ATTACKS
	aerial_neutral: {landAnimation:"aerial_neutral_land"},
	aerial_forward: {landAnimation:"aerial_forward_land"},
	aerial_back: {landAnimation:"aerial_back_land"},
	aerial_up: {landAnimation:"aerial_up_land"},
	aerial_down: {landAnimation:"aerial_down_land", xSpeedConservation: 0.5, ySpeedConservation: 0.5, gravityMultiplier:0, allowMovement: false},

	//AERIAL ATTACK LANDING
	aerial_neutral_land: {},
	aerial_forward_land: {},
	aerial_back_land: {},
	aerial_up_land: {},
	aerial_down_land: {xSpeedConservation: 0},

	//SPECIAL ATTACKS
	special_neutral: {},
	special_neutral_air: {},
	special_up: {leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, nextState:CState.FALL_SPECIAL},
	special_up_air: {leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, nextState:CState.FALL_SPECIAL, landType:LandType.TOUCH},
	special_down: {allowFastFall:false, leaveGroundCancel:false, xSpeedConservation:0, ySpeedConservation:0},
	special_side: {allowFastFall: false, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: "land_heavy", singleUse:true},
	special_side_air: {allowFastFall: false, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: "land_heavy", singleUse:true},

	//THROWS
	grab: {},
	grab_hold: {},
	throw_forward: {},
	throw_back: {},
	throw_up: {},
	throw_down: {},

	//MISC
	ledge_attack: {},
	crash_attack: {},
	emote: {}
}
