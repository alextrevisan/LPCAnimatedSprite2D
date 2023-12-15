@tool
extends Node2D

class_name LPCAnimatedSprite2D

@export var SpriteSheets:Array[LPCSpriteSheet]
@export var DefaultAnimation:LPCAnimation = LPCAnimation.IDLE_DOWN
@export var SpriteType: SpriteTypeEnum

var unified_sprite_sheet:LPCSpriteSheet
var AnimationNames:Array
var sprite_frames:SpriteFrames = SpriteFrames.new()
var animatedSprite = AnimatedSprite2D.new()

enum SpriteTypeEnum {
	Normal,
	OversizeRod,
	OversizeThrust,
	OversizeSlash,
	OversizeWhip
}

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

func _ready():
	if Engine.is_editor_hint() == false:
		LoadAnimations()
		
func play(animation: LPCAnimation):
	if sprite_frames.has_animation(AnimationNames[animation]):
		animatedSprite.visible = true
		animatedSprite.play(AnimationNames[animation])
	else:
		animatedSprite.visible = false

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
		
	if 0 == SpriteSheets.size():
		push_error("No detected LPCSpriteSheets.")
	else:
		if SpriteSheets[0] == null:
			push_warning("There are LPCSpriteSheets that are <empty> in the LPCAnimatedSprite2D panel")
			return
		if 1 == SpriteSheets.size():
			unified_sprite_sheet = SpriteSheets[0]
			LoadFrames()
		else:
			# assuming all spritesheet textures of same dimensions as those of the first.
			# May be an invalid assumption, as I have no data and can't test - so TBC.
			var viewport_RID: RID = RenderingServer.viewport_create()
			var viewport_size: Vector2 = SpriteSheets[0].SpriteSheet.get_size()
			RenderingServer.viewport_set_size(viewport_RID, viewport_size.x, viewport_size.y)
			
			var canvas_RID: RID = RenderingServer.canvas_create()
			RenderingServer.viewport_attach_canvas(viewport_RID,canvas_RID)
			
			var RID_array:Array[RID]
			
			var rect:Rect2 = Rect2(0,0,viewport_size.x, viewport_size.y)
			var draw_index:int=0
			
			for sheet in SpriteSheets:
				var canvas_item_RID = RenderingServer.canvas_item_create()
				var image_RID = RenderingServer.texture_2d_create(sheet.SpriteSheet.get_image())
				RenderingServer.canvas_item_add_texture_rect(canvas_item_RID, rect, image_RID)
				RenderingServer.canvas_item_set_draw_index(canvas_item_RID,draw_index)
				draw_index += 1
				RenderingServer.canvas_set_item_mirroring(canvas_RID,image_RID, Vector2(0,0))
				RID_array.append(canvas_item_RID)
				RID_array.append(image_RID)
			#var texture2d_RID: RID = RenderingServer.texture_2d_layered_create(image_array,RenderingServer.TEXTURE_LAYERED_2D_ARRAY)

			RenderingServer.viewport_set_update_mode(viewport_RID, RenderingServer.VIEWPORT_UPDATE_ONCE)
			RenderingServer.force_draw()
			await RenderingServer.frame_post_draw
			var texture_RID = RenderingServer.viewport_get_texture(viewport_RID)
			var mergeImg:Image = RenderingServer.texture_2d_get(texture_RID)
			mergeImg.save_png("res://temp.png")
			
			### unmultiplication
			#for y in mergeImg.get_size().y:
			#	for x in mergeImg.get_size().x:
			#		var color:Color = mergeImg.get_pixel(x, y)
			#		if color.a != 0:
			#			mergeImg.set_pixel(x, y, Color(color.r / color.a, color.g / color.a, color.b / color.a, color.a))
			###
			unified_sprite_sheet = LPCSpriteSheet.new()
			unified_sprite_sheet.SpriteSheet = ImageTexture.create_from_image(mergeImg)
			for a_RID in RID_array:
				RenderingServer.free_rid(a_RID)
			RenderingServer.free_rid(texture_RID)
			RenderingServer.free_rid(canvas_RID)
			RenderingServer.free_rid(viewport_RID)
			LoadFrames()

func LoadFrames() -> void:
	animatedSprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite_frames.remove_animation("default")
	for animationData in AnimationData():
		AddAnimation(animationData)
	animatedSprite.frames = sprite_frames
	add_child(animatedSprite)
	animatedSprite.owner = get_tree().edited_scene_root
	
	play(DefaultAnimation)

func AddAnimation(animationData:LPCAnimationData):
	if unified_sprite_sheet == null || unified_sprite_sheet.SpriteSheet == null:
		return
	if sprite_frames.has_animation(animationData.Name):
		sprite_frames.clear(animationData.Name)
	
	sprite_frames.add_animation(animationData.Name)
	for col in range(animationData.FrameCount):
		if "WALK" in animationData.Name && col == 0:
			continue
		var atlasTexture = AtlasTexture.new()
		atlasTexture.atlas = unified_sprite_sheet.SpriteSheet
		var spriteSize:int = Size()
		atlasTexture.region = Rect2(spriteSize*(col+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)			
		sprite_frames.add_frame(animationData.Name, atlasTexture, 0.5)
	sprite_frames.set_animation_loop(animationData.Name, animationData.Loop)

var NormalAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(7,"CAST_UP",0, 0,false),
	LPCAnimationData.new(7,"CAST_LEFT",1, 0,false),
	LPCAnimationData.new(7,"CAST_DOWN",2, 0,false),
	LPCAnimationData.new(7,"CAST_RIGHT",3, 0,false),
	LPCAnimationData.new(8,"THRUST_UP",4, 0,false),
	LPCAnimationData.new(8,"THRUST_LEFT",5, 0,false),
	LPCAnimationData.new(8,"THRUST_DOWN",6, 0,false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7, 0,false),
	LPCAnimationData.new(8,"WALK_UP",8, 0,true),
	LPCAnimationData.new(8,"WALK_LEFT",9, 0,true),
	LPCAnimationData.new(8,"WALK_DOWN",10, 0,true),
	LPCAnimationData.new(8,"WALK_RIGHT",11, 0,true),
	LPCAnimationData.new(6,"SLASH_UP",12, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",13, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",14, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",15, 0,false),
	LPCAnimationData.new(6,"WHIP_UP",12, 0,false),
	LPCAnimationData.new(6,"WHIP_LEFT",13, 0,false),
	LPCAnimationData.new(6,"WHIP_DOWN",14, 0,false),
	LPCAnimationData.new(6,"WHIP_RIGHT",15, 0,false),
	LPCAnimationData.new(13,"SHOOT_UP",16, 0,false),
	LPCAnimationData.new(13,"SHOOT_LEFT",17, 0,false),
	LPCAnimationData.new(13,"SHOOT_DOWN",18, 0,false),
	LPCAnimationData.new(13,"SHOOT_RIGHT",19, 0,false),
	LPCAnimationData.new(6,"HURT_DOWN",20, 0,false),
	LPCAnimationData.new(1,"IDLE_UP",8, 0,false),
	LPCAnimationData.new(1,"IDLE_LEFT",9, 0,false),
	LPCAnimationData.new(1,"IDLE_DOWN",10, 0,false),
	LPCAnimationData.new(1,"IDLE_RIGHT",11, 0,false),
	LPCAnimationData.new(1,"HURT_DOWN_LAST",20, 5,false),
]
var SlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",0, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",1, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",2, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",3, 0,false),
]
var ThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"THRUST_UP",0, 0,false),
	LPCAnimationData.new(6,"THRUST_LEFT",1, 0,false),
	LPCAnimationData.new(6,"THRUST_DOWN",2, 0,false),
	LPCAnimationData.new(6,"THRUST_RIGHT",3, 0,false),
]
var RodAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"ROD_UP",0, 0,false),
	LPCAnimationData.new(6,"ROD_LEFT",1, 0,false),
	LPCAnimationData.new(6,"ROD_DOWN",2, 0,false),
	LPCAnimationData.new(6,"ROD_RIGHT",3, 0,false),
]
var WhipAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(8,"WHIP_UP",0, 0,false),
	LPCAnimationData.new(8,"WHIP_LEFT",1, 0,false),
	LPCAnimationData.new(8,"WHIP_DOWN",2, 0,false),
	LPCAnimationData.new(8,"WHIP_RIGHT",3, 0,false),
]

func Size() -> int:
	match SpriteType:
		SpriteTypeEnum.Normal:
			return 64
		_:
			return 192
func AnimationData() -> Array[LPCAnimationData]:
	match SpriteType:
		SpriteTypeEnum.Normal:
			return NormalAnimationData
		SpriteTypeEnum.OversizeRod:
			return RodAnimationData
		SpriteTypeEnum.OversizeThrust:
			return ThrustAnimationData
		SpriteTypeEnum.OversizeSlash:
			return SlashAnimationData
		SpriteTypeEnum.OversizeWhip:
			return WhipAnimationData
		_:
			return NormalAnimationData
