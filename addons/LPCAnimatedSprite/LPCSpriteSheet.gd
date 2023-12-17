@tool
extends Resource
class_name LPCSpriteSheet

@export var SpriteSheet:Texture
@export var Name:String = ""

@export var SpriteType: SpriteTypeEnum

enum SpriteTypeEnum {
	Normal,
	OversizeRod,
	OversizeThrust,
	OversizeSlash,
	OversizeWhip
}

var NormalAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(7,"CAST_UP",0, 0,false, Vector2.UP, "CAST", false),
	LPCAnimationData.new(7,"CAST_LEFT",1, 0,false, Vector2.LEFT, "CAST", false),
	LPCAnimationData.new(7,"CAST_DOWN",2, 0,false, Vector2.DOWN, "CAST", false),
	LPCAnimationData.new(7,"CAST_RIGHT",3, 0,false, Vector2.RIGHT, "CAST", false),
	LPCAnimationData.new(8,"WALK_UP",8, 0,true, Vector2.UP, "WALK", false),
	LPCAnimationData.new(8,"WALK_LEFT",9, 0,true, Vector2.LEFT,"WALK", false),
	LPCAnimationData.new(8,"WALK_DOWN",10, 0,true, Vector2.DOWN,"WALK", false),
	LPCAnimationData.new(8,"WALK_RIGHT",11, 0,true, Vector2.RIGHT,"WALK", false),
	LPCAnimationData.new(13,"SHOOT_UP",16, 0,false, Vector2.UP,"SHOOT", false),
	LPCAnimationData.new(13,"SHOOT_LEFT",17, 0,false, Vector2.LEFT,"SHOOT", false),
	LPCAnimationData.new(13,"SHOOT_DOWN",18, 0,false, Vector2.DOWN,"SHOOT", false),
	LPCAnimationData.new(13,"SHOOT_RIGHT",19, 0,false, Vector2.RIGHT,"SHOOT", false),
	LPCAnimationData.new(6,"HURT_DOWN",20, 0,false, Vector2.DOWN,"HURT", false),
	LPCAnimationData.new(1,"IDLE_UP",8, 0,false, Vector2.UP,"IDLE", false),
	LPCAnimationData.new(1,"IDLE_LEFT",9, 0,false, Vector2.LEFT,"IDLE", false),
	LPCAnimationData.new(1,"IDLE_DOWN",10, 0,false, Vector2.DOWN,"IDLE", false),
	LPCAnimationData.new(1,"IDLE_RIGHT",11, 0,false, Vector2.RIGHT,"IDLE", false),
	LPCAnimationData.new(1,"HURT_DOWN_LAST",20, 5,false, Vector2.DOWN, "HURT_DOWN_LAST", false),
]
var OversizeRodAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"ROD_UP",0, 0,false, Vector2.UP,"ROD", true),
	LPCAnimationData.new(6,"ROD_LEFT",1, 0,false, Vector2.LEFT,"ROD", true),
	LPCAnimationData.new(6,"ROD_DOWN",2, 0,false, Vector2.DOWN,"ROD", true),
	LPCAnimationData.new(6,"ROD_RIGHT",3, 0,false, Vector2.RIGHT,"ROD", true),
]
var ThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(8,"THRUST_UP",4, 0,false, Vector2.UP, "THRUST", false),
	LPCAnimationData.new(8,"THRUST_LEFT",5, 0,false, Vector2.LEFT, "THRUST", false),
	LPCAnimationData.new(8,"THRUST_DOWN",6, 0,false, Vector2.DOWN, "THRUST", false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7, 0,false, Vector2.RIGHT, "THRUST", false),
]
var OversizeThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"THRUST_UP",0, 0,false, Vector2.UP, "THRUST", true),
	LPCAnimationData.new(6,"THRUST_LEFT",1, 0,false, Vector2.LEFT, "THRUST", true),
	LPCAnimationData.new(6,"THRUST_DOWN",2, 0,false, Vector2.DOWN, "THRUST", true),
	LPCAnimationData.new(6,"THRUST_RIGHT",3, 0,false, Vector2.RIGHT, "THRUST", true),
]
var SlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",12, 0,false, Vector2.UP, "SLASH", false),
	LPCAnimationData.new(6,"SLASH_LEFT",13, 0,false, Vector2.LEFT, "SLASH", false),
	LPCAnimationData.new(6,"SLASH_DOWN",14, 0,false, Vector2.DOWN, "SLASH", false),
	LPCAnimationData.new(6,"SLASH_RIGHT",15, 0,false, Vector2.RIGHT, "SLASH", false),
]
var OversizeSlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",0, 0,false, Vector2.UP, "SLASH", true),
	LPCAnimationData.new(6,"SLASH_LEFT",1, 0,false, Vector2.LEFT, "SLASH", true),
	LPCAnimationData.new(6,"SLASH_DOWN",2, 0,false, Vector2.DOWN, "SLASH", true),
	LPCAnimationData.new(6,"SLASH_RIGHT",3, 0,false, Vector2.RIGHT, "SLASH", true),
]
var WhipAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"WHIP_UP",12, 0,false, Vector2.UP, "WHIP", false),
	LPCAnimationData.new(6,"WHIP_LEFT",13, 0,false, Vector2.LEFT, "WHIP", false),
	LPCAnimationData.new(6,"WHIP_DOWN",14, 0,false, Vector2.DOWN, "WHIP", false),
	LPCAnimationData.new(6,"WHIP_RIGHT",15, 0,false, Vector2.RIGHT, "WHIP", false),
]
var OversizeWhipAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(8,"WHIP_UP",0, 0,false, Vector2.UP, "WHIP", true),
	LPCAnimationData.new(8,"WHIP_LEFT",1, 0,false, Vector2.LEFT, "WHIP", false),
	LPCAnimationData.new(8,"WHIP_DOWN",2, 0,false, Vector2.DOWN, "WHIP", false),
	LPCAnimationData.new(8,"WHIP_RIGHT",3, 0,false, Vector2.RIGHT, "WHIP", false),
]

func Size() -> int:
	match SpriteType:
		SpriteTypeEnum.Normal:
			return 64
		_:
			return 192

func AddIfOversized(oversize_type, over: Array[LPCAnimationData], normal: Array[LPCAnimationData]) -> Array[LPCAnimationData]:
	if SpriteType == oversize_type:
		return over
	else:
		return normal

func AnimationData() -> Array[LPCAnimationData]:
	#var _animationData: Array = NormalAnimationData
		
	#_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeRod, OversizeRodAnimationData, []))
	#_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeThrust, OversizeThrustAnimationData, ThrustAnimationData))
	#_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeSlash, OversizeSlashAnimationData, SlashAnimationData))
	#_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeWhip, OversizeWhipAnimationData, WhipAnimationData))
	
	#return _animationData
	match SpriteType:
		SpriteTypeEnum.Normal:
			return NormalAnimationData
		SpriteTypeEnum.OversizeThrust:
			return ThrustAnimationData
		SpriteTypeEnum.OversizeSlash:
			return SlashAnimationData
		SpriteTypeEnum.OversizeWhip:
			return WhipAnimationData
		_:
			return NormalAnimationData
