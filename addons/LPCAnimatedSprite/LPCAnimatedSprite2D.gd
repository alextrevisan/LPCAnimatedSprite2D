@tool
@icon("res://addons/LPCAnimatedSprite/icon2d.png")
class_name LPCAnimatedSprite2D extends AnimatedSprite2D

var _spritesheets_path: String:
	set(value):
		_spritesheets_path = value
		_load_spritesheets()
		_setup_sprite_frames()

@export_dir var spritesheets_path: String:
	set(value):
		_spritesheets_path = value
	get:
		return _spritesheets_path

@export var animation_data: LPCAnimationDataBase:
	set(value):
		animation_data = value
		_setup_animation_properties()
		_load_spritesheets()
		_setup_sprite_frames()
		notify_property_list_changed()
	get:
		return animation_data

var animation_textures = {}
var current_animation: String = ""
var direction: String = "south"

func _get_property_list():
	var properties = []
	
	if animation_data:		
		# Add texture properties for manual override
		for spritesheet in animation_data.required_spritesheets:
			var prop_name = spritesheet + "_texture"
			properties.append({
				"name": prop_name,
				"type": TYPE_OBJECT,
				"usage": PROPERTY_USAGE_NO_EDITOR,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "Texture2D"
			})
	
	return properties

func _get(property):
	if property.ends_with("_texture"):
		var spritesheet = property.trim_suffix("_texture")
		if spritesheet in animation_textures:
			return animation_textures[spritesheet]
	return null

func _set(property, value):
	if property.ends_with("_texture"):
		var spritesheet = property.trim_suffix("_texture")
		if value == null:
			animation_textures.erase(spritesheet)
		else:
			animation_textures[spritesheet] = value
			
			# If this is a single spritesheet, apply it to all animations
			if animation_data and animation_data.required_spritesheets.size() == 1 and animation_data.required_spritesheets[0] == "single":
				for anim in animation_data.available_animations:
					animation_textures[anim] = value
			
		_setup_sprite_frames()
		return true
	return false

func _load_spritesheets():
	if not animation_data:
		return
	
	clear_textures_for_animations_that_no_longer_exist()
	load_textures_directly_from_required_spritesheets()

func clear_textures_for_animations_that_no_longer_exist():
	var textures_to_remove = []
	for anim_name in animation_textures:
		if not anim_name in animation_data.available_animations:
			textures_to_remove.append(anim_name)
	
	for anim_name in textures_to_remove:
		animation_textures.erase(anim_name)

func load_textures_directly_from_required_spritesheets():
	for spritesheet in animation_data.required_spritesheets:
		var texture_path = _spritesheets_path.path_join(spritesheet + ".png")
		var texture = load(texture_path)
		if texture:
			if spritesheet == "single":
				# If using single spritesheet, apply to all animations
				for anim_name in animation_data.available_animations:
					animation_textures[anim_name] = texture
			else:
				# Otherwise load specific spritesheet
				animation_textures[spritesheet] = texture
		else:
			push_error("Failed to load spritesheet: %s" % texture_path)

func _setup_animation_properties():
	if not animation_data:
		return
	
	if not sprite_frames:
		sprite_frames = SpriteFrames.new()
	
	if animation_data.available_animations.size() > 0:
		current_animation = animation_data.available_animations[0]
		direction = "south"

func _setup_sprite_frames():
	if not animation_data or not sprite_frames:
		return

	sprite_frames.clear_all()
	
	for anim_name in animation_data.available_animations:
		for dir in animation_data.available_directions[anim_name].keys():
			var anim_key = anim_name + "_" + dir
			
			sprite_frames.add_animation(anim_key)
			sprite_frames.set_animation_loop(anim_key, animation_data.animation_loops[anim_name])
			sprite_frames.set_animation_speed(anim_key, animation_data.animation_speeds[anim_name])
			
			var texture = animation_textures.get(anim_name)
			if not texture:
				print("No texture for animation: ", anim_name)
				continue
				
			var frame_count = animation_data.animation_frame_counts[anim_name]
			var frame_size = animation_data.frame_sizes[anim_name]
			var animation_rows = animation_data.animation_rows[anim_name]
			var direction_offset = animation_data.available_directions[anim_name][dir]
			var custom_frames = animation_data.custom_frames.get(anim_name, null)
			
			if custom_frames:
				for frame_idx in custom_frames:
					var atlas = AtlasTexture.new()
					atlas.atlas = texture
					atlas.region = Rect2(frame_idx * frame_size, (animation_rows + direction_offset) * frame_size, frame_size, frame_size)
					sprite_frames.add_frame(anim_key, atlas)
			else:
				for frame_idx in range(frame_count):
					var atlas = AtlasTexture.new()
					atlas.atlas = texture
					atlas.region = Rect2(frame_idx * frame_size, (animation_rows + direction_offset) * frame_size, frame_size, frame_size)
					sprite_frames.add_frame(anim_key, atlas)
	
	if current_animation and direction:
		var anim_key = current_animation + "_" + direction
		if sprite_frames.has_animation(anim_key):
			play(anim_key)

func play_animation(anim_name: String = "idle", dir: String = "south"):
	if not animation_data:
		return
		
	if not anim_name in animation_data.available_animations:
		return
		
	if not dir in animation_data.available_directions[anim_name]:
		dir = animation_data.available_directions[anim_name].keys()[0]
	
	current_animation = anim_name
	direction = dir
	
	var anim_key = current_animation + "_" + direction
	if sprite_frames.has_animation(anim_key):
		play(anim_key)

func _ready():
	if not sprite_frames:
		set_sprite_frames(SpriteFrames.new())
	if not animation_data:
		animation_data = LPCAnimationData.new()
	_setup_animation_properties()
	_load_spritesheets()
	_setup_sprite_frames()

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_setup_sprite_frames()
