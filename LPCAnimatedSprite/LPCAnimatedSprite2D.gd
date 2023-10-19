@tool
extends Node2D

class_name LPCAnimatedSprite2D

const Framerate:float = 10.0
var AnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(7,"CAST_UP",0,false),
	LPCAnimationData.new(7,"CAST_LEFT",1,false),
	LPCAnimationData.new(7,"CAST_DOWN",2,false),
	LPCAnimationData.new(7,"CAST_RIGHT",3,false),
	LPCAnimationData.new(8,"THRUST_UP",4,false),
	LPCAnimationData.new(8,"THRUST_LEFT",5,false),
	LPCAnimationData.new(8,"THRUST_DOWN",6,false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7,false),
	LPCAnimationData.new(8,"WALK_UP",8,true),
	LPCAnimationData.new(8,"WALK_LEFT",9,true),
	LPCAnimationData.new(8,"WALK_DOWN",10,true),
	LPCAnimationData.new(8,"WALK_RIGHT",11,true),
	LPCAnimationData.new(6,"SLASH_UP",12,false),
	LPCAnimationData.new(6,"SLASH_LEFT",13,false),
	LPCAnimationData.new(6,"SLASH_DOWN",14,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",15,false),
	LPCAnimationData.new(13,"SHOOT_UP",16,false),
	LPCAnimationData.new(13,"SHOOT_LEFT",17,false),
	LPCAnimationData.new(13,"SHOOT_DOWN",18,false),
	LPCAnimationData.new(13,"SHOOT_RIGHT",19,false),
	LPCAnimationData.new(6,"HURT_DOWN",20,false),
	LPCAnimationData.new(1,"IDLE_UP",8,false),
	LPCAnimationData.new(1,"IDLE_LEFT",9,false),
	LPCAnimationData.new(1,"IDLE_DOWN",10,false),
	LPCAnimationData.new(1,"IDLE_RIGHT",11,false)
]

@export var SpriteSheets:Array[LPCSpriteSheet]

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

func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		
func play(animation: LPCAnimation):
	var sprites = get_children()
	for sprite in sprites:
		sprite.play(AnimationData[animation].Name)

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
		animatedSprite.play(AnimationData[DefaultAnimation].Name)

func CreateSprites(spriteSheet:Texture):
	var spriteFrames = SpriteFrames.new()
	spriteFrames.remove_animation("default")
	for animationIndex in AnimationData.size():
		var data = AnimationData[animationIndex]
		var animationFrameCount = AnimationData[animationIndex].FrameCount
		var animationSpriteRow = AnimationData[animationIndex].Row
		var animationLoop = AnimationData[animationIndex].Loop
		AddAnimation(spriteSheet, spriteFrames, AnimationData[animationIndex])
	return spriteFrames
	
func AddAnimation(spriteSheet:Texture, spriteFrames:SpriteFrames, animationData:LPCAnimationData):
	if spriteSheet == null:
		return
	if spriteFrames.has_animation(animationData.Name):
		spriteFrames.clear(animationData.Name)
	
	spriteFrames.add_animation(animationData.Name)
	for col in range(animationData.FrameCount):
		if "WALK" in animationData.Name && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet
		atlasTexture.region = Rect2(64*col,64*animationData.Row,64,64)
		spriteFrames.add_frame(animationData.Name, atlasTexture, 0.5)
	spriteFrames.set_animation_loop(animationData.Name, animationData.Loop)
	return spriteFrames
