@tool
@icon("res://addons/LPCAnimatedSprite/icon2d.png")
class_name LPCAnimatedSprite2D extends Node2D


@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCEnum.LPCAnimation = LPCEnum.LPCAnimation.IDLE_DOWN

@export var Sprite2DTextureFilter:CanvasItem.TextureFilter = CanvasItem.TEXTURE_FILTER_NEAREST

var lastOffset : float = 1.0
var AnimationNames : Array
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
	var animatedSprite = AnimatedSprite2D.new()
	animatedSprite.texture_filter = Sprite2DTextureFilter
	return animatedSprite
