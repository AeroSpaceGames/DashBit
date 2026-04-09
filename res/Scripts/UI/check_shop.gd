extends Control

@onready var animations = $Anims

signal yes
signal no

func show_panel(res: playlist = null, skin_text: CompressedTexture2D = null):
	if res != null:
		%Text.show()
		%Text.texture = res.playing_nail
	elif skin_text != null:
		%Text.hide()
	animations.play("SHow")

func _on_yes_pressed() -> void:
	$Tick.play()
	emit_signal("yes")
	animations.play("Hide")

func _on_no_pressed() -> void:
	$Tick.play()
	emit_signal("no")
	animations.play("Hide")
