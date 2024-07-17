extends Node2D

#precompile spritesheet definition
#https://sanderfrenken.github.io/Universal-LPC-Spritesheet-Character-Generator/#?body=Body_color_light&head=Human_male_light&weapon=Dagger_dagger&sex=male&shadow=Shadow_shadow&wound_arm=none&prosthesis_hand=none&shoulders=Plate_steel&arms=Armour_steel&bauldron=Bauldron_tan&bracers=Bracers_steel&wrists=none&gloves=none&armour=Plate_steel&cape=Tattered_purple&belt=Leather_Belt_brown&legs=Armour_steel&shoes=Armour_steel&eyepatch=Eyepatch_eyepatch&hair=Plain_ash

@onready var SpriteParts:LPCAnimatedSprite2D = $"CanvasLayer/GridContainer/Control/SpriteParts"
@onready var PrecompiledDagger:LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control2/PrecompiledDagger
@onready var PrecompiledLongsword:LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control3/PrecompiledLongsword
@onready var SpritePartsLongsword: LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control6/SpritePartsLongsword

@onready var AnimationList:OptionButton = $CanvasLayer/Control/VBoxContainer/Animation

func _ready() -> void:
	for value:String in LPCEnum.LPCAnimation:
		AnimationList.add_item(value)
	AnimationList.select(LPCEnum.LPCAnimation.WALK_DOWN)

func _on_animation_item_selected(index:int) -> void:
	var animation:LPCEnum.LPCAnimation = index as LPCEnum.LPCAnimation
	PrecompiledDagger.play(animation)
	SpriteParts.play(animation)
	PrecompiledLongsword.play(animation)
	SpritePartsLongsword.play(animation)
