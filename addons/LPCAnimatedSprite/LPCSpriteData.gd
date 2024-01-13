class_name LPCAnimationData

var FrameCount:int
var Name:String
var Row:int
var Col:int
var Loop:bool
var Size:int
var Reverse:bool
func _init(frameCount:int, name:String, row:int, col:int, loop:bool, size:int = 64, reverse:bool = false):
		FrameCount = frameCount
		Name = name
		Row = row
		Col = col
		Loop = loop
		Size = size
		Reverse = reverse
