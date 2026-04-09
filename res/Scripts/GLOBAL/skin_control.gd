extends Node

var _shop : SaveShop
var _save : SaveGame

@onready var shop_node = get_tree().get_root().get_node("Shop")

@export var new_skin : String
@export var skins_dic : Dictionary

@export var textures_set: Array = [
	##Normals
	preload("res://Assets/PNG/Palettes/Black_White.png"), #0
	preload("res://Assets/PNG/Palettes/Black_White.png"), #1
	preload("res://Assets/PNG/Palettes/Black_White.png"), #2
	preload("res://Assets/PNG/Palettes/Black_White.png"), #3
	preload("res://Assets/PNG/Palettes/Black_White.png"), #4
	preload("res://Assets/PNG/Palettes/Black_White.png"), #5
	preload("res://Assets/PNG/Palettes/Black_White.png"), #6
	preload("res://Assets/PNG/Palettes/Black_White.png"), #7
	
	##Printed
	preload("res://Assets/PNG/Palettes/YingYang_palette.png"), #8
	preload("res://Assets/PNG/Palettes/Alien.png"), #9
	preload("res://Assets/PNG/Palettes/BB-8.png"), #10
	preload("res://Assets/PNG/Palettes/Kanyi.png"), #11
	preload("res://Assets/PNG/Palettes/LG_R.png"), #12
	preload("res://Assets/PNG/Palettes/Magnet_palette.png"), #13
	preload("res://Assets/PNG/Palettes/OB_heart.png"), #14
	preload("res://Assets/PNG/Palettes/PG-Happy.png"), #15
	preload("res://Assets/PNG/Palettes/Jack.png"), #16
	preload("res://Assets/PNG/Palettes/creeper.png"), #17
	
	##Cross
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #18
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #19
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #20
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #21
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #22
	preload("res://Assets/PNG/Palettes/BW_cross.png"), #23
	
	##Scary
	preload("res://Assets/PNG/Palettes/Eye.png"), #24
	preload("res://Assets/PNG/Palettes/Ghost.png"), #25
	preload("res://Assets/PNG/Palettes/Bat.png"), #26
	preload("res://Assets/PNG/Palettes/Skull.png"), #27
	preload("res://Assets/PNG/Palettes/Pumpkin.png"), #28
	preload("res://Assets/PNG/Palettes/Web.png"), #29
	
	#Winter
	preload("res://Assets/PNG/Palettes/Gift.png"), #30
	preload("res://Assets/PNG/Palettes/SMan.png"), #31
	preload("res://Assets/PNG/Palettes/Snow.png"), #32
	preload("res://Assets/PNG/Palettes/Hat.png"), #33
	preload("res://Assets/PNG/Palettes/Pattern1.png"), #34
	preload("res://Assets/PNG/Palettes/Pattern2.png") #35
]

@export var colors_set: Dictionary = {
	"BW" : Color(0.847,0.847,0.847), #0
	"BO" : Color(0.965, 0.675, 0.337), #1
	"CR" : Color(0.0, 0.875, 0.788), #2
	"LG" : Color(0.463, 0.702, 0.259), #3
	"YB" : Color(0.835, 0.922, 0.224), #4
	"MA" : Color(0.722, 0.541, 0.4), #5
	"ST" : Color(1.0, 0.42, 0.333), #6
	"PC" : Color(0.0, 0.867, 0.576), #7
	
	"YingYang" : Color(0.847,0.847,0.847), #8
	"Alien" : Color(0.498, 1.0, 0.0), #9
	"BB_8" : Color(0.475, 0.706, 0.937), #10
	"Kanji" : Color(0.263, 0.408, 0.741), #11
	"LG_R" : Color(0.776, 0.251, 1.0), #12
	"Magnet" : Color(0.0, 0.875, 0.788), #13
	"OB_H" : Color(0.016, 0.871, 0.969), #14
	"PG_H" : Color(0.627, 1.0, 0.608), #15
	"Jack" : Color(1.0, 0.951, 0.745), #16
	"Creeper" : Color(0.584, 1.0, 0.078), #17
	
	"X_YP" : Color(1.0, 0.98, 0.529), #18
	"X_GB" : Color(0.0, 0.827, 0.278), #19
	"X_RB" : Color(1.0, 0.427, 0.443), #20
	"X_M" : Color(0.875, 0.733, 0.0), #21
	"X_RY" : Color(0.1, 1.0, 0.8), #22
	"X_O" : Color(0.0, 0.471, 1.0), #23
	
	"Eye" : Color(0.961, 0.31, 0.651), #24
	"Ghost" : Color(0.812, 0.459, 0.0), # 25
	"Bat" : Color(0.376, 0.839, 0.0), #26
	"Skull" : Color(1.0, 1.0, 0.71), #27
	"Pumpkin" : Color(1.0, 0.5, 0.0), #28
	"Web" : Color(0.0, 0.525, 0.475), #29
	
	"Gift" : Color(0.0, 1.0, 1.0), #30
	"SMan" : Color(0.812, 1.0, 0.995), #31
	"Snow" : Color(0.847, 0.307, 0.847, 1.0), #32
	"Hat" : Color(0.533, 0.863, 0.2), #33
	"P1" : Color(0.955, 0.863, 0.2, 1.0), #34
	"P2" : Color(0.208, 1.0, 0.693, 1.0) #35
}

#Color(0.792, 0.0, 0.307, 1.0) #35
#Color(0.91, 0.451, 0.588)
#Color(0.584, 0.256, 0.256)

func conf():
	shop_node = get_tree().get_root().get_node("Shop")

func cahnge_skin(nm):
	new_skin = nm

func buy_skin(id : String, money : int):
	if skins_dic[id][1] == false:
		if money >= skins_dic[id][0]:
			skins_dic[id][1] = true
			if SaveShop.save_exists():
				_shop = SaveShop.load_savegame() as SaveShop
				StatsManager.coins -= skins_dic[id][0]
				_shop.skins_shop = skins_dic
				_shop.write_savegame()
			if SaveGame.save_exists():
				_save = SaveGame.load_savegame() as SaveGame
				_save.coins_res = StatsManager.coins
				_save.write_savegame()
			shop_node.particles_spawn(id)
	else:
		pass
