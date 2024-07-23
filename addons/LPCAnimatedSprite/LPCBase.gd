class_name LPCBase extends Node

func play(animation: LPCEnum.LPCAnimation, sprites: Array, animation_names: Array, fps: float = 5.0) -> void:
	for sprite in sprites:
		if sprite.sprite_frames.has_animation(animation_names[animation]):
			sprite.visible = true
			sprite.sprite_frames.set_animation_speed(animation_names[animation], fps)
			sprite.play(animation_names[animation])
		else:
			sprite.visible = false
	
func LoadAnimations(main_node : Node) -> void:
	main_node.AnimationNames = LPCEnum.LPCAnimation.keys()
	var children = main_node.get_children();
	for child in children:
		main_node.remove_child(child)
		
	for spriteSheet in main_node.SpriteSheets:
		if spriteSheet == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			continue
			
		var animatedSprite = main_node.CreateAnimatedSprite()
		var spriteFrames = CreateSpritesFrames(spriteSheet)
		animatedSprite.frames = spriteFrames
		main_node.add_child(animatedSprite)
		if spriteSheet.Name == null || spriteSheet.Name == "":
			animatedSprite.name = "no_name"
		else:
			animatedSprite.name = spriteSheet.Name
		animatedSprite.owner = main_node.get_tree().edited_scene_root
		main_node.play(main_node.DefaultAnimation)

func CreateSpritesFrames(spriteSheet:LPCSpriteSheet):
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
