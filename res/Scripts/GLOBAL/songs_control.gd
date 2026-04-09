extends Node

var _shop : SaveShop
var _save : SaveGame

@onready var shop_node = get_tree().get_root().get_node("Songs")

@export var songs_textures: Dictionary = {
	"Dashcore":preload("res://Assets/PNG/Song_nails/Dashcore.png"),"Glass":preload("res://Assets/PNG/Song_nails/Glass.png"),
	"Kobra":preload("res://Assets/PNG/Song_nails/Kobra.png"),"Lectron":preload("res://Assets/PNG/Song_nails/Lectron.png"),
	"Riuka":preload("res://Assets/PNG/Song_nails/Riuka.png"),"Shutdown":preload("res://Assets/PNG/Song_nails/Shutdown.png"),
	"Smartwatch":preload("res://Assets/PNG/Song_nails/Smartwatch.png"),"Cthulhu":preload("res://Assets/PNG/Song_nails/Cutulu.png"),
	"Sunkin":preload("res://Assets/PNG/Song_nails/Sunkin.png"),"Graveyard":preload("res://Assets/PNG/Song_nails/GraveYard.png"),
	"Snowball":preload("res://Assets/PNG/Song_nails/SnowBall.png"), "Maladiff":preload("res://Assets/PNG/Song_nails/Maladiff.png")
}

@export var new_song : String
@export var songs_dic : Dictionary

func conf():
	shop_node = get_tree().get_root().get_node("Songs")

func cahnge_skin(nm):
	new_song = nm

func buy_skin(id : String, money : int) -> void:
	if songs_dic[id][1] == false:
		if money >= songs_dic[id][0]:
			songs_dic[id][1] = true
			if SaveShop.save_exists():
				_shop = SaveShop.load_savegame() as SaveShop
				StatsManager.coins -= songs_dic[id][0]
				_shop.songs_shop = songs_dic
				_shop.write_savegame()
			if SaveGame.save_exists():
				_save = SaveGame.load_savegame() as SaveGame
				_save.coins_res = StatsManager.coins
				_save.write_savegame()
			shop_node.particles_spawn(id)
	else:
		pass
