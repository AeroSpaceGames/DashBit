extends Resource
class_name ModSave

const SAVE_GAME_PATH = "user://mods.tres"

@export var mods: Array

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
