extends Resource
class_name LPCSpriteSheet

@export var SpriteSheet:Texture
@export var Name:String = ""

signal SpriteSheetChanged(texture:Texture)
signal NameChanged
