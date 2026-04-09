extends Resource
class_name SaveShop

const SAVE_GAME_PATH = "user://shop.tres"
 
@export var skins_shop : Dictionary
@export var songs_shop : Dictionary

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
