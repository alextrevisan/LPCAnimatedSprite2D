@tool
extends Node2D

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]

const Framerate:float = 10.0

const AnimationsFrameCount:Array[int] = [
	7,
	7,
	7,
	7,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	6,
	6,
	6,
	6,
	13,
	13,
	13,
	13,
	6,
	1,
	1,
	1,
	1
]
const AnimationsName:Array[String] = [
	"CAST_UP",
	"CAST_LEFT",
	"CAST_DOWN",
	"CAST_RIGHT",
	"THRUST_UP",
	"THRUST_LEFT",
	"THRUST_DOWN",
	"THRUST_RIGHT",
	"WALK_UP",
	"WALK_LEFT",
	"WALK_DOWN",
	"WALK_RIGHT",
	"SLASH_UP",
	"SLASH_LEFT",
	"SLASH_DOWN",
	"SLASH_RIGHT",
	"SHOOT_UP",
	"SHOOT_LEFT",
	"SHOOT_DOWN",
	"SHOOT_RIGHT",
	"HURT_DOWN",
	"IDLE_UP",
	"IDLE_LEFT",
	"IDLE_DOWN",
	"IDLE_RIGHT"
]
const AnimationsRow:Array[int] = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	8,
	9,
	10,
	11
]
#yeah, unfortunatly repeating above string list
@export_enum("CAST_UP",
	"CAST_LEFT",
	"CAST_DOWN",
	"CAST_RIGHT",
	"THRUST_UP",
	"THRUST_LEFT",
	"THRUST_DOWN",
	"THRUST_RIGHT",
	"WALK_UP",
	"WALK_LEFT",
	"WALK_DOWN",
	"WALK_RIGHT",
	"SLASH_UP",
	"SLASH_LEFT",
	"SLASH_DOWN",
	"SLASH_RIGHT",
	"SHOOT_UP",
	"SHOOT_LEFT",
	"SHOOT_DOWN",
	"SHOOT_RIGHT",
	"HURT_DOWN",
	"IDLE_UP",
	"IDLE_LEFT",
	"IDLE_DOWN",
	"IDLE_RIGHT") var DefaultAnimation:int
	
enum LPCAnimation {
	CAST_UP,
	CAST_LEFT,
	CAST_DOWN,
	CAST_RIGHT,
	THRUST_UP,
	THRUST_LEFT,
	THRUST_DOWN,
	THRUST_RIGHT,
	WALK_UP,
	WALK_LEFT,
	WALK_DOWN,
	WALK_RIGHT,
	SLASH_UP,
	SLASH_LEFT,
	SLASH_DOWN,
	SLASH_RIGHT,
	SHOOT_UP,
	SHOOT_LEFT,
	SHOOT_DOWN,
	SHOOT_RIGHT,
	HURT_DOWN,
	IDLE_UP,
	IDLE_LEFT,
	IDLE_DOWN,
	IDLE_RIGHT
}

func play(animation: LPCAnimation):
	var sprites = get_children()
	for sprite in sprites:
		sprite.play(AnimationsName[animation])

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()
	

func LoadAnimations():
	var children = get_children();
	for child in children:
		remove_child(child)
		
	for spriteSheet in SpriteSheets:
		var animatedSprite = AnimatedSprite2D.new()
		animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var spriteFrames = CreateSprites(spriteSheet.SpriteSheet)
		animatedSprite.frames = spriteFrames
		add_child(animatedSprite)
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = get_tree().edited_scene_root
		animatedSprite.play(AnimationsName[DefaultAnimation])



func CreateSprites(spriteSheet:Texture):
	var spriteFrames = SpriteFrames.new()
	spriteFrames.remove_animation("default")
	for animationIndex in AnimationsName.size():
		var animationName = AnimationsName[animationIndex]
		var animationFrameCount = AnimationsFrameCount[animationIndex]
		var animationSpriteRow = AnimationsRow[animationIndex]
		AddAnimation(spriteSheet, spriteFrames, animationName, 
					animationFrameCount,
					animationSpriteRow)
	return spriteFrames
	
func AddAnimation(spriteSheet:Texture, spriteFrames:SpriteFrames,animationName:String, animationCount:int, animationRow:int):
	#print("adding animations")
	if spriteSheet == null:
		return
	if spriteFrames.has_animation(animationName):
		spriteFrames.clear(animationName)
	#print(animationName)
	
	spriteFrames.add_animation(animationName)
	for col in range(animationCount):
		if "WALK" in animationName && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet
		atlasTexture.region = Rect2(64*col,64*animationRow,64,64)
		
		spriteFrames.add_frame(animationName, atlasTexture, 0.5)
	return spriteFrames
