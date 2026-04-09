extends Control

@export var res: DiffRes

@onready var NameEdit = %NameEdit
@onready var DiffEdit = %DiffEdit
@onready var file_dialog: FileDialog = %FileDialog
@onready var Icon: TextureButton = $Icon
@onready var bg_visual: TextureRect = %BGVisual
@onready var particle_visual: TextureRect = %ParticleVisual
@onready var coins_slider: HSlider = %CoinsSlider
@onready var coins_label: Label = %CoinsLabel
@onready var main_col_edit: ColorPickerButton = %MainColEdit

var editing: bool = false

func load_data():
	res.internal_data = [res.Name, res.icon, res.diff, res.bg, res.particle, res.mechs, res.coins_convert, res.main_color]
	NameEdit.text = res.internal_data[0] #Shows the saved text when loading
	DiffEdit.select(res.internal_data[2]) #Shows the saved difficulty when loading
	Icon.texture_normal = res.internal_data[1] #Shows the saved icon when loading
	Icon.texture_pressed = res.internal_data[1]
	Icon.texture_hover = res.internal_data[1]
	Icon.texture_focused = res.internal_data[1]
	bg_visual.texture = res.internal_data[3] #Shows the saved background when loading
	particle_visual.texture = res.internal_data[4] #Shows the saved particle when loading
	var mechs_text: String = ""
	for i in res.internal_data[5]:
		mechs_text += str(i) + ","
	%MechsEdit.text = mechs_text #Shows the saved mechs ids when loading
	coins_slider.value = res.internal_data[6]
	coins_label.text = "Coins x" + str(res.internal_data[6])
	main_col_edit.color = res.internal_data[7]

func edit_mode():
	editing = true if editing == false else false
	%EditMode.visible = editing

func open_file_manager():
	file_dialog.show()

func connect_icon():
	file_dialog.connect("file_selected", select_icon)

func connect_bg():
	file_dialog.connect("file_selected", select_bg)

func connect_particle():
	file_dialog.connect("file_selected", select_particle)

#region value setters
func draw_name():
	change_value(0, NameEdit.text)

func new_difficulty(idx: int):
	change_value(2, idx)

func select_icon(path: String):
	change_value(1, load(path))
	Icon.texture_normal = get_value(1)
	Icon.texture_pressed = get_value(1)
	Icon.texture_hover = get_value(1)
	Icon.texture_focused = get_value(1)
	file_dialog.disconnect("file_selected", select_icon)

func select_bg(path: String):
	change_value(3, load(path))
	bg_visual.texture = get_value(3)
	file_dialog.disconnect("file_selected", select_bg)

func select_particle(path: String):
	change_value(4, load(path))
	particle_visual.texture = get_value(4)
	file_dialog.disconnect("file_selected", select_particle)

func mechs_changed():
	var mechs_text: Array = %MechsEdit.text.split(",",false)
	var mechs_idx: Array = []
	for t in mechs_text:
		if typeof(int(t)) == TYPE_INT:
			mechs_idx.append(int(t))
	
	change_value(5, mechs_idx)

func change_coins_mult(val: float):
	change_value(6, val)
	coins_label.text = "Coins x" + str(val)

func change_main_col(val: Color):
	change_value(7, val)
#endregion


func delete():
	queue_free()


func change_value(stat_id: int, new_val: Variant):
	match stat_id:
		##Change Name
		0:
			if typeof(new_val) == TYPE_STRING:
				res.Name = new_val
				res.internal_data[0] = res.Name
		
		##Change Icon
		1:
			if typeof(new_val) == TYPE_OBJECT:
				res.icon = new_val
				res.internal_data[1] = res.icon
		
		##Change Difficulty
		2:
			if typeof(new_val) == TYPE_INT:
				res.diff = new_val
				res.internal_data[2] = res.diff
		
		##Change Background
		3:
			if typeof(new_val) == TYPE_OBJECT:
				res.bg = new_val
				res.internal_data[3] = res.bg
		
		##Change Particles
		4:
			if typeof(new_val) == TYPE_OBJECT:
				res.particle = new_val
				res.internal_data[4] = res.particle
		
		##Change Mechanics
		5:
			if typeof(new_val) == TYPE_ARRAY:
				res.mechs = new_val
				res.internal_data[5] = res.mechs
		
		##Change Coins Multiplicator
		6:
			if typeof(new_val) == TYPE_FLOAT:
				res.coins_convert = new_val
				res.internal_data[6] = res.coins_convert
		
		##Change Main Color
		7:
			if typeof(new_val) == TYPE_COLOR:
				res.main_color = new_val
				res.internal_data[7] = res.main_color

func get_value(stat_id: int):
	return res.internal_data[stat_id]
