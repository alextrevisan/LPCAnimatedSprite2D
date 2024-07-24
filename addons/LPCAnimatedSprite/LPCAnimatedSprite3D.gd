@tool
@icon("res://addons/LPCAnimatedSprite/icon3d.png")
class_name LPCAnimatedSprite3D extends Node3D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCEnum.LPCAnimation = LPCEnum.LPCAnimation.IDLE_DOWN

const DEFAULT_3D_PIXEL_SIZE:float = 0.01
@export var Sprite3DScale:float = 1
@export var Sprite3DBillboard:BaseMaterial3D.BillboardMode = BaseMaterial3D.BILLBOARD_DISABLED
@export var Sprite3DTextureFilter:BaseMaterial3D.TextureFilter = BaseMaterial3D.TEXTURE_FILTER_NEAREST

var lastOffset:float = 1.0
var AnimationNames:Array
var LPC_base : LPCBase

func _ready():
	if Engine.is_editor_hint() == false:
		_instantiate()

func _enter_tree():
	if Engine.is_editor_hint():
		_instantiate()

func _instantiate() -> void :
	if not LPC_base:
		LPC_base = LPCBase.new()
	LPC_base.LoadAnimations(self)

func play(animation: LPCEnum.LPCAnimation, fps: float = 5.0):
	var sprites = get_children()
	LPC_base.play(animation, sprites, AnimationNames, fps)

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("_instantiate")

func CreateAnimatedSprite():
	var animatedSprite = AnimatedSprite3D.new()
	animatedSprite.pixel_size = Sprite3DScale * DEFAULT_3D_PIXEL_SIZE
	animatedSprite.texture_filter = Sprite3DTextureFilter
	animatedSprite.billboard = Sprite3DBillboard
	animatedSprite.sorting_offset = lastOffset
	lastOffset += 1.0
	return animatedSprite
