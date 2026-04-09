extends Node

@export var left_padding: int = 1

@onready var gamepass: Control = %Gamepass
@onready var progress: TextureProgressBar = %Progress
@onready var gift_points: Label = %GiftPoints
@onready var gifts_container: HBoxContainer = %GiftsContainer

var gift_scene = preload("res://Scenes/Boxes/gift.tscn")

var _gift: GiftSave

var real_step_val: float = 0

func load_gamepass():
	if ModsManager.active_mod["4"]:
		
		if gifts_container.get_child_count() > 0: ##Delete previous extra gifts
			for d in gifts_container.get_children():
				d.queue_free()
		
		##Ubicate Gifts Container
		progress.max_value = ModsManager.active_mod["5"][7]
		gifts_container.global_position.x = progress.global_position.x + (left_padding * (gifts_container.size.x / ModsManager.active_mod["5"][3]))
		gifts_container.size.x = progress.size.x - (gifts_container.global_position.x - progress.global_position.x)
		
		draw_progress()
		
		##Sort Gifts
		var gift_img = ModsManager.active_mod["5"][5].reduced_texture
		var big_gift_img = ModsManager.active_mod["5"][6].reduced_texture
		
		for i in ModsManager.active_mod["5"][3]:
			var temp_gift = gift_scene.instantiate()
			temp_gift.img = gift_img
			if (i+1)%ModsManager.active_mod["5"][4] == 0:
				temp_gift.great = true
				temp_gift.img = big_gift_img
			gifts_container.add_child(temp_gift)
		gifts_container.add_theme_constant_override("separation", 0)
		var new_sep = (gifts_container.size.x - (gifts_container.get_child_count() * gifts_container.size.y)) / (gifts_container.get_child_count() - 1)
		gifts_container.add_theme_constant_override("separation", new_sep)
		
		check_gifts()
	else:
		gamepass.hide()

func draw_progress():
	gamepass.show()
	progress.tint_progress = ModsManager.active_mod["5"][1]
	progress.tint_under = ModsManager.active_mod["5"][2]

	if GiftSave.save_exists():
		_gift = GiftSave.load_savegame() as GiftSave
		progress.value = _gift.gift_progress
		gift_points.text = str(_gift.gift_progress)

func check_gifts():
	var gifts_values: float = progress.max_value/ModsManager.active_mod["5"][3]
	if GiftSave.save_exists():
		_gift = GiftSave.load_savegame() as GiftSave
		
		for y in len(_gift.opened):
			gifts_container.get_child(y).state = _gift.opened[y]
			gifts_container.get_child(y)._search_state()
		
		for i in len(_gift.opened):
			if _gift.opened[i] == 0:
				if _gift.gift_progress >= gifts_values * (i+1):
					_gift.opened[i] = 1
				gifts_container.get_child(i).state = _gift.opened[i]
				gifts_container.get_child(i)._search_state()
		_gift.write_savegame()
	
