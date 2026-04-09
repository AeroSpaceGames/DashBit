extends Resource
class_name GiftSave

const SAVE_GAME_PATH = "user://gifts.tres"

@export var ver: int
@export var gift_progress: int
@export var opened: Array

@export var move_points: bool
@export var reset: int 

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
