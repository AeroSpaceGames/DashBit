extends TextureButton

signal interact(nm: String)

var _box: BoxSave

@export var basic_text: Texture2D
@export var rare_text: Texture2D
@export var vip_text: Texture2D

func _ready() -> void:
	texture_override()

func _on_button_down() -> void:
	emit_signal("interact",str(self.name))

func texture_override():
	if BoxSave.save_exists():
		_box = BoxSave.load_savegame() as BoxSave
		match _box.boxes_list[str(self.name)][0]:
			0:
				$Sprite.texture = null
			1:
				$Sprite.texture = basic_text
			2:
				$Sprite.texture = rare_text
			3:
				$Sprite.texture = vip_text
