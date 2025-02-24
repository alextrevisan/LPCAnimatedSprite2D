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
	]

	required_spritesheets = [
		"sprout_lands",
	]

	available_directions = {
		"idle" : {"south": 0, "north": 1, "west": 2,"east": 3},
		"walk" : {"south": 0, "north": 1, "west": 2,"east": 3},
	}

	animation_frame_counts = {
		"idle": 2,
		"walk": 2,
	}

	initial_sprite_indices = {
		"idle": 0,
		"walk": 2,
	}

	animation_loops = {
		"idle": true,
		"walk": true,
	}

	animation_speeds = {
		"idle": 4,
		"walk": 4,
	}

	animation_rows = {
		"idle": 0,
		"walk": 0,
	}

	frame_sizes = {
		"idle": 48,
		"walk": 48,
	}

	custom_frames = {
	}
