extends TextureButton

@export var great: bool = false
@export var state: int = 0

@export var img: CompressedTexture2D

func _ready() -> void:
	_search_state()
	draw_textures()

func draw_textures():
	texture_normal = img
	texture_pressed = img
	texture_hover = img
	texture_focused = img

func _search_state():
	match state:
		0:
			self.disabled = true
			self.modulate = Color.DIM_GRAY
		1:
			self.disabled = false
			self.modulate = Color.WHITE
			$Anim.play("Shaking")
		2:
			self.disabled = true
			self.modulate = Color.WHITE
			$Opened.show()

func open():
	if great:
		BoxesManager.opening_box = 5
	else:
		BoxesManager.opening_box = 4
	BoxesManager.gift = true
	BoxesManager.opening_slot = str(self.get_index())
	get_tree().change_scene_to_file("res://UI/unboxing.tscn")
