extends Resource
class_name DiffRes

@export var Name: String
@export var diff: int
@export var icon: CompressedTexture2D
@export var mechs: Array
@export var bg: CompressedTexture2D
@export var particle: CompressedTexture2D
@export var coins_convert: float
@export var main_color: Color
@export var internal_data: Array = [Name, diff, icon, bg, particle ,mechs, coins_convert, main_color]
