@tool
extends Node2D

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCAnimation = LPCAnimation.IDLE_DOWN
@export var SpriteType: SpriteTypeEnum

var unified_sprite_sheet:LPCSpriteSheet
var AnimationNames:Array
var sprite_frames:SpriteFrames
var animatedSprite: AnimatedSprite2D

enum SpriteTypeEnum {
	Normal,
	OversizeRod,
	OversizeThrust,
	OversizeSlash,
	OversizeWhip
}

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
	IDLE_RIGHT,
	HURT_DOWN_LAST
}

func _ready():
	sprite_frames = SpriteFrames.new()
	animatedSprite = AnimatedSprite2D.new()
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		
func play(animation: LPCAnimation):
	if sprite_frames.has_animation(AnimationNames[animation]):
		animatedSprite.visible = true
		animatedSprite.play(AnimationNames[animation])
	else:
		animatedSprite.visible = false

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()

func LoadAnimations():
	AnimationNames = LPCAnimation.keys()
	var children = get_children();
	for child in children:
		remove_child(child)
	if not await GenerateSpriteSheet():
		push_error("!")
		return
	animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite_frames.remove_animation("default")
	for animationData in AnimationData():
		AddAnimation(animationData)
	animatedSprite.frames = sprite_frames
	add_child(animatedSprite)
	animatedSprite.owner = get_tree().edited_scene_root
	
	play(DefaultAnimation)

func GenerateSpriteSheet() -> bool:
	if 0 == SpriteSheets.size():
		push_error("No detected LPCSpriteSheets.")
		return false
	if SpriteSheets[0] == null:
		push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
		return false
	if 1 == SpriteSheets.size():
		unified_sprite_sheet = SpriteSheets[0]
		return true
		
	var size := Vector2(1536, 2880)
	var viewport = SubViewport.new()
	viewport.disable_3d = true
	viewport.size = size
	viewport.transparent_bg = true
	
	for sheet in SpriteSheets:
		if sheet.SpriteSheet == null:
			continue
		var sprite:Sprite2D = Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(sheet.SpriteSheet.get_image())
		sprite.offset = Vector2(sprite.texture.get_size().x/2, sprite.texture.get_size().y/2)
		viewport.add_child(sprite)
		
	add_child(viewport)
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE 
	await RenderingServer.frame_post_draw
	unified_sprite_sheet = LPCSpriteSheet.new()
	var texture := viewport.get_texture()
	
	unified_sprite_sheet.SpriteSheet = texture
	
	texture.get_image().save_png("res://output-sample.png")

	return true

func AddAnimation(animationData:LPCAnimationData):
	if unified_sprite_sheet == null || unified_sprite_sheet.SpriteSheet == null:
		return
	if sprite_frames.has_animation(animationData.Name):
		sprite_frames.clear(animationData.Name)
	
	sprite_frames.add_animation(animationData.Name)
	for col in range(animationData.FrameCount):
		if "WALK" in animationData.Name && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = unified_sprite_sheet.SpriteSheet
		var spriteSize:int = Size()
		atlasTexture.region = Rect2(spriteSize*(col+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)			
		sprite_frames.add_frame(animationData.Name, atlasTexture, 0.5)
	sprite_frames.set_animation_loop(animationData.Name, animationData.Loop)

var NormalAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(7,"CAST_UP",0, 0,false),
	LPCAnimationData.new(7,"CAST_LEFT",1, 0,false),
	LPCAnimationData.new(7,"CAST_DOWN",2, 0,false),
	LPCAnimationData.new(7,"CAST_RIGHT",3, 0,false),
	LPCAnimationData.new(8,"THRUST_UP",4, 0,false),
	LPCAnimationData.new(8,"THRUST_LEFT",5, 0,false),
	LPCAnimationData.new(8,"THRUST_DOWN",6, 0,false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7, 0,false),
	LPCAnimationData.new(8,"WALK_UP",8, 0,true),
	LPCAnimationData.new(8,"WALK_LEFT",9, 0,true),
	LPCAnimationData.new(8,"WALK_DOWN",10, 0,true),
	LPCAnimationData.new(8,"WALK_RIGHT",11, 0,true),
	LPCAnimationData.new(6,"SLASH_UP",12, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",13, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",14, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",15, 0,false),
	LPCAnimationData.new(6,"WHIP_UP",12, 0,false),
	LPCAnimationData.new(6,"WHIP_LEFT",13, 0,false),
	LPCAnimationData.new(6,"WHIP_DOWN",14, 0,false),
	LPCAnimationData.new(6,"WHIP_RIGHT",15, 0,false),
	LPCAnimationData.new(13,"SHOOT_UP",16, 0,false),
	LPCAnimationData.new(13,"SHOOT_LEFT",17, 0,false),
	LPCAnimationData.new(13,"SHOOT_DOWN",18, 0,false),
	LPCAnimationData.new(13,"SHOOT_RIGHT",19, 0,false),
	LPCAnimationData.new(6,"HURT_DOWN",20, 0,false),
	LPCAnimationData.new(1,"IDLE_UP",8, 0,false),
	LPCAnimationData.new(1,"IDLE_LEFT",9, 0,false),
	LPCAnimationData.new(1,"IDLE_DOWN",10, 0,false),
	LPCAnimationData.new(1,"IDLE_RIGHT",11, 0,false),
	LPCAnimationData.new(1,"HURT_DOWN_LAST",20, 5,false),
]
var SlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",0, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",1, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",2, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",3, 0,false),
]
var ThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"THRUST_UP",0, 0,false),
	LPCAnimationData.new(6,"THRUST_LEFT",1, 0,false),
	LPCAnimationData.new(6,"THRUST_DOWN",2, 0,false),
	LPCAnimationData.new(6,"THRUST_RIGHT",3, 0,false),
]
var RodAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"ROD_UP",0, 0,false),
	LPCAnimationData.new(6,"ROD_LEFT",1, 0,false),
	LPCAnimationData.new(6,"ROD_DOWN",2, 0,false),
	LPCAnimationData.new(6,"ROD_RIGHT",3, 0,false),
]
var WhipAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(8,"WHIP_UP",0, 0,false),
	LPCAnimationData.new(8,"WHIP_LEFT",1, 0,false),
	LPCAnimationData.new(8,"WHIP_DOWN",2, 0,false),
	LPCAnimationData.new(8,"WHIP_RIGHT",3, 0,false),
]

func Size() -> int:
	match SpriteType:
		SpriteTypeEnum.Normal:
			return 64
		_:
			return 192
func AnimationData() -> Array[LPCAnimationData]:
	match SpriteType:
		SpriteTypeEnum.Normal:
			return NormalAnimationData
		SpriteTypeEnum.OversizeRod:
			return RodAnimationData
		SpriteTypeEnum.OversizeThrust:
			return ThrustAnimationData
		SpriteTypeEnum.OversizeSlash:
			return SlashAnimationData
		SpriteTypeEnum.OversizeWhip:
			return WhipAnimationData
		_:
			return NormalAnimationData
