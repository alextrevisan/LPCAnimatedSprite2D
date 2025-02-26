extends Node2D

#precompile spritesheet definition
#https://sanderfrenken.github.io/Universal-LPC-Spritesheet-Character-Generator/#?body=Body_color_light&head=Human_male_light&weapon=Dagger_dagger&sex=male&shadow=Shadow_shadow&wound_arm=none&prosthesis_hand=none&shoulders=Plate_steel&arms=Armour_steel&bauldron=Bauldron_tan&bracers=Bracers_steel&wrists=none&gloves=none&armour=Plate_steel&cape=Tattered_purple&belt=Leather_Belt_brown&legs=Armour_steel&shoes=Armour_steel&eyepatch=Eyepatch_eyepatch&hair=Plain_ash

@onready var multiple: LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control/LPCAnimatedSprite2D
@onready var single: LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control2/LPCAnimatedSprite2D
@onready var custom: LPCAnimatedSprite2D = $CanvasLayer/GridContainer/Control3/LPCAnimatedSprite2D
@onready var animations := [multiple, single, custom]

@onready var option_button_multiple: OptionButton = $CanvasLayer/GridContainer/Control/OptionButton
@onready var option_button_single: OptionButton = $CanvasLayer/GridContainer/Control2/OptionButton
@onready var option_button_custom: OptionButton = $CanvasLayer/GridContainer/Control3/OptionButton
@onready var animation_select := [option_button_multiple, option_button_single, option_button_custom]

func _ready() -> void:
	_load_data_from_first_animation()
	for index in range(3):
		animations[index].play(animation_select[index].get_item_text(0))
	
	

func _load_data_from_first_animation() -> void:
	for i in range(3):
		for anim:String in animations[i].animation_data.available_animations:
			for dir:String in animations[i].animation_data.available_directions[anim]:
				var anim_dir:String = anim + "_" + dir
				animation_select[i].add_item(anim_dir)


func _on_option_button_item_selected(index: int, extra_arg_0: int) -> void:
	var anim:String = animation_select[extra_arg_0].get_item_text(index)
	animations[extra_arg_0].play(anim)
