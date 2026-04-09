extends Control

var _save : SaveGame

func _ready() -> void:
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		if _save.first_time == true:
			_save.first_time = false
			_save.write_savegame()
	
	var bests_saved : Array = [_save.begginer_best, _save.pro_best, _save.dashcore_best]
	for i in 3:
		StatsManager.bests[i] = bests_saved[i]
	
	%Begginer_best.text = str(StatsManager.bests[0])
	%Pro_best.text = str(StatsManager.bests[1])
	%DashCore_best.text = str(StatsManager.bests[2])


func _on_menu_button_down():
	$Transition.play("In")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "In":
		get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")
