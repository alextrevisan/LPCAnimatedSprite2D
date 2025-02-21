@tool
extends Resource
class_name LPCAnimationData

const FRAME_SIZE = 64

@export var available_animations: Array[String] = [
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

@export var required_spritesheets: Array[String] = [
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



@export var available_directions: Dictionary = {
	"north": 0,
	"east": 1,
	"south": 2,
	"west": 3
}

@export var animation_frame_counts: Dictionary = {
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

@export var initial_sprite_indices: Dictionary = {
	"spellcast" = 0,
	"thrust" = 0,
	"walk" = 1,
	"slash" = 0,
	"shoot" = 0,
	"hurt" = 0,
	"climb" = 0,
	"idle" = 0,
	"jump" = 0,
	"sit" = 0,
	"emote" = 0,
	"run" = 0,
	"combat_idle" = 0,
	"backslash" = 0,
	"halfslash" = 0
}
