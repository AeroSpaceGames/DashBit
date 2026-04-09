extends Resource
class_name Gift

# Probabilities = [Coins Prob, Lower Coins Limit, Upper Coins Limit, Skin Prob, Song Prob]

@export var normal_texture: CompressedTexture2D
@export var reduced_texture: CompressedTexture2D
@export var stats: Array = [0, 0, 0, 0, 0]
@export var prize_count: int
@export var bg_color: Color = Color.WHITE
