extends Node

@export var points : int = 0
@onready var point_anim = get_tree().get_root().get_node("Main/Stats")

@export var max_life : float = 30.0
@export var life : float = max_life
@onready var life_anim = get_tree().get_root().get_node("Main/Stats/Canvas/Life_bar")

@onready var hurt_parts = get_tree().get_root().get_node("Main/PlayableZone/Hurt")

@export var coins : int

@export var bests : Array = [0,0,0]

@export var visuals: bool = true

func conf():
	point_anim = get_tree().get_root().get_node("Main/Stats") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Stats")
	life_anim = get_tree().get_root().get_node("Main/Stats/Canvas/Life_bar") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Stats/Canvas/Life_bar")
	hurt_parts = get_tree().get_root().get_node("Main/PlayableZone/Hurt") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/PlayableZone/Hurt")

func restart():
	points = 0

func change_p(n):
	if ComboManager.multiplier >= 2:
		points += n * ComboManager.multiplier
		point_anim.color_change()
		point_anim.animation() 
		point_anim.show_combo()
	else:
		points += n
		point_anim.color_change()
		point_anim.animation()
		

func hurt(n):
	point_anim.color_reset()
	hurt_parts.emitting = true
	if life > 0:
		life -= n
	else:
		life = 0
	life_anim.health = life

func heal(n):
	if life + n < max_life:
		life += n
	else:
		life = max_life
	life_anim.health = life
