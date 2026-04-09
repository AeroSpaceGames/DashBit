extends Control

@onready var dif_text = $CanvasLayer/Diff_text

@export var song : AudioStreamPlayer

const SFX = preload("res://Scenes/SFX/break_sfx.tscn")
@export var click : AudioStream

var _save: SaveGame

func _ready():
	##ModManager
	read_mod_decorations()
	$GamepassReader.load_gamepass()
	
	Difficulty.diff = 0
	%Visuals.self_modulate = Color(0,1,0) if StatsManager.visuals else Color(1,0,0)
	FlowControl.mode = FlowControl.modes.menu
	
	dif_text.text = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][0]
	%Visual_dif.texture_normal = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][1]
	%Visual_dif.texture_pressed = %Visual_dif.texture_normal
	%Visual_dif.texture_hover = %Visual_dif.texture_normal
	
	$LevelsManager.set_background()
	$LevelsManager.locked()

func read_mod_decorations():
	if len(ModsManager.active_mod.keys()) > 0:
		%Decoration.get_child(0).texture = ModsManager.active_mod["2"] if ModsManager.active_mod["2"] != null else CompressedTexture2D.new()
		%Decoration.get_child(1).texture = ModsManager.active_mod["2"] if ModsManager.active_mod["2"] != null else CompressedTexture2D.new()
		%Decoration.get_child(2).texture = ModsManager.active_mod["3"] if ModsManager.active_mod["3"] != null else CompressedTexture2D.new()


func _on_play_button_button_down():
	if Difficulty.diff == 3:
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.new_diff = true
			_save.write_savegame()
	$Transition.play("In")
	$Show_shop.play("RESET")

func _on_show_shop_animation_finished(anim_name: StringName) -> void:
	if anim_name == "RESET":
		get_tree().change_scene_to_file("res://Scenes/Principals/Main.tscn")


func _on_visual_dif_button_down():
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = click
	add_child(temp_sfx)
	$Diff_anim.play("Bump")
	
	Difficulty.diff += 1
	Difficulty.diff %= ModsManager.number_of_diffs()
	
	dif_text.text = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][0]
	%Visual_dif.texture_normal = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][1]
	%Visual_dif.texture_pressed = %Visual_dif.texture_normal
	%Visual_dif.texture_hover = %Visual_dif.texture_normal
	
	
	$LevelsManager.check_level()


func _on_shop_button_down():
	$Transition.play("In")
	$Shop_anim.play("Bump")

func _on_shop_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bump":
		get_tree().change_scene_to_file("res://UI/shop.tscn")


func _on_songs_button_down() -> void:
	$Transition.play("In")
	$Songs_anim.play("Bump")

func _on_songs_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bump":
		get_tree().change_scene_to_file("res://UI/songs.tscn")


func _on_trophies_button_down() -> void:
	$Transition.play("In")
	$Trophy_anim.play("Bump")

func _on_trophy_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bump":
		get_tree().change_scene_to_file("res://UI/trophy_room.tscn")



func _on_diff_anim_animation_finished(anim_name):
	if anim_name == "Show_all":
		dif_text.text = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][0]
		%Visual_dif.texture_normal = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][1]
		%Visual_dif.texture_pressed = %Visual_dif.texture_normal
		%Visual_dif.texture_hover = %Visual_dif.texture_normal

func change_visuals():
	StatsManager.visuals = false if StatsManager.visuals else true
	%Visuals.self_modulate = Color(0,1,0) if StatsManager.visuals else Color(1,0,0)
	
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		_save.vfx_activated = StatsManager.visuals
		_save.write_savegame()
