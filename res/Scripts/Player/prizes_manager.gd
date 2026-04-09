extends Node

var _shop: SaveShop
var _save: SaveGame

@onready var coin_ins
@onready var skin_ins
@onready var song_ins

var posible_skins: Array = [
	"BW","BO",
	"CR","LG",
	"YB","MA",
	"ST","PC",
	"PG_H","BB_8",
	"YingYang","Magnet",
	"Kanji","OB_H",
	"LG_R","Alien",
	"Jack","Creeper",
	"X_YP","X_GB",
	"X_RB","X_M",
	"X_RY","X_O",
	]

var season_skins: Array = [
	"Ghost","Eye",
	"Skull","Bat",
	"Web","Pumpkin",
	"Gift","SMan",
	"Hat","Snow",
	"P1","P2"
	]

var gift_skins: Array = [
	"Gift","SMan",
	"Hat","Snow",
	"P1","P2"
]

var posible_songs: Array = [
	"Dashcore","Glass",
	"Kobra","Lectron",
	"Riuka","Shutdown",
	"Smartwatch","Cthulhu"
]

func set_coins(low_limit: int, up_limit: int):
	var value: int = randi_range(low_limit, up_limit)
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		_save.coins_res += value
		_save.write_savegame()
	return value

func set_skin():
	if BoxesManager.opening_box >= 4:
		posible_skins.append_array(gift_skins)
	if BoxesManager.opening_box >= 2:
		posible_skins.append_array(season_skins)
	var prize_skin: String = ""
	if SaveShop.save_exists():
		_shop = SaveShop.load_savegame() as SaveShop
		var k: String = posible_skins.pick_random()
		while _shop.skins_shop[k][1] != false:
			posible_skins.erase(k)
			k = posible_skins.pick_random()
		
		prize_skin = k
		_shop.skins_shop[prize_skin][1] = true
		_shop.write_savegame()
	return prize_skin
	

func set_song():
	var prize_song: String = ""
	if SaveShop.save_exists():
		_shop = SaveShop.load_savegame() as SaveShop
		var k: String = posible_songs.pick_random()
		while _shop.songs_shop[k][1] != false:
			posible_songs.erase(k)
			k = posible_songs.pick_random()
		
		prize_song = k
		_shop.songs_shop[prize_song][1] = true
		_shop.write_savegame()
	return prize_song

func is_valid_skin_or_shop(mode: int = 0):
	if BoxesManager.opening_box >= 4:
		posible_skins.append_array(gift_skins)
	elif BoxesManager.opening_box >= 2:
		posible_skins.append_array(season_skins)
	
	match mode:
		0:
			##Skins
			if SaveShop.save_exists():
				_shop = SaveShop.load_savegame() as SaveShop
				for k in _shop.skins_shop.keys():
					if _shop.skins_shop[k][1] == false and k in posible_skins:
						return true
			
			return false
		1:
			##Songs
			if SaveShop.save_exists():
				_shop = SaveShop.load_savegame() as SaveShop
				for k in _shop.songs_shop.keys():
					if _shop.songs_shop[k][1] == false and k in posible_songs:
						return true
			
			return false
