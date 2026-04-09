extends Node

@onready var white_sprite: AnimatedSprite2D = $"../White_sprite"
@onready var black_sprite: AnimatedSprite2D = $"../Black_sprite"

func set_players_color():
	white_sprite.material.set_shader_parameter("WhiteColor",SkinControl.colors_set[SkinControl.new_skin])
	black_sprite.material.set_shader_parameter("BlackColor",SkinControl.colors_set[SkinControl.new_skin].inverted())
