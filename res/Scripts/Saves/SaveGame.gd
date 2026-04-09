extends Resource
class_name SaveGame

const SAVE_GAME_PATH = "user://save.tres"
 
@export var coins_res : int

@export var begginer_best : int
@export var pro_best : int
@export var dashcore_best : int

@export var saved_skin: String
@export var saved_song: String

@export var first_time : bool
@export var new_diff: bool

@export var n: int
@export var new_player: bool
@export var player_level: int

@export var default_language: int

@export var levels_progress: int
@export var vfx_activated: bool

func write_savegame() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)

static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)

static func load_savegame():
	return ResourceLoader.load(SAVE_GAME_PATH, "", 1)
