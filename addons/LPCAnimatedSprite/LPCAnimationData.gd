@tool
class_name LPCAnimationData extends Resource

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

@export var animation_loops: Dictionary = {
	spellcast = true,
	thrust = true,
	walk = true,
	slash = true,
	shoot = true,
	hurt = true,
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

@export var animation_speeds: Dictionary = {
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

@export var animation_rows: Dictionary = {
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


@export var frame_sizes: Dictionary = {
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
