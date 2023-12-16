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

#### NO LONGER NEEDED (WITH CURRENT APPROCH), FOR REFERENCE ONLY ####
var anim_lookup_dict: Dictionary = {
	"IDLE": {
		Vector2(0,-1): ["IDLE_UP", "OVERSIZE_IDLE_UP"],
		Vector2(-1,0): ["IDLE_LEFT", "OVERSIZE_IDLE_LEFT"],
		Vector2(0,1): ["IDLE_DOWN", "OVERSIZE_IDLE_DOWN"],
		Vector2(1,0): ["IDLE_RIGHT", "OVERSIZE_IDLE_RIGHT"],
	},
	"WALK": {
		Vector2(0,-1): ["WALK_UP", "OVERSIZE_WALK_UP"],
		Vector2(-1,0): ["WALK_LEFT", "OVERSIZE_WALK_LEFT"],
		Vector2(0,1): ["WALK_DOWN", "OVERSIZE_WALK_DOWN"],
		Vector2(1,0): ["WALK_RIGHT", "OVERSIZE_WALK_RIGHT"],
	},
	"THRUST": {
		Vector2(0,-1): ["THRUST_UP", "OVERSIZE_THRUST_UP"],
		Vector2(-1,0): ["THRUST_LEFT", "OVERSIZE_THRUST_LEFT"],
		Vector2(0,1): ["THRUST_DOWN", "OVERSIZE_THRUST_DOWN"],
		Vector2(1,0): ["THRUST_RIGHT", "OVERSIZE_THRUST_RIGHT"],
	},
	"CAST": {
		Vector2(0,-1): ["CAST_UP", "OVERSIZE_CAST_UP"],
		Vector2(-1,0): ["CAST_LEFT", "OVERSIZE_CAST_LEFT"],
		Vector2(0,1): ["CAST_DOWN", "OVERSIZE_CAST_DOWN"],
		Vector2(1,0): ["CAST_RIGHT", "OVERSIZE_CAST_RIGHT"],
	},
	"SLASH": {
		Vector2(0,-1): ["SLASH_UP", "OVERSIZE_SLASH_UP"],
		Vector2(-1,0): ["SLASH_LEFT", "OVERSIZE_SLASH_LEFT"],
		Vector2(0,1): ["SLASH_DOWN", "OVERSIZE_SLASH_DOWN"],
		Vector2(1,0): ["SLASH_RIGHT", "OVERSIZE_SLASH_RIGHT"],
	},
	"SHOOT": {
		Vector2(0,-1): ["SHOOT_UP", "OVERSIZE_SHOOT_UP"],
		Vector2(-1,0): ["SHOOT_LEFT", "OVERSIZE_SHOOT_UP"],
		Vector2(0,1): ["SHOOT_DOWN", "OVERSIZE_SHOOT_DOWN"],
		Vector2(1,0): ["SHOOT_RIGHT", "OVERSIZE_SHOOT_RIGHT"],
	},
}

var cur_dir: Vector2
var AnimationNames:Array
var reference_sheet := LPCSpriteSheet.new().NormalAnimationData

func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		UpdateCurDir(LPCAnimation.keys()[DefaultAnimation])

func UpdateCurDir(anim_name: String) -> void:
	cur_dir = GetDir(anim_name)

func GetDir(anim_name: String) -> Vector2:
	for anim_data in reference_sheet:
		if anim_data.name == anim_name:
			return anim_data.direction
	push_error("Supplied animation name: " + anim_name + " was not found.")
	return cur_dir

func LookUpAnimation(anim_type_name: String, direction: Vector2, oversize: bool) -> LPCAnimation:
	for anim_data in reference_sheet:
		if anim_data.type == anim_type_name and anim_data.Direction == direction and anim_data.oversize == oversize:
			return LPCAnimation.find_key(anim_data.name)
	
	# if not found, for whatever reason
	push_error("Supplied animation name: %, direction: %, % oversize not found." % [anim_type_name, direction, "is" if oversize else "not"])
	return LPCAnimation.find_key("IDLE_DOWN") #unsure
	
func play(animation, direction := Vector2(0,0), oversize := false) -> void:
	var sprites = get_children() as Array[AnimatedSprite2D]
	if typeof(animation) == TYPE_STRING:
		if LPCAnimation.has(animation):
			animation = LPCAnimation.find_key(anim_lookup_dict)
		else:
			if direction == Vector2(0,0):
				direction = cur_dir
			# add code to handle non-existant required
			animation = LookUpAnimation(animation, direction, oversize)		
	
	if typeof(animation) != typeof(LPCAnimation):
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
