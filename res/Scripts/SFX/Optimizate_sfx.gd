extends Node2D

func _ready():
	if get_child(0).name == "Break":
		get_child(0).pitch_scale = randf_range(0.8,1.2)
		get_child(0).volume_db = randf_range(-6,-7.5)

func _on_break_finished():
	queue_free()
