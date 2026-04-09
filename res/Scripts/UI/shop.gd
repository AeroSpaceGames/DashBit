extends Control

var _shop = SaveShop
var _save = SaveGame

@export var song : AudioStreamPlayer

@export var blocked : AudioStream
@export var bought : AudioStream

@export var click : AudioStream

const BUY_PARTICLES = preload("res://Particles/buy_particles.tscn")

const SFX = preload("res://Scenes/SFX/break_sfx.tscn")

const group_res = preload("res://UI/group_template.tscn")

@onready var wtht_coins = $Lose_menu/ScrollContainer/Shop_flow/WthtCoins

var wanted_skin: String

#Creating shop
var shop_order: Array = [
	["Basics",
	["BW","BO",
	"CR","LG",
	"YB","MA",
	"ST","PC"]
	],
	["Printed",
	["YingYang","Magnet",
	"PG_H","BB_8",
	"LG_R","Kanji",
	"OB_H", "Alien",
	"Jack","Creeper"]
	],
	["Cross",
	["X_YP","X_GB",
	"X_RB","X_M",
	"X_RY","X_O"]
	],
	["Scary",
	["Ghost","Eye",
	"Skull","Bat",
	"Web","Pumpkin"]
	],
	["Winter",
	["Gift", "SMan",
	"Hat", "Snow",
	"P1", "P2"]
	]
	]

func _ready():
	if SaveShop.save_exists():
		_shop = SaveShop.load_savegame() as SaveShop
		SkinControl.skins_dic = _shop.skins_shop
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		StatsManager.coins = _save.coins_res
	SkinControl.conf()
	FlowControl.mode = FlowControl.modes.shop
	
	spawn_palettes()

##Spawns the groups
func spawn_palettes():
	for g in shop_order:
		for s in g[1]:
			var temp_group = group_res.instantiate()
			temp_group.rename_group(s)
			temp_group._set_palette(s)
			temp_group.connect("buy", _buy_palette)
			%Shop_flow.add_child(temp_group)
	
	await get_tree().create_timer(0.01).timeout
	create_shop(shop_order)

##Sorts and displays the shop
func create_shop(order: Array):
	#Organize shop positions
	var title_separation: int = 335
	for t in order:
		if order.find(t) != 0:
			%Shop_flow.get_node(t[0]).position = Vector2(180, (%Shop_flow.get_node(order[order.find(t)-1][0]).position.y + (title_separation * ceil(order[order.find(t) - 1][1].size() / 2.0))) + 483)
		var fix_spaces: int
		for p in t[1]:
			var actual_group: String = p + "_group"
			%Shop_flow.get_node(actual_group).position.x = (((t[1].find(p) % 2) + 1) * 320) + 3
			if (t[1].find(p) % 2) == 0:
				if t[1].find(p) != 0:
					%Shop_flow.get_node(actual_group).position.y =  %Shop_flow.get_node(t[0]).position.y + (t[1].find(p) - fix_spaces) * 383
					@warning_ignore("unassigned_variable_op_assign")
					fix_spaces += 1
				else:
					%Shop_flow.get_node(actual_group).position.y = 335 + %Shop_flow.get_node(t[0]).position.y
					fix_spaces = 0
			else:
				%Shop_flow.get_node(actual_group).position.y = %Shop_flow.get_node(t[1][t[1].find(p)- 1]  + "_group").position.y
	
	#Set shop depth
	var title_count: int = 0
	var skins_count: int = 0
	for c in order:
		title_count += 1
		skins_count += c[1].size()
	#region depth sizes
	var title_size: String = "a




 "
	var skins_size: String = "b














"
	#endregion
	for d in title_count:
		%Depth_control.text += title_size
	for s in ceil(skins_count/2.0):
		%Depth_control.text += skins_size
	
	
	#Set palletes colors by code
	for i in %Shop_flow.get_children():
		if i.name.trim_suffix("_group") in SkinControl.colors_set.keys():
			i.get_node(i.name.trim_suffix("_group") + "_b").material.set_shader_parameter("WhiteColor", SkinControl.colors_set[i.name.trim_suffix("_group")])
			i.get_node(i.name.trim_suffix("_group") + "_b").material.set_shader_parameter("BlackColor", SkinControl.colors_set[i.name.trim_suffix("_group")].inverted())
			if SkinControl.skins_dic[i.name.trim_suffix("_group")][1] == false:
				i.get_node(i.name.trim_suffix("_group") + "_b").material.set_shader_parameter("Locked", true)
	
	actual_selected()


func _buy_palette(nm: String):
	wanted_skin = nm
	
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = click
	add_child(temp_sfx)
	
	if SkinControl.skins_dic[wanted_skin][1] == true:
		SkinControl.new_skin = wanted_skin
		
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.saved_skin = SkinControl.new_skin
			
			_save.write_savegame()
		
		%SelectBorder.global_position = %Shop_flow.get_node(wanted_skin + "_group").global_position
		%SkinFace.material.set_shader_parameter("WhiteColor", SkinControl.colors_set[SkinControl.new_skin])
	else:
		if StatsManager.coins >= SkinControl.skins_dic[wanted_skin][0]:
			%CheckShop.show_panel(null, SkinControl.textures_set[shop_order.find(nm)])
			%ShopManDialogues.buy_things()
		else:
			poor()
	
	for g in %Shop_flow.get_children():
		if g.is_in_group("groups"):
			g._set_palette(g.name.trim_suffix("_group"))

func _really_buy():
	%ShopManDialogues.gain()
	SkinControl.buy_skin(wanted_skin,StatsManager.coins)
	
	if SkinControl.skins_dic[wanted_skin][1] == true:
		SkinControl.new_skin = wanted_skin
		
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.saved_skin = SkinControl.new_skin
			
			_save.write_savegame()
	
	%SelectBorder.global_position = %Shop_flow.get_node(wanted_skin + "_group").global_position
	%SkinFace.material.set_shader_parameter("WhiteColor", SkinControl.colors_set[SkinControl.new_skin])
	
	for g in %Shop_flow.get_children():
		if g.is_in_group("groups"):
			g._set_palette(g.name.trim_suffix("_group"))
	
	forget()

func forget():
	wanted_skin = ""

func actual_selected():
	if is_instance_valid(%Shop_flow.get_node(SkinControl.new_skin + "_group")):
		%SkinFace.material.set_shader_parameter("WhiteColor", SkinControl.colors_set[SkinControl.new_skin])
		%SelectBorder.global_position = %Shop_flow.get_node(SkinControl.new_skin + "_group").global_position


func _process(_delta):
	%Coins.text = str(StatsManager.coins)

func _on_menu_button_down():
	$Transition.play("In")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "In":
		get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")

func poor():
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = blocked
	add_child(temp_sfx)
	%Anims.play("Cry")
	$Without_coins.play("RESET")
	$Without_coins.play("Without")
	wtht_coins.global_position = get_global_mouse_position()

func particles_spawn(nm):
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = bought
	add_child(temp_sfx)
	var temp_buy = BUY_PARTICLES.instantiate()
	temp_buy.emitting = true
	temp_buy.global_position = %Shop_flow.get_node(nm + "_group").global_position
	self.get_node("Lose_menu").add_child(temp_buy)
