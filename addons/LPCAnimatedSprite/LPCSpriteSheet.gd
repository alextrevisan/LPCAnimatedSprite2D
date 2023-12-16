@tool
extends Resource
class_name LPCSpriteSheet

@export var SpriteSheet:Texture2D
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
	LPCAnimationData.new(8,"THRUST_UP",4, 0,false),
	LPCAnimationData.new(8,"THRUST_LEFT",5, 0,false),
	LPCAnimationData.new(8,"THRUST_DOWN",6, 0,false),
	LPCAnimationData.new(8,"THRUST_RIGHT",7, 0,false),
	LPCAnimationData.new(8,"WALK_UP",8, 1,true),
	LPCAnimationData.new(8,"WALK_LEFT",9, 1,true),
	LPCAnimationData.new(8,"WALK_DOWN",10, 1,true),
	LPCAnimationData.new(8,"WALK_RIGHT",11, 1,true),
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

var PreSlash:Array[LPCAnimationData] = [
	LPCAnimationData.new(6,"SLASH_UP",21, 0,false, 192),
	LPCAnimationData.new(6,"SLASH_LEFT",22, 0,false, 192),
	LPCAnimationData.new(6,"SLASH_DOWN",23, 0,false, 192),
	LPCAnimationData.new(6,"SLASH_RIGHT",24, 0,false, 192),
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

enum SpritesheetType
{
	SizeNormal,
	Size_6_6_8
}

func GetSpritesheetType():
	if SpriteSheet.get_height() == 3648:
		return SpritesheetType.Size_6_6_8
	return SpritesheetType.SizeNormal
	
func GetSpriteRect(animationData:LPCAnimationData, frame: int) -> Rect2:
	const startOfOversizedAnimation = 21;
	var spriteSize:int = animationData.Size
	match GetSpritesheetType():
		LPCSpriteSheet.SpritesheetType.SizeNormal:
			return Rect2(spriteSize*(frame+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)
		LPCSpriteSheet.SpritesheetType.Size_6_6_8:
			if animationData.Row < startOfOversizedAnimation:
				return Rect2(spriteSize*(frame+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)
			else:
				var startPosition:int = startOfOversizedAnimation * 64
				var row = animationData.Row - startOfOversizedAnimation
				return Rect2(spriteSize*(frame+animationData.Col), startPosition + spriteSize*row, spriteSize, spriteSize)
	return Rect2(spriteSize*(frame+animationData.Col), spriteSize*animationData.Row, spriteSize, spriteSize)
	
func AnimationData() -> Array[LPCAnimationData]:
	match SpriteType:
		SpriteTypeEnum.Normal:
			match GetSpritesheetType():
				SpritesheetType.SizeNormal:
					return NormalAnimationData
				SpritesheetType.Size_6_6_8:
					var animationData:Array[LPCAnimationData] = []
					animationData.append_array(NormalAnimationData)
					animationData.append_array(PreSlash)
					return animationData
				_:
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
