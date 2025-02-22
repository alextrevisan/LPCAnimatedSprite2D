class_name LPCAnimationData extends LPCAnimationDataBase

func _init() -> void:
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
		"halfslash"
	]

	required_spritesheets = [
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
		"halfslash"
	]

	available_directions = {
		"spellcast" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"thrust" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"walk" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"slash" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"shoot" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"hurt" : {"south": 0},
		"climb" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"idle" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"jump" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"sit" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"emote" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"run" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"combat_idle" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"backslash" : {"north": 0, "east": 1, "south": 2,"west": 3},
		"halfslash" : {"north": 0, "east": 1, "south": 2,"west": 3}
	}

	animation_frame_counts = {
		spellcast = 7,
		thrust = 8,
		walk = 9,
		slash = 6,
		shoot = 13,
		hurt = 6,
		climb = 6,
		idle = 2,
		jump = 5,
		sit = 3,
		emote = 3,
		run = 8,
		combat_idle = 2,
		backslash = 13,
		halfslash = 7
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
		"halfslash": 0
	}

	animation_loops = {
		spellcast = true,
		thrust = true,
		walk = true,
		slash = true,
		shoot = true,
		hurt = false,
		climb = true,
		idle = true,
		jump = true,
		sit = true,
		emote = true,
		run = true,
		combat_idle = true,
		backslash = true,
		halfslash = true
	}

	animation_speeds = {
		spellcast = 8,
		thrust = 8,
		walk = 8,
		slash = 8,
		shoot = 8,
		hurt = 8,
		climb = 8,
		idle = 8,
		jump = 8,
		sit = 8,
		emote = 8,
		run = 8,
		combat_idle = 8,
		backslash = 8,
		halfslash = 8
	}

	animation_rows = {
		spellcast = 0,
		thrust = 0,
		walk = 0,
		slash = 0,
		shoot = 0,
		hurt = 0,
		climb = 0,
		idle = 0,
		jump = 0,
		sit = 0,
		emote = 0,
		run = 0,
		combat_idle = 0,
		backslash = 0,
		halfslash = 0
	}


	frame_sizes = {
		spellcast = 64,
		thrust = 64,
		walk = 64,
		slash = 64,
		shoot = 64,
		hurt = 64,
		climb = 64,
		idle = 64,
		jump = 64,
		sit = 64,
		emote = 64,
		run = 64,
		combat_idle = 64,
		backslash = 64,
		halfslash = 64
	}

	custom_frames = {
		"backslash": [0,1,2,3,4,5,7,8,9,10,11,12],
	}
