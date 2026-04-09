extends Control

var _shop = SaveShop
var _save = SaveGame

@export var song : AudioStreamPlayer

@export var owned_texture : Texture2D
@export var normal_texture : Texture2D

@export var blocked : AudioStream
@export var bought : AudioStream

@export var click : AudioStream

const group_res = preload("res://UI/songs_group.tscn")

const BUY_PARTICLES = preload("res://Particles/buy_particles.tscn")

const SFX = preload("res://Scenes/SFX/break_sfx.tscn")

@onready var wtht_coins = $Lose_menu/ScrollContainer/Songs_flow/WthtCoins

#region songtemplates
@export_group("Songs")
@export var Dashcore : AudioStream
@export var Glass : AudioStream
@export var Kobra : AudioStream
@export var Lectron : AudioStream
@export var Riuka : AudioStream
@export var Shutdown : AudioStream
@export var Smartwatch : AudioStream
@export var Cthulhu : AudioStream
@export var Sunkin : AudioStream
@export var Graveyard : AudioStream
@export var Snowball : AudioStream
@export var Maladiff : AudioStream
@export_group("")
#endregion

var songs_list: Array

@export var songs_res: Array

#Songs Ordering
var songs_order: Array = [
	"Dashcore", "Glass",
	"Kobra", "Lectron",
	"Riuka", "Shutdown",
	"Smartwatch", "Cthulhu",
	"Sunkin", "Graveyard",
	"Snowball", "Maladiff"
]

var wanted_song: String

func _ready():
	if SaveShop.save_exists():
		_shop = SaveShop.load_savegame() as SaveShop
		SongsControl.songs_dic = _shop.songs_shop
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		StatsManager.coins = _save.coins_res
	
	SongsControl.conf()
	FlowControl.mode = FlowControl.modes.shop
	
	songs_list = [Dashcore, Glass, Kobra, Lectron, Riuka, Shutdown, Smartwatch, Cthulhu, Sunkin, Graveyard, Snowball, Maladiff]
	
	
	writecoins()
	spawn_songs()
	check_songs()

func actual_selected():
	%DiscAnims.play("Change")
	%Disc.material.set_shader_parameter("WhiteColor", songs_res[songs_order.find(SongsControl.new_song)].custom_color)
	%SelectBorder.reparent(%Songs_flow.get_node(SongsControl.new_song + "_group"))
	%SelectBorder.position = Vector2.ZERO

##Spawns the groups
func spawn_songs():
	for g in songs_order:
		var temp_group = group_res.instantiate()
		temp_group.song = true
		temp_group.rename_group(g)
		temp_group._set_palette(g)
		temp_group.connect("buy", _buy_song)
		%Songs_flow.add_child(temp_group)
	
	vertical_scroll()
	actual_selected()

func vertical_scroll():
	var title_count: int = 0
	for c in songs_order:
		title_count += 1
	
	var title_size: String = "a








 "
	
	for d in title_count:
		%Depth_control.text += title_size

func writecoins():
	%Coins.text = str(StatsManager.coins)

func _buy_song(nm: String):
	wanted_song = nm
	
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = click
	add_child(temp_sfx)
	
	if SongsControl.songs_dic[wanted_song][1] == true:
		SongsControl.new_song = wanted_song
		
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.saved_song = SongsControl.new_song
			
			_save.write_savegame()
			
		actual_selected()
		check_songs()
	else:
		if StatsManager.coins >= SongsControl.songs_dic[wanted_song][0]:
			%CheckShop.show_panel(songs_res[songs_order.find(nm)])
			%MusicManDialogue.buy_things()
		else:
			poor()

func really_buy_song():
	%MusicManDialogue.gain()
	
	SongsControl.buy_skin(wanted_song,StatsManager.coins)
	if SongsControl.songs_dic[wanted_song][1] == true:
		SongsControl.new_song = wanted_song
		
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.saved_song = SongsControl.new_song
			
			_save.write_savegame()
			
		actual_selected()
	check_songs()
	forget()

func forget():
	wanted_song = ""

func check_songs():
	_playsong()
	writecoins()
	
	for g in %Songs_flow.get_children():
		if g.is_in_group("groups"):
			g._set_palette(g.name.trim_suffix("_group"))

func _playsong():
	song.stream = songs_list[SongsControl.songs_textures.keys().find(SongsControl.new_song)]
	song.play()

func poor():
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = blocked
	add_child(temp_sfx)
	%Anims.play("Laugh")
	$Without_coins.play("RESET")
	$Without_coins.play("Without")
	wtht_coins.global_position = get_global_mouse_position()

func particles_spawn(nm):
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = bought
	add_child(temp_sfx)
	var temp_buy = BUY_PARTICLES.instantiate()
	temp_buy.emitting = true
	temp_buy.global_position = %Songs_flow.get_node(nm + "_group").global_position
	self.get_node("Lose_menu").add_child(temp_buy)

func _on_menu_button_down():
	$Transition.play("In")

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "In":
		get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")
