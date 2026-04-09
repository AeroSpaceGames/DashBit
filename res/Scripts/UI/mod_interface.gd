extends Control

var editing: bool = false

var diff_res = preload("res://UI/diff_interface.tscn")

var undefined_texture: CompressedTexture2D = preload("res://Assets/PNG/UndefinedTexture.png")

@onready var edit_panel: CanvasLayer = $EditMode
@onready var name_label: Label = $Name
@onready var StatsSave: Node = %StatsSave
@onready var DiffsContainer: VBoxContainer = %DiffsContainer
@onready var NameEdit: TextEdit = %NameEdit
@onready var img_dialog: FileDialog = %ImageDialog
@onready var res_dialog: FileDialog = %ResDialog
@onready var main_color: ColorPickerButton = %MainColor
@onready var upper_color: ColorPickerButton = %UpperColor
@onready var bottom_color: ColorPickerButton = %BottomColor
@onready var steps_edit: SpinBox = %StepsEdit
@onready var last_gift: SpinBox = %LastGift
@onready var gift_visual: TextureRect = %GiftVisual
@onready var big_gift_visual: TextureRect = %BigGiftVisual
@onready var mod_bg_visual: TextureRect = %ModBGVisual
@onready var title_visual: TextureRect = %TitleVisual
@onready var deco_visual: TextureRect = %DecoVisual
@onready var bg_panel: TextureRect = %BG_Panel
@onready var points_label: Label = %PointsLabel
@onready var points_edit: HSlider = %PointsEdit


func _ready() -> void:
	edit_panel.visible = editing


func edit_mode():
	editing = true if editing == false else false
	edit_panel.visible = editing

func delete():
	queue_free()

func select():
	ModsManager.active_mod = save_data()
	print("New mod data: ", ModsManager.active_mod)

func add_diff():
	var new_diff = diff_res.instantiate()
	DiffsContainer.add_child(new_diff)


func open_file_manager():
	img_dialog.show()

func open_res_manager():
	res_dialog.show()

func connect_to_bg():
	img_dialog.connect("file_selected", change_bg)

func connect_to_deco():
	img_dialog.connect("file_selected", change_deco)

func connect_to_title():
	img_dialog.connect("file_selected", change_title)

func connect_to_gift():
	res_dialog.connect("file_selected", edit_gift_res)

func connect_to_big_gift():
	res_dialog.connect("file_selected", edit_big_gift_res)

#region edit values
func draw_name():
	StatsSave.change_value(0, %NameEdit.text)
	name_label.text = StatsSave.get_value(0)

func change_bg(path: String):
	StatsSave.change_value(1, load(path))
	bg_panel.texture = StatsSave.get_value(1)
	mod_bg_visual.texture = StatsSave.get_value(1)
	img_dialog.disconnect("file_selected", change_bg)

func change_deco(path: String):
	StatsSave.change_value(2, load(path))
	deco_visual.texture = StatsSave.get_value(2)
	img_dialog.disconnect("file_selected", change_deco)

func change_title(path: String):
	StatsSave.change_value(3, load(path))
	title_visual.texture = StatsSave.get_value(3)
	img_dialog.disconnect("file_selected", change_title)

func check_gamepass():
	var next_val = true if StatsSave.get_value(4) == false else false
	StatsSave.change_value(4, next_val)
	%GamepassContainer.visible = StatsSave.get_value(4)

func change_main_color(col: Color):
	StatsSave.change_value(5, col)


func change_upper_color(col: Color):
	StatsSave.change_value(6, col)

func change_bottom_color(col: Color):
	StatsSave.change_value(7, col)

func edit_steps(val: float):
	StatsSave.change_value(8, int(val))

func edit_last_gift(val: float):
	StatsSave.change_value(9, int(val))

func edit_gift_res(path: String):
	StatsSave.change_value(10, load(path))
	gift_visual.texture = StatsSave.get_value(5)[5].normal_texture if StatsSave.get_value(5)[5].normal_texture != null else undefined_texture
	res_dialog.disconnect("file_selected", edit_gift_res)

func edit_big_gift_res(path: String):
	StatsSave.change_value(11, load(path))
	big_gift_visual.texture = StatsSave.get_value(5)[6].normal_texture if StatsSave.get_value(5)[6].normal_texture != null else undefined_texture
	res_dialog.disconnect("file_selected", edit_big_gift_res)

func edit_points(val: float):
	StatsSave.change_value(12, int(val))
	points_label.text = str(StatsSave.get_value(5)[7])
#endregion


func save_data() -> Dictionary:
	var final_data = {}
	
	#Save mod data
	for i in 5:
		final_data[str(i)] = StatsSave.get_value(i)
	final_data["ExtraDiffs"] = []
	if DiffsContainer.get_child_count() > 0:
		for d in DiffsContainer.get_children():
			var diff_data: Array = []
			for g in len(d.res.internal_data):
				diff_data.append(d.res.internal_data[g])
			final_data["ExtraDiffs"].append(diff_data)
	if StatsSave.get_value(4) == true:
		final_data["5"] = StatsSave.get_value(5)
	
	
	return final_data

func load_data(data: Dictionary):
	for i in data.keys():
		if i != "ExtraDiffs" and i != "4":
			##Mod Values
			StatsSave.change_value(int(i), data[i])
			name_label.text = StatsSave.get_value(0)
			NameEdit.text = StatsSave.get_value(0)
			bg_panel.texture = StatsSave.get_value(1) if StatsSave.get_value(1) != null else undefined_texture
			mod_bg_visual.texture = StatsSave.get_value(1) if StatsSave.get_value(1) != null else undefined_texture
			deco_visual.texture = StatsSave.get_value(2) if StatsSave.get_value(2) != null else undefined_texture
			title_visual.texture = StatsSave.get_value(3) if StatsSave.get_value(3) != null else undefined_texture

		elif i == "4": ##Gamepass load
			StatsSave.change_value(int(i), data[i])
			%HasGMPEdit.button_pressed = StatsSave.get_value(4)
			%GamepassContainer.visible = StatsSave.get_value(4)
			if StatsSave.get_value(4): ##Load Parameters
				for g in range(5,len(data["5"]) + 5):
					StatsSave.change_value(g, data["5"][g - 5])
				
				main_color.color = StatsSave.get_value(5)[0]
				upper_color.color = StatsSave.get_value(5)[1]
				bottom_color.color = StatsSave.get_value(5)[2]
				steps_edit.value = StatsSave.get_value(5)[3]
				last_gift.value = StatsSave.get_value(5)[4]
				gift_visual.texture = StatsSave.get_value(5)[5].normal_texture if StatsSave.get_value(5)[5] != Gift else undefined_texture
				big_gift_visual.texture = StatsSave.get_value(5)[6].normal_texture if StatsSave.get_value(5)[6] != Gift else undefined_texture
				points_edit.value = StatsSave.get_value(5)[7]
				points_label.text = str(StatsSave.get_value(5)[7])
			
		elif i == "ExtraDiffs": ##Extra difficulties load
			if len(data[i]) > 0:
				##Difficulties
				for n in len(data[i]):
					var new_diff = diff_res.instantiate()
					new_diff.res.Name = data[i][n][0] if typeof(data[i][n][0]) == TYPE_STRING else "New Diff"
					new_diff.res.icon = data[i][n][1] if typeof(data[i][n][1]) == TYPE_OBJECT else undefined_texture
					new_diff.res.diff = data[i][n][2] if typeof(data[i][n][2]) == TYPE_INT else 0
					new_diff.res.bg = data[i][n][3] if typeof(data[i][n][3]) == TYPE_OBJECT else undefined_texture
					new_diff.res.particle = data[i][n][4] if typeof(data[i][n][4]) == TYPE_OBJECT else undefined_texture
					new_diff.res.mechs = data[i][n][5] if data[i][n][5] != null else []
					new_diff.res.coins_convert = data[i][n][6] if data[i][n][6] != null else 1.0
					new_diff.res.main_color = data[i][n][7] if data[i][n][7] != null else Color.WHITE
					DiffsContainer.add_child(new_diff)
					new_diff.load_data()
