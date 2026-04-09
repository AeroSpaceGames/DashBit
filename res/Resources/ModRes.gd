extends Resource
class_name Mod

@export var Name: String
@export var BG_panel: CompressedTexture2D
@export var decoration: CompressedTexture2D
@export var title: CompressedTexture2D
@export var has_gamepass: bool = false
@export var gamepass: Array = [Color.WHITE, Color.WHITE, Color.WHITE, 0, 0, Gift.new(), Gift.new(), 0]
