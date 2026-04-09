extends Node

var mod_interface_res = preload("res://UI/mod_interface.tscn")

@onready var mods_container = %ModsContainer
var _mod: ModSave

var loaded_mods: Array = []

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("play"):
			get_tree().change_scene_to_file("res://Scenes/loading.tscn")

func add_mod():
	var new_mod_interface = mod_interface_res.instantiate()
	mods_container.add_child(new_mod_interface)

func load_file():
	get_tree().call_group("ModInterface", "delete")
	##Check existance of save
	assert(ModSave.save_exists(), "ModSave not found to load.")
	if ModSave.save_exists():
		_mod = ModSave.load_savegame() as ModSave
		for i in len(_mod.mods):
			print(_mod.mods[i])
			var new_mod_interface = mod_interface_res.instantiate()
			mods_container.add_child(new_mod_interface)
			new_mod_interface.load_data(_mod.mods[i])

func save_file():
	var data_arr: Array #The file saves an Array
	for i in mods_container.get_children():
		if i.has_method("save_data"):
			data_arr.push_back(i.save_data()) #The Array saves dictionaries with the data of each mod
	
	assert(typeof(data_arr) == TYPE_ARRAY, "Invalid type of variable in data_arr.")
	if ModSave.save_exists():
		_mod = ModSave.load_savegame() as ModSave
		_mod.mods = data_arr
		_mod.write_savegame()
	else:
		_mod = ModSave.new()
		_mod.mods = data_arr
		_mod.write_savegame()
