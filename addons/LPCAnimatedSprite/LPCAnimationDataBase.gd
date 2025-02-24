@tool
extends Resource
class_name LPCAnimationDataBase

# This line makes the script itself a resource
func _init():
	resource_name = "LPCAnimationDataBase"
	
@export var base_animation_size: int = 64

@export var available_animations: Array[String] = []

@export var required_spritesheets: Dictionary = {}

@export var available_directions: Dictionary = {}

@export var animation_frame_counts: Dictionary = {}

@export var initial_sprite_indices: Dictionary = {}

@export var animation_loops: Dictionary = {}

@export var animation_speeds: Dictionary = {}

@export var animation_rows: Dictionary = {}

@export var frame_sizes: Dictionary = {}

@export var custom_frames: Dictionary = {}
