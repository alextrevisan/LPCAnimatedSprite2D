extends Node2D

@onready var SpriteParts:LPCAnimatedSprite2D = $"sprite parts"
@onready var Precompiled:LPCAnimatedSprite2D = $precompiled

func _on_sprite_type_item_selected(index):
	match index:
		0:
			SpriteParts.visible = true
			Precompiled.visible = false
		1:
			SpriteParts.visible = false
			Precompiled.visible = true
