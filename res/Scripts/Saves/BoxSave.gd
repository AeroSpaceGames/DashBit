extends Resource
class_name BoxSave

const SAVE_GAME_PATH = "user://boxes.tres"

@export var wait: int#Removed
@export var boxes_list: Dictionary

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
