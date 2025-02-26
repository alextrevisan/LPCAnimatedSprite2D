@tool
@icon("res://addons/LPCAnimatedSprite/icon2d.png")
class_name LPCAnimatedSprite2D extends AnimatedSprite2D

var _spritesheets_path: String
var _atlas_cache = {}

@export_dir var spritesheets_path: String:
	set(value):
		if _spritesheets_path != value:
			_spritesheets_path = value
			_refresh_sprites()
	get:
		return _spritesheets_path

@export var animation_data: LPCAnimationDataBase:
	set(value):
		animation_data = value
		_refresh_sprites()
		notify_property_list_changed()
	get:
		return animation_data

var animation_textures = {}
var current_animation: String = ""
var direction: String = "south"

func _refresh_sprites():
	if not animation_data:
		return
	_setup_animation_properties()
	_load_spritesheets()
	_setup_sprite_frames()

func _load_spritesheets():
	_clear_unused_textures()
	_load_required_textures()

func _clear_unused_textures():
	for anim_name in animation_textures.keys():
		if not anim_name in animation_data.available_animations:
			animation_textures.erase(anim_name)

func _load_required_textures():
	for anim_name in animation_data.required_spritesheets:
		var spritesheet = animation_data.required_spritesheets[anim_name]
		var texture_path = _spritesheets_path.path_join(spritesheet + ".png")
		var texture = load(texture_path)
		if texture:
			animation_textures[anim_name] = texture
		else:
			push_error("Failed to load spritesheet: %s" % texture_path)

func _setup_animation_properties():
	if not sprite_frames:
		sprite_frames = SpriteFrames.new()
	
	if animation_data.available_animations.size() > 0:
		current_animation = animation_data.available_animations[0]
		direction = "south"

func _setup_sprite_frames():
	if not animation_data or not sprite_frames:
		return

	sprite_frames.clear_all()
	_atlas_cache.clear()
	
	for anim_name in animation_data.available_animations:
		for dir in animation_data.available_directions[anim_name].keys():
			var anim_key = anim_name + "_" + dir
			
			sprite_frames.add_animation(anim_key)
			sprite_frames.set_animation_loop(anim_key, animation_data.animation_loops[anim_name])
			sprite_frames.set_animation_speed(anim_key, animation_data.animation_speeds[anim_name])
			
			var texture = animation_textures.get(anim_name)
			if not texture:
				push_warning("No texture for animation: %s" % anim_name)
				continue
				
			var frame_count = animation_data.animation_frame_counts[anim_name]
			var frame_size = animation_data.frame_sizes[anim_name]
			var animation_rows = animation_data.animation_rows[anim_name]
			var direction_offset = animation_data.available_directions[anim_name][dir]
			var custom_frames = animation_data.custom_frames.get(anim_name, null)
			var base_frame_size = animation_data.base_animation_size
			var frame_start = animation_data.initial_sprite_indices[anim_name]
			
			if not _atlas_cache.has(anim_key):
				_atlas_cache[anim_key] = []
			
			if custom_frames:
				_setup_custom_frames(anim_key, texture, custom_frames, animation_rows, base_frame_size, direction_offset, frame_size)
			else:
				_setup_standard_frames(anim_key, texture, frame_count, frame_start, animation_rows, base_frame_size, direction_offset, frame_size)
	
	_play_current_animation()

func _setup_custom_frames(anim_key, texture, custom_frames, animation_rows, base_frame_size, direction_offset, frame_size):
	for i in range(custom_frames.size()):
		var frame_idx = custom_frames[i]
		var atlas = _get_or_create_atlas(anim_key, i)
		atlas.atlas = texture
		atlas.region = Rect2(frame_idx * frame_size, animation_rows * base_frame_size + (direction_offset * frame_size), frame_size, frame_size)
		sprite_frames.add_frame(anim_key, atlas)

func _setup_standard_frames(anim_key, texture, frame_count, frame_start, animation_rows, base_frame_size, direction_offset, frame_size):
	for i in range(frame_count):
		var atlas = _get_or_create_atlas(anim_key, i)
		atlas.atlas = texture
		atlas.region = Rect2((i + frame_start) * frame_size, animation_rows * base_frame_size + (direction_offset * frame_size), frame_size, frame_size)
		sprite_frames.add_frame(anim_key, atlas)

func _get_or_create_atlas(anim_key, frame_idx):
	if _atlas_cache[anim_key].size() <= frame_idx:
		_atlas_cache[anim_key].resize(frame_idx + 1)
	
	if not _atlas_cache[anim_key][frame_idx]:
		_atlas_cache[anim_key][frame_idx] = AtlasTexture.new()
	
	return _atlas_cache[anim_key][frame_idx]

func _play_current_animation():
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
	
	_play_current_animation()

func _ready():
	if not sprite_frames:
		set_sprite_frames(SpriteFrames.new())
	if not animation_data:
		animation_data = LPCAnimationData.new()
	_refresh_sprites()

func _notification(what):
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		_setup_sprite_frames()
