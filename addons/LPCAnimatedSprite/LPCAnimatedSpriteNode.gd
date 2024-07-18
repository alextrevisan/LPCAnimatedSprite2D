@tool
extends Node

class_name LPCAnimatedSpriteNode

#change: pawel.skorupka - adding a switch to make this work for both 2D and 3D
var NodeType:ESpriteNodeType = ESpriteNodeType.Sprite_2D
@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:ELPCAnimation = ELPCAnimation.IDLE_DOWN
#begin_change: pawel.skorupka - added important settings overrides for 2D and 3D sprites
@export_group("2D related properties")
@export var Sprite2DTextureFilter:CanvasItem.TextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

@export_group("3D related properties")
const DEFAULT_3D_PIXEL_SIZE:float = 0.01
@export var Sprite3DScale:float = 1
@export var Sprite3DBillboard:BaseMaterial3D.BillboardMode = BaseMaterial3D.BILLBOARD_DISABLED
@export var Sprite3DTextureFilter:BaseMaterial3D.TextureFilter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
#end_change

#TODO: add a single @export var AnimFrame:int with setter and getter, which will synchronize frames for all of the child AnimatedSprites nodes. This should allow us to use this whole setup with AnimationPlayer at no additional cost.

#change transformation handle. 
var TransformHandle:Node = null

#change: pawel.skorupka - this enum will help with choosing if we deal with 2D or 3D sprite nodes
enum ESpriteNodeType {
	Sprite_2D,
	Sprite_3D
}

#change: pawel.skorupka - 
enum ELPCAnimation {
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
	SLASH_REVERSE_UP,
	SLASH_REVERSE_LEFT,
	SLASH_REVERSE_DOWN,
	SLASH_REVERSE_RIGHT,
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
var AnimationNames:Array

func _ready():
	#begin_change: pawel.skorupka - We need to check if 
	CheckSceneType()
	if Engine.is_editor_hint() == false:
		#I read somewhere that logic that changes node Tree should be called on main thread if called from _ready()
		LoadAnimations.call_deferred() 
	#end_change
		
func play(animation: ELPCAnimation, fps: float = 5.0):
	#begin_change: pawel.skorupka - adding a switch to make this work for both 2D and 3D
	var sprites = null
	if NodeType == ESpriteNodeType.Sprite_3D:
		sprites = TransformHandle.get_children() as Array[AnimatedSprite3D]
	else:
		sprites = TransformHandle.get_children() as Array[AnimatedSprite2D]
	#end_change
		
	for sprite in sprites:
		if sprite.sprite_frames.has_animation(AnimationNames[animation]):
			sprite.visible = true
			sprite.sprite_frames.set_animation_speed(AnimationNames[animation], fps)
			sprite.play(AnimationNames[animation])
		else:
			sprite.visible = false

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		LoadAnimations.call_deferred() #change: pawel.skorupka - just a different syntax to call it on main thread
		
func _enter_tree():
	if Engine.is_editor_hint():
		SetupTransformNode()
		LoadAnimations()
	
func LoadAnimations():
	#begin_change: pawel.skorupka - setup the transform handle based on current scene setup
	SetupTransformNode()
	AnimationNames = ELPCAnimation.keys()
	var children = TransformHandle.get_children();
	#end_change
	for child in children: #i think we shouldn't remove children, but always have only 1 animatedSprite. Insa
		TransformHandle.remove_child(child) #change: pawel.skorupka - remove from TransformHandle instead
		
	for spriteSheet in SpriteSheets:
		if spriteSheet == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			continue
			
		#begin_change: pawel.skorupka - adding a switch to make this work for both 2D and 3D
		var animatedSprite = null
		if NodeType == ESpriteNodeType.Sprite_3D:
			animatedSprite = AnimatedSprite3D.new()
			animatedSprite.pixel_size = Sprite3DScale * DEFAULT_3D_PIXEL_SIZE
			animatedSprite.texture_filter = Sprite3DTextureFilter
			animatedSprite.billboard = Sprite3DBillboard
		else:
			animatedSprite = AnimatedSprite2D.new()
			animatedSprite.texture_filter = Sprite2DTextureFilter
		#end_change
			
		var spriteFrames = CreateSprites(spriteSheet)
		animatedSprite.frames = spriteFrames
		TransformHandle.add_child(animatedSprite) #change: pawel.skorupka - add animatedSprites to the proper transform node
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = get_tree().edited_scene_root
		play(DefaultAnimation)

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
	
# begin_change: pawel.skorupka - this function will find a root transform Node2D or Node3D and get
# or create one, so that we can safely make manual offset for the position
func SetupTransformNode():
	#check if anything changed on the scene between saves
	CheckSceneType()
	
	# 
	if self.get_child_count() == 0:
		if NodeType == ESpriteNodeType.Sprite_3D:
			TransformHandle = Node3D.new()
			TransformHandle.set_name("root3D")
		else:
			TransformHandle = Node2D.new()
			TransformHandle.set_name("root2D")
			
		self.add_child(TransformHandle)
		TransformHandle.owner = get_tree().edited_scene_root
	else:
		if NodeType == ESpriteNodeType.Sprite_3D:
			TransformHandle = self.get_child(0) as Node3D
		else:
			TransformHandle = self.get_child(0) as Node2D
	return
	
func CheckSceneType():
	if self.get_parent() as Node3D != null:
		NodeType = ESpriteNodeType.Sprite_3D
	else:
		NodeType = ESpriteNodeType.Sprite_2D
