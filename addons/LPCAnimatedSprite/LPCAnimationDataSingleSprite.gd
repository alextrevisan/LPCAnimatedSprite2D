@tool
class_name LPCAnimationDataSingleSprite extends LPCAnimationDataBase

func _init() -> void:
	resource_name = "LPCAnimationDataSingleSprite"
	_setup_data()

func _setup_data() -> void:
	base_animation_size = 64
	
	available_animations = [
		"spellcast",
		"thrust",
		"walk",
		"slash",
		"shoot",
		"hurt",
		"climb",
		"idle",
		"jump",
		"sit",
		"emote",
		"run",
		"combat_idle",
		"backslash",
		"halfslash",
		"slash_oversize",
		"slash_reverse_oversize",
		"thrust_oversize"
	]

	required_spritesheets = {
		"spellcast": "single",
		"thrust": "single",
		"walk": "single",
		"slash": "single",
		"shoot": "single",
		"hurt": "single",
		"climb": "single",
		"idle": "single",
		"jump": "single",
		"sit": "single",
		"emote": "single",
		"run": "single",
		"combat_idle": "single",
		"backslash": "single",
		"halfslash": "single",
		"slash_oversize": "single",
		"slash_reverse_oversize": "single",
		"thrust_oversize": "single"
	}

	available_directions = {
		"spellcast" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"thrust" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"walk" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"slash" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"shoot" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"hurt" : {"south": 0},
		"climb" : {"north": 0},
		"idle" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"jump" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"sit" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"emote" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"run" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"combat_idle" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"backslash" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"halfslash" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"slash_oversize" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"slash_reverse_oversize" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"thrust_oversize" : {"north": 0, "east": 1, "south": 2,"west": 3}
	}

	animation_frame_counts = {
		"spellcast": 7,
		"thrust": 8,
		"walk": 9,
		"slash": 6,
		"shoot": 13,
		"hurt": 6,
		"climb": 6,
		"idle": 2,
		"jump": 5,
		"sit": 3,
		"emote": 3,
		"run": 8,
		"combat_idle": 2,
		"backslash": 13,
		"halfslash": 7,
		"slash_oversize": 6,
		"slash_reverse_oversize": 6,
		"thrust_oversize": 6
	}

	initial_sprite_indices = {
		"spellcast": 0,
		"thrust": 0,
		"walk": 1,
		"slash": 0,
		"shoot": 0,
		"hurt": 0,
		"climb": 0,
		"idle": 0,
		"jump": 0,
		"sit": 0,
		"emote": 0,
		"run": 0,
		"combat_idle": 0,
		"backslash": 0,
		"halfslash": 0,
		"slash_oversize": 0,
		"slash_reverse_oversize": 0,
		"thrust_oversize": 0
	}

	animation_loops = {
		"spellcast": true,
		"thrust": true,
		"walk": true,
		"slash": true,
		"shoot": true,
		"hurt": false,
		"climb": true,
		"idle": true,
		"jump": true,
		"sit": true,
		"emote": true,
		"run": true,
		"combat_idle": true,
		"backslash": true,
		"halfslash": true,
		"slash_oversize": true,
		"slash_reverse_oversize": true,
		"thrust_oversize": true
	}

	animation_speeds = {
		"spellcast": 8,
		"thrust": 8,
		"walk": 8,
		"slash": 8,
		"shoot": 8,
		"hurt": 8,
		"climb": 8,
		"idle": 8,
		"jump": 8,
		"sit": 8,
		"emote": 8,
		"run": 8,
		"combat_idle": 8,
		"backslash": 8,
		"halfslash": 8,
		"slash_oversize": 8,
		"slash_reverse_oversize": 8,
		"thrust_oversize": 8
	}

	animation_rows = {
		"spellcast": 0,
		"thrust": 4,
		"walk": 8,
		"slash": 12,
		"shoot": 16,
		"hurt": 20,
		"climb": 21,
		"idle": 22,
		"jump": 26,
		"sit": 30,
		"emote": 34,
		"run": 38,
		"combat_idle": 42,
		"backslash": 46,
		"halfslash": 50,
		"slash_oversize": 54,
		"slash_reverse_oversize": 66,
		"thrust_oversize": 78
	}

	frame_sizes = {
		"spellcast": 64,
		"thrust": 64,
		"walk": 64,
		"slash": 64,
		"shoot": 64,
		"hurt": 64,
		"climb": 64,
		"idle": 64,
		"jump": 64,
		"sit": 64,
		"emote": 64,
		"run": 64,
		"combat_idle": 64,
		"backslash": 64,
		"halfslash": 64,
		"slash_oversize": 192,
		"slash_reverse_oversize": 192,
		"thrust_oversize": 192
	}

	custom_frames = {
		"walk": [1, 2, 3, 4, 5, 6, 7, 8],
		"idle": [0, 0, 1],
		"jump": [0, 1, 2, 3, 4, 1],
		"sit": [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2],
		"emote": [0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2],
		"combat_idle": [0, 0, 1],
		"backslash": [0, 1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12]
	}
