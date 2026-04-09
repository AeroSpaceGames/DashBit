extends Node

@export var low_limit: int = 50
@export var mid_limit: int = 100
@export var high_limit: int = 250

func measure():
	Difficulty.measure = false
	if StatsManager.points >= 0 and StatsManager.points < low_limit:
		return 0
	if StatsManager.points > low_limit and StatsManager.points < mid_limit:
		return 1
	if StatsManager.points > mid_limit and StatsManager.points < high_limit:
		return 1
	if StatsManager.points >= high_limit:
		return 2

func change_background(lvl: int):
	var t = create_tween()
	t.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	t.tween_property(%Background, "material:shader_parameter/blend", lvl, 2)
