@tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here
	add_custom_type("LPCAnimatedSprite", "AnimatedSprite2D", preload("LPCAnimatedSprite2D.gd"), preload("icon2d.png"))

func _exit_tree():
	# Clean-up of the plugin goes here
	remove_custom_type("LPCAnimatedSprite")
