@tool
class_name LPCAnimatedSprite2D extends AnimatedSprite2D

@export var spritesheets_path: String:
	set(value):
		spritesheets_path = value
		_load_spritesheets()
		_setup_sprite_frames()

@export var animation_data: LPCAnimationData:
	set(value):
		animation_data = value
		_setup_animation_properties()
		_load_spritesheets()
		_setup_sprite_frames()
		notify_property_list_changed()
	get:
		return animation_data

var animation_textures = {}

var direction: String = "south":
	set(value):
		if not animation_data or not value in animation_data.available_directions:
			return
		direction = value
		if sprite_frames and current_animation + "_" + direction in sprite_frames.get_animation_names():
			play(current_animation + "_" + direction)
	get:
		return direction

var current_animation: String = "idle":
	set(value):
		if not animation_data or not value in animation_data.available_animations:
			return
		current_animation = value
		if sprite_frames and current_animation + "_" + direction in sprite_frames.get_animation_names():
			play(current_animation + "_" + direction)
	get:
		return current_animation

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

func _get_property_list():
	var properties = []
	
	if animation_data:
		# Add texture properties for manual override
		for anim_name in animation_data.required_spritesheets:
			properties.append({
				"name": anim_name + "_texture",
				"type": TYPE_OBJECT,
				"usage": PROPERTY_USAGE_NO_EDITOR,
				"hint": PROPERTY_HINT_RESOURCE_TYPE,
				"hint_string": "Texture2D"
			})
	
	return properties

func _get(property):
	if animation_data and property.ends_with("_texture"):
		var anim_name = property.trim_suffix("_texture")
		if anim_name in animation_data.required_spritesheets:
			return animation_textures.get(anim_name)

func _set(property, value):
	if animation_data and property.ends_with("_texture"):
		var anim_name = property.trim_suffix("_texture")
		if anim_name in animation_data.required_spritesheets:
			if value == null:
				animation_textures.erase(anim_name)
			else:
				animation_textures[anim_name] = value
			_setup_sprite_frames()
			return true
	return false

func _load_spritesheets():
	if not animation_data:
		return
		
	var dir = DirAccess.open(spritesheets_path)
	if not dir:
		push_error("Failed to open spritesheets directory: %s" % spritesheets_path)
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			var anim_name = file_name.get_basename()
			if anim_name in animation_data.required_spritesheets:
				var texture_path = spritesheets_path.path_join(file_name)
				var texture = load(texture_path)
				if texture:
					animation_textures[anim_name] = texture
				else:
					push_error("Failed to load texture: %s" % texture_path)
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _setup_animation_properties():
	if not animation_data:
		return
		
	# Clear textures for animations that no longer exist
	var textures_to_remove = []
	for anim_name in animation_textures:
		if not anim_name in animation_data.required_spritesheets:
			textures_to_remove.append(anim_name)
	
	for anim_name in textures_to_remove:
		animation_textures.erase(anim_name)
	
	# Ensure current animation and direction are valid
	if not current_animation in animation_data.available_animations:
		current_animation = animation_data.available_animations[0] if animation_data.available_animations.size() > 0 else ""
		
	if not direction in animation_data.available_directions:
		direction = animation_data.available_directions.keys()[0] if animation_data.available_directions.size() > 0 else ""
	
	notify_property_list_changed()

func _setup_sprite_frames():
	if not sprite_frames:
		set_sprite_frames(SpriteFrames.new())
	
	if not animation_data:
		return
	
	# Remove all existing animations
	for anim in sprite_frames.get_animation_names():
		sprite_frames.remove_animation(anim)
	
	# For each animation that has a texture
	for anim_name in animation_textures:
		var texture = animation_textures[anim_name]
		if not texture:
			continue
		
		var initial_index = animation_data.initial_sprite_indices[anim_name]
		var frame_count = animation_data.animation_frame_counts[anim_name] - initial_index
		
		for dir in animation_data.available_directions:
			var anim_key = anim_name + "_" + dir
			var dir_y = animation_data.available_directions[dir]
			
			# Add animation to SpriteFrames
			sprite_frames.add_animation(anim_key)
			sprite_frames.set_animation_speed(anim_key, animation_data.animation_speeds[anim_name])
			sprite_frames.set_animation_loop(anim_key, animation_data.animation_loops[anim_name])
			var frame_size = animation_data.frame_sizes[anim_name]
			var animation_rows = animation_data.animation_rows[anim_name]
			# Add frames for this animation
			for frame_idx in range(frame_count):
				var atlas = AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2(
					(frame_idx + initial_index) * frame_size,  # x position
					dir_y * frame_size + (animation_rows * frame_size),      # y position
					frame_size,              # width
					frame_size               # height
				)
				sprite_frames.add_frame(anim_key, atlas)
	
	# Only play if the current animation exists
	if current_animation + "_" + direction in sprite_frames.get_animation_names():
		play(current_animation + "_" + direction)

func play_animation(anim_name: String = "idle", dir: String = "south"):
	if not animation_data:
		return
		
	if not anim_name in animation_textures or not animation_textures[anim_name]:
		push_error("Animation '%s' not found or texture not set" % anim_name)
		return
		
	if not dir in animation_data.available_directions:
		push_error("Direction '%s' not found" % dir)
		return
		
	current_animation = anim_name
	direction = dir
	play(current_animation + "_" + direction)
