class_name LPCAnimationData

var FrameCount:int
var Name:String
var Row:int
var Col:int
var Loop:bool
var Direction:Vector2
var Type:String
var Oversize:bool
func _init(frameCount:int, name:String, row:int, col:int, loop:bool, direction:Vector2, type: String, oversize: bool):
		FrameCount = frameCount
		Name = name
		Row = row
		Col = col
		Loop = loop
		Direction = direction
		Type = type
		Oversize = oversize
