@tool
extends Node

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCEnum.LPCAnimation = LPCEnum.LPCAnimation.IDLE_DOWN
@export var NodeType:LPCEnum.ESpriteNodeType = LPCEnum.ESpriteNodeType.Sprite_2D

@export_group("2D Properties")
@export var Sprite2DTextureFilter:CanvasItem.TextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

@export_group("3D Properties")
const DEFAULT_3D_PIXEL_SIZE:float = 0.01
@export var Sprite3DScale:float = 1
@export var Sprite3DBillboard:BaseMaterial3D.BillboardMode = BaseMaterial3D.BILLBOARD_DISABLED
@export var Sprite3DTextureFilter:BaseMaterial3D.TextureFilter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

var lastOffset:float = 1.0

var AnimationNames:Array
func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()

func play(animation: LPCEnum.LPCAnimation, fps: float = 5.0):
	var sprites = get_children()
	for sprite in sprites:
		if sprite.sprite_frames.has_animation(AnimationNames[animation]):
			sprite.visible = true
			sprite.sprite_frames.set_animation_speed(AnimationNames[animation], fps)
			sprite.play(AnimationNames[animation])
		else:
			sprite.visible = false

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()
	
func LoadAnimations():
	AnimationNames = LPCEnum.LPCAnimation.keys()
	var children = get_children();
	for child in children:
		remove_child(child)
		
	for spriteSheet in SpriteSheets:
		if spriteSheet == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			continue
			
		var animatedSprite = CreateSpriteType()
		var spriteFrames = CreateSprites(spriteSheet)
		animatedSprite.frames = spriteFrames
		add_child(animatedSprite)
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = get_tree().edited_scene_root
		play(DefaultAnimation)
func CreateSpriteType():
	match NodeType:
		LPCEnum.ESpriteNodeType.Sprite_3D:
			var animatedSprite = AnimatedSprite3D.new()
			animatedSprite.pixel_size = Sprite3DScale * DEFAULT_3D_PIXEL_SIZE
			animatedSprite.texture_filter = Sprite3DTextureFilter
			animatedSprite.billboard = Sprite3DBillboard
			animatedSprite.sorting_offset = lastOffset
			lastOffset += 1.0
			return animatedSprite
		LPCEnum.ESpriteNodeType.Sprite_2D:
			var animatedSprite = AnimatedSprite2D.new()
			animatedSprite.texture_filter = Sprite2DTextureFilter
			return animatedSprite
			
func CreateSprites(spriteSheet:LPCSpriteSheet):
	var spriteFrames = SpriteFrames.new()
	spriteFrames.remove_animation("default")
	
	for animationData in spriteSheet.AnimationData():
		AddAnimation(spriteSheet, spriteFrames, animationData)
	return spriteFrames

func AddAnimation(spriteSheet:LPCSpriteSheet, spriteFrames:SpriteFrames, animationData:LPCAnimationData):
	if spriteSheet == null || spriteSheet.SpriteSheet == null:
		return
	
	if spriteFrames.has_animation(animationData.Name):
		spriteFrames.remove_animation(animationData.Name)
		
	spriteFrames.add_animation(animationData.Name)
	var frameStart = animationData.FrameCount -1 if animationData.Reverse else 0
	var frameEnd = -1 if animationData.Reverse else animationData.FrameCount
	var reversed = -1 if animationData.Reverse else 1
	for frame in range(frameStart, frameEnd , reversed):
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet.SpriteSheet
		atlasTexture.region = spriteSheet.GetSpriteRect(animationData, frame)
		spriteFrames.add_frame(animationData.Name, atlasTexture, 0.5)
	spriteFrames.set_animation_loop(animationData.Name, animationData.Loop)
	return spriteFrames
