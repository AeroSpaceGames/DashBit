extends Node

@export var combo : int
@export var multiplier : int = 1 : set = multi_change

@onready var combo_anim : AnimationPlayer = get_tree().get_root().get_node("Main/Combo_show")

@export var combo_curve: Curve = preload("res://Curves/Combo_curve.tres")

var once = true

func conf():
	combo_anim = get_tree().get_root().get_node("Main/Combo_show") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Combo_show")

func add():
	if multiplier == 0:
		multiplier = 1
	if combo + 1 < combo_curve.sample(multiplier):
		combo += 1 
	else:
		if multiplier + 1 < Difficulty.diff + 4:
			multiplier += 1
			combo = 0

func loose():
	combo = 0
	multiplier = 1

func multi_change(_new_val):
	multiplier = _new_val
	if is_instance_valid(combo_anim):
		if multiplier >= 2:
			if once == true:
				combo_anim.play("Show")
				once = false
		else:
			once = true
			combo_anim.play("Hide")
	
