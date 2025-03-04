@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("LPCAnimatedSprite", "AnimatedSprite2D", preload("LPCAnimatedSprite2D.gd"), preload("icon2d.png"))

func _exit_tree():
	remove_custom_type("LPCAnimatedSprite")
