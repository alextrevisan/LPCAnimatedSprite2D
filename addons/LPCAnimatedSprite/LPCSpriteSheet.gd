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
	LPCAnimationData.new(7,"CAST_UP",0, 0,false),
	LPCAnimationData.new(7,"CAST_LEFT",1, 0,false),
	LPCAnimationData.new(7,"CAST_DOWN",2, 0,false),
	LPCAnimationData.new(7,"CAST_RIGHT",3, 0,false),
	LPCAnimationData.new(8,"WALK_UP",8, 0,true),
	LPCAnimationData.new(8,"WALK_LEFT",9, 0,true),
	LPCAnimationData.new(8,"WALK_DOWN",10, 0,true),
	LPCAnimationData.new(8,"WALK_RIGHT",11, 0,true),
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
var OversizeRodAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"ROD_UP",0, 0,false),
	LPCAnimationData.new(6,"ROD_LEFT",1, 0,false),
	LPCAnimationData.new(6,"ROD_DOWN",2, 0,false),
	LPCAnimationData.new(6,"ROD_RIGHT",3, 0,false),
]
var ThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(8,"THRUST_UP",4, 0,false),
	LPCAnimationData.new(8,"THRUST_LEFT",5, 0,false),
	LPCAnimationData.new(8,"THRUST_DOWN",6, 0,false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7, 0,false),
]
var OversizeThrustAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"THRUST_UP",0, 0,false),
	LPCAnimationData.new(6,"THRUST_LEFT",1, 0,false),
	LPCAnimationData.new(6,"THRUST_DOWN",2, 0,false),
	LPCAnimationData.new(6,"THRUST_RIGHT",3, 0,false),
]
var SlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",12, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",13, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",14, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",15, 0,false),
]
var OversizeSlashAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",0, 0,false),
	LPCAnimationData.new(6,"SLASH_LEFT",1, 0,false),
	LPCAnimationData.new(6,"SLASH_DOWN",2, 0,false),
	LPCAnimationData.new(6,"SLASH_RIGHT",3, 0,false),
]
var WhipAnimationData:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"WHIP_UP",12, 0,false),
	LPCAnimationData.new(6,"WHIP_LEFT",13, 0,false),
	LPCAnimationData.new(6,"WHIP_DOWN",14, 0,false),
	LPCAnimationData.new(6,"WHIP_RIGHT",15, 0,false),
]
var OversizeWhipAnimationData:Array[LPCAnimationData] = [
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

func AddIfOversized(oversize_type, over: Array[LPCAnimationData], normal: Array[LPCAnimationData]) -> Array[LPCAnimationData]:
	if SpriteType == oversize_type:
		return over
	else:
		return normal

func AnimationData() -> Array[LPCAnimationData]:
	var _animationData: Array = NormalAnimationData
		
	_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeRod, OversizeRodAnimationData, []))
	_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeThrust, OversizeThrustAnimationData, ThrustAnimationData))
	_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeSlash, OversizeSlashAnimationData, SlashAnimationData))
	_animationData.append_array(AddIfOversized(SpriteTypeEnum.OversizeWhip, OversizeWhipAnimationData, WhipAnimationData))
	
	return _animationData
