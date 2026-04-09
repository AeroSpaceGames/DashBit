extends Control

var valid_update: bool = true

@export var loaded : int = 9
@export var loading : int = 0

var security_shop = {
	"BW":[0,true],"BO":[50,false],
	"CR":[100,false],"LG":[150,false],
	"YB":[200,false],"MA":[250,false],
	"ST":[350,false],"PC":[500,false],
	"PG_H":[400,false],"BB_8":[400,false],
	"YingYang":[400,false],"Magnet":[400,false],
	"Kanji":[650,false],"OB_H":[800,false],
	"LG_R":[500,false],"Alien":[800,false],
	"Jack":[1000,false],"Creeper":[1000,false],
	"X_YP":[1000,false],"X_GB":[1000,false],
	"X_RB":[1000,false],"X_M":[1000,false],
	"X_RY":[2500,false],"X_O":[5000,false],
	"Ghost":[250,false],"Eye":[500,false],
	"Skull":[1000,false],"Bat":[2500,false],
	"Web":[5000,false],"Pumpkin":[5000,false],
	"Gift":[500,false],"SMan":[500,false],
	"Hat":[1000,false],"Snow":[1000,false],
	"P1":[1500,false],"P2":[1500,false]
	}
var security_songs = {
	"Dashcore":[0,true],"Glass":[250,false],
	"Kobra":[500,false],"Lectron":[500,false],
	"Riuka":[500,false],"Shutdown":[500,false],
	"Smartwatch":[1000,false],"Cthulhu":[1500,false],
	"Sunkin":[2000,false],"Graveyard":[2000,false],
	"Snowball":[3000,false],"Maladiff":[5000,false]
	}

var _save:SaveGame
var _shop:SaveShop
var _boxes:BoxSave
var _gifts:GiftSave

var security_reset: bool = false

func _ready():
	_create_or_load_save()

func _on_timer_timeout():
	loading += 1
	if loading == loaded:
		if valid_update:
			if SaveGame.save_exists():
				_save = SaveGame.load_savegame() as SaveGame
				
				if !_save.new_player:
					get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")
				else:
					Difficulty.measure = true
					get_tree().change_scene_to_file("res://Scenes/Principals/tutorial.tscn")

func _create_or_load_save():
	#Shop things load
	if SaveShop.save_exists():
		_shop = SaveShop.load_savegame() as SaveShop
		
		#Skins security
		for i in security_shop.keys():
			if _shop.skins_shop.has(i):
				if _shop.skins_shop[i][0] == security_shop[i][0]:
					pass
				else:
					_shop.skins_shop[i][1] = security_shop[i][1]
			else:
				_shop.skins_shop[i] = [security_shop[i][0],security_shop[i][1]]
		
		#Songs security
		for i in security_songs.keys():
			if _shop.songs_shop.has(i):
				if _shop.songs_shop[i][0] == security_songs[i][0]:
					pass
				else:
					_shop.songs_shop[i][1] = security_songs[i][1]
			else:
				_shop.songs_shop[i] = [security_songs[i][0],security_songs[i][1]]
		
		## NEW Anti Old Version System
		"""
		if _shop.skins_shop["BO"][0] != security_shop["BO"][0] or _shop.songs_shop["Glass"][0] != security_songs["Glass"][0]:
			security_reset = true
			if BoxSave.save_exists():
				_boxes = BoxSave.new()
				_boxes.wait = -1
				_boxes.boxes_list = {
					"Slot1":[0,0,0],
					"Slot2":[0,0,0],
					"Slot3":[0,0,0]
				}
				_boxes.write_savegame()
			_shop = SaveShop.new()
			_shop.skins_shop = security_shop
			_shop.songs_shop = security_songs
		"""
		
		SkinControl.skins_dic = _shop.skins_shop
		SongsControl.songs_dic = _shop.songs_shop
		
		_shop.write_savegame()
	else:
		
		_shop = SaveShop.new()
		
		_shop.skins_shop = security_shop
		_shop.songs_shop = security_songs
		
		_shop.write_savegame()
	
	#Saved things load
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		if security_reset:
			_save = SaveGame.new()
			
			_save.coins_res = 0
			_save.begginer_best = 0
			_save.pro_best = 0
			_save.dashcore_best = 0
			
			_save.first_time = true
			_save.new_diff = false
			
			_save.saved_skin = "BW"
			_save.saved_song = "Dashcore"
			
			_save.player_level = 0
		
		if !_save.has_method("Halloween"):
			_save.new_diff = false
		
		if _save.n != 1:
			_save.n = 1
			_save.new_player = true
			
			_save.saved_skin = "BW"
			_save.saved_song = "Dashcore"
			
			_save.player_level = 0
		
		if _save.default_language == null:
			_save.default_language = DialogueManager.lenguages.find(OS.get_locale().split("_")[0].to_upper())
		
		SkinControl.new_skin = _save.saved_skin
		SongsControl.new_song = _save.saved_song
		DialogueManager.current_lenguage = DialogueManager.lenguages[_save.default_language]
		TranslationServer.set_locale(DialogueManager.current_lenguage)
		
		StatsManager.visuals = _save.vfx_activated
		StatsManager.coins = _save.coins_res
		
		##Best Scores Load
		var bests_saved : Array = [_save.begginer_best, _save.pro_best, _save.dashcore_best]
		for i in 3:
			StatsManager.bests[i] = bests_saved[i]
		
		_save.write_savegame()
	else:
		_save = SaveGame.new()
		
		_save.coins_res = 0
		_save.begginer_best = 0
		_save.pro_best = 0
		_save.dashcore_best = 0
		
		_save.saved_skin = "BW"
		_save.saved_song = "Dashcore"
		
		_save.player_level = 0
		
		_save.first_time = true
		_save.new_diff = false
		
		_save.n = 1
		_save.new_player = true
		
		_save.vfx_activated = true
		
		_save.default_language = DialogueManager.lenguages.find(OS.get_locale().split("_")[0].to_upper())
		
		SkinControl.new_skin = _save.saved_skin
		SongsControl.new_song = _save.saved_song
		DialogueManager.current_lenguage = DialogueManager.lenguages[_save.default_language]
		TranslationServer.set_locale(DialogueManager.current_lenguage)
		StatsManager.visuals = _save.vfx_activated
		
		_save.write_savegame()
	
	#Boxes load
	if BoxSave.save_exists():
		_boxes = BoxSave.load_savegame() as BoxSave
		if _boxes.wait != -1:
			_boxes = BoxSave.new()
			_boxes.wait = -1
			_boxes.boxes_list = {
				"Slot1":[0,0,0],
				"Slot2":[0,0,0],
				"Slot3":[0,0,0]
			}
		_boxes.write_savegame()
	else:
		_boxes = BoxSave.new()
		_boxes.wait = -1
		_boxes.boxes_list = {
			"Slot1":[0,0,0],
			"Slot2":[0,0,0],
			"Slot3":[0,0,0]
		}
		
		_boxes.write_savegame()
	
	#Gifts Load
	if GiftSave.save_exists():
		_gifts = GiftSave.load_savegame() as GiftSave
		##Reset old version
		if _gifts.ver != 0:
			_gifts.ver = 0
			_gifts.gift_progress = 0
			_gifts.reset = false
		
		if ModsManager.active_mod["4"] and !_gifts.reset:
			_gifts.opened = []
			_gifts.opened.resize(ModsManager.active_mod["5"][3])
			_gifts.opened.fill(0)
			_gifts.reset = true
		
		if !_gifts.move_points:
			if SaveGame.save_exists():
				_save = SaveGame.load_savegame() as SaveGame
				_save.levels_progress = _gifts.gift_progress
				_save.write_savegame()
				_gifts.gift_progress = 0
			_gifts.move_points = true
		
		_gifts.write_savegame()
	else:
		_gifts = GiftSave.new()
		_gifts.ver = 0
		_gifts.move_points = true
		_gifts.gift_progress = 0
		_gifts.opened = []
		_gifts.write_savegame()
