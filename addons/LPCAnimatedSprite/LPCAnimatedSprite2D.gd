@tool
extends Node2D

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCAnimation = LPCAnimation.IDLE_DOWN

enum LPCAnimation {
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

var cur_dir:Vector2
var AnimationNames:Array
var reference_sheet := LPCSpriteSheet.new().NormalAnimationData

func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		cur_dir = LookupDir(LPCAnimation.keys()[DefaultAnimation])

func LookupDir(anim_name: String) -> Vector2:
	for anim_data in reference_sheet:
		if anim_data.Name == anim_name:
			return anim_data.Direction
	push_error("Supplied animation name: " + anim_name + " was not found.")
	return Vector2.ZERO

func LookUpAnimation(anim_type_name: String, direction: Vector2, oversize: bool) -> LPCAnimation:
	for anim_data in reference_sheet:
		if anim_data.Type == anim_type_name and anim_data.Direction == direction and anim_data.Oversize == oversize:
			return LPCAnimation.keys().find(anim_data.Name)
	
	# if not found, for whatever reason
	push_error("Supplied animation name: %, direction: %, % oversize not found." % [anim_type_name, direction, "is" if oversize else "not"])
	return LPCAnimation.find_key("IDLE_DOWN") #unsure
	
func play(animation, direction := Vector2.ZERO, oversize := false) -> void:
	var sprites = get_children() as Array[AnimatedSprite2D]
	
	if direction == Vector2.ZERO:
		direction = cur_dir
	else:
		cur_dir = direction
		
	if typeof(animation) == TYPE_STRING:
		if LPCAnimation.has(animation):
			animation = LPCAnimation.find_key(animation) # type change
		else:
			animation = LookUpAnimation(animation, direction, oversize)		
	
	if typeof(animation) != TYPE_INT:
		push_error("Animation not correctly looked up. Play request refused.")
		return #last sanity check, maybe add error
	
	for sprite in sprites:
		if sprite.sprite_frames.has_animation(AnimationNames[animation]):
			sprite.visible = true
			sprite.play(AnimationNames[animation])
		else:
			sprite.visible = false

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		call_deferred("LoadAnimations")
		
func _enter_tree():
	if Engine.is_editor_hint():
		LoadAnimations()
	
func LoadAnimations():
	AnimationNames = LPCAnimation.keys()
	var children = get_children();
	for child in children:
		remove_child(child)
		
	for spriteSheet in SpriteSheets:
		if spriteSheet == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			continue
		var animatedSprite = AnimatedSprite2D.new()
		animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var spriteFrames = CreateSprites(spriteSheet)
		animatedSprite.frames = spriteFrames
		add_child(animatedSprite)
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
		spriteFrames.clear(animationData.Name)
	
	spriteFrames.add_animation(animationData.Name)
	for col in range(animationData.FrameCount):
		if "WALK" in animationData.Name && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = spriteSheet.SpriteSheet
		var spriteSize:int = spriteSheet.Size()
		atlasTexture.region = Rect2(spriteSize*(col+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)			
		spriteFrames.add_frame(animationData.Name, atlasTexture, 0.5)
	spriteFrames.set_animation_loop(animationData.Name, animationData.Loop)
	return spriteFrames
