extends Node2D

#precompile spritesheet definition
#https://sanderfrenken.github.io/Universal-LPC-Spritesheet-Character-Generator/#?body=Body_color_light&head=Human_male_light&weapon=Dagger_dagger&sex=male&shadow=Shadow_shadow&wound_arm=none&prosthesis_hand=none&shoulders=Plate_steel&arms=Armour_steel&bauldron=Bauldron_tan&bracers=Bracers_steel&wrists=none&gloves=none&armour=Plate_steel&cape=Tattered_purple&belt=Leather_Belt_brown&legs=Armour_steel&shoes=Armour_steel&eyepatch=Eyepatch_eyepatch&hair=Plain_ash

@onready var AnimationList:OptionButton = $CanvasLayer/Control/VBoxContainer/Animation

func _ready() -> void:
	$CanvasLayer/GridContainer/Control/LPCAnimatedSprite2D.play("walk_east")

func _on_animation_item_selected(index:int) -> void:
	pass
