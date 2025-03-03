@tool
extends LPCAnimationDataBase
class_name SproutLandsData

func _init() -> void:
	resource_name = "SproutLandsData"
	_setup_data()

func _setup_data() -> void:
	base_animation_size = 48
	
	available_animations = [
		"idle",
		"walk",
		"tiling",
		"chopping",
		"watering",
	]

	required_spritesheets = {
		"idle": "sprout_lands_walk_idle",
		"walk": "sprout_lands_walk_idle",
		"tiling": "sprout_lands_actions",
		"chopping": "sprout_lands_actions",
		"watering": "sprout_lands_actions",
	}

	available_directions = {
		"idle" : {"south": 0, "north": 1, "west": 2,"east": 3},
		"walk" : {"south": 0, "north": 1, "west": 2,"east": 3},
		"tiling" : {"south": 0, "north": 1, "west": 2,"east": 3},
		"chopping" : {"south": 0, "north": 1, "west": 2,"east": 3},
		"watering" : {"south": 0, "north": 1, "west": 2,"east": 3},
	}

	animation_frame_counts = {
		"idle": 2,
		"walk": 2,
		"tiling": 2,
		"chopping": 2,
		"watering": 2,
	}

	initial_sprite_indices = {
		"idle": 0,
		"walk": 2,
		"tiling": 0,
		"chopping": 0,
		"watering": 0,
	}

	animation_loops = {
		"idle": true,
		"walk": true,
		"tiling": true,
		"chopping": true,
		"watering": true,
	}

	animation_speeds = {
		"idle": 4,
		"walk": 4,
		"tiling": 4,
		"chopping": 4,
		"watering": 4,
	}

	animation_rows = {
		"idle": 0,
		"walk": 0,
		"tiling": 0,
		"chopping": 4,
		"watering": 8,
	}

	frame_sizes = {
		"idle": 48,
		"walk": 48,
		"tiling": 48,
		"chopping": 48,
		"watering": 48,
	}

	custom_frames = {
	}
