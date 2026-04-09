extends Node

func _on_label_pressed() -> void:
	Difficulty.diff = 15
	get_tree().change_scene_to_file("res://Scenes/Principals/Main.tscn")
