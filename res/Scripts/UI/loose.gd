extends Control

@export var song : AudioStreamPlayer

var _save : SaveGame
var _box : BoxSave
var _gift: GiftSave

@export var begginer : Texture2D
@export var pro : Texture2D
@export var dashcore : Texture2D
@export var spooky : Texture2D
@export var winter : Texture2D
@export var easter : Texture2D

@export var basic : Texture2D
@export var special : Texture2D
@export var VIP : Texture2D

var VIP_grant: float

var real_coins: int = 0

func _ready():
	var acumulated_coins: int
	if Difficulty.diff != 15:
		acumulated_coins = int(StatsManager.points * ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][6])
	else:
		acumulated_coins = 0
	
	
	%Background.self_modulate = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][7] if Difficulty.diff != 15 else Color.WHITE
	%Diff.texture = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][1] if Difficulty.diff != 15 else easter
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame()
		_save.coins_res = StatsManager.coins
		@warning_ignore("integer_division")
		_save.coins_res += acumulated_coins
		match Difficulty.diff:
			0:
				if StatsManager.points > _save.begginer_best:
					_save.begginer_best = StatsManager.points
			1:
				if StatsManager.points > _save.pro_best:
					_save.pro_best = StatsManager.points
			2:
				if StatsManager.points > _save.dashcore_best:
					_save.dashcore_best = StatsManager.points
		real_coins = _save.coins_res
		_save.write_savegame()
	
	%Coins.text = str(acumulated_coins) if Difficulty.diff != 15 else "0"
	VIP_grant = StatsManager.points/((1/ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][6]) * 500) if Difficulty.diff != 15 else 0
	
	
	
	StatsManager.coins = real_coins
	
	FlowControl.mode = FlowControl.modes.loose
	
	if Difficulty.diff != 15:
		if GiftSave.save_exists():
			_gift = GiftSave.load_savegame() as GiftSave
			_gift.gift_progress += StatsManager.points
			_gift.write_savegame()
		calc_boxes()
		gift_progress()
	
	%Points.text = "[wave amp=80 freq=5]" + str(StatsManager.points)
	
	##Center Pos
	%CoinsGroup.global_position.x = 360 - (30 * (len(%Coins.text) - 1))

func gift_progress():
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		_save.levels_progress += StatsManager.points
		_save.write_savegame()

func calc_boxes():
	var n_boxes: int = 0
	var box_node: int = 0
	@warning_ignore("integer_division")
	for p in max(int(VIP_grant * 10), 0):
		var rng: int = randi_range(0,20)
		if rng == 3:
			n_boxes += 1
	if BoxSave.save_exists():
		_box = BoxSave.load_savegame() as BoxSave
		for i in _box.boxes_list.keys():
			if VIP_grant < 1:
				box_node += 1
				if n_boxes > 0:
					if _box.boxes_list[i][0] == 0:
						var n_rng: int = randi_range(0,20)
						if n_rng <= 12:
							_box.boxes_list[i][0] = 1
							$Lose_menu.get_node("Box%s" % str(box_node)).texture = basic
						elif n_rng > 12 and n_rng <= 18:
							_box.boxes_list[i][0] = 2
							$Lose_menu.get_node("Box%s" % str(box_node)).texture = special
						elif n_rng > 18 and n_rng <= 20:
							_box.boxes_list[i][0] = 3
							$Lose_menu.get_node("Box%s" % str(box_node)).texture = VIP
						var box_ref = $Lose_menu.get_node("Box%s" % str(box_node))
						box_ref.reparent(%Container)
						n_boxes -= 1
			else:
				box_node += 1
				if n_boxes > 0:
					if _box.boxes_list[i][0] == 0:
						_box.boxes_list[i][0] = 3
						$Lose_menu.get_node("Box%s" % str(box_node)).texture = VIP
						var box_ref = $Lose_menu.get_node("Box%s" % str(box_node))
						box_ref.reparent(%Container)
						n_boxes -= 1
				VIP_grant -= 1
		_box.write_savegame()


func _on_continue_button_down():
	FlowControl.mode = FlowControl.modes.paused
	$Transition.play("In")

func _on_menu_button_down():
	Difficulty.diff = 0
	FlowControl.mode = FlowControl.modes.menu
	$Transition.play("In")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "In":
		if FlowControl.mode == FlowControl.modes.menu:
			get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")
		if FlowControl.mode == FlowControl.modes.paused:
			get_tree().change_scene_to_file("res://Scenes/Principals/Main.tscn")

func _on_continue_mouse_entered():
	%Continue.modulate = Color(0.725, 0.725, 0.725)

func _on_continue_mouse_exited():
	%Continue.modulate = Color(1, 1, 1)

func _on_menu_mouse_entered():
	%Menu.modulate = Color(0.725, 0.725, 0.725)

func _on_menu_mouse_exited():
	%Menu.modulate = Color(1, 1, 1)
