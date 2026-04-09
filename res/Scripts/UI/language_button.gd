extends Button

var language_id: int = 0
@export var total_language_count: int = 2

var _save: SaveGame

func _ready() -> void:
	text = DialogueManager.current_lenguage
	language_id = DialogueManager.lenguages.find(DialogueManager.current_lenguage)

func _change_language():
	language_id += 1
	language_id %= total_language_count
	
	DialogueManager.current_lenguage = DialogueManager.lenguages[language_id]
	
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		_save.default_language = language_id
		_save.write_savegame()
	
	text = DialogueManager.current_lenguage
	
	translate_buttons()

func translate_buttons():
	TranslationServer.set_locale(DialogueManager.current_lenguage)

func click_anim():
	var t = create_tween()
	
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT).set_parallel(false)
	t.tween_property(self, "scale", Vector2(1.2,1.2), 0.1)
	t.tween_property(self, "scale", Vector2(1,1), 0.5)
