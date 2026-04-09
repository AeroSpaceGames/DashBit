extends Control

@onready var label = $Canvas/Ad_name

var first_inverted: bool = false

signal first_ad_inverted

signal snow_storm

func snow_trigger():
	snow_storm.emit()

func _on_test_show_ad(eff_id):
	ad(eff_id)

func ad(eff : int):
	var new_ad : String
	match eff:
		0:
			pass
			#new_ad = "Traps"
		1:
			new_ad = "Inverted"
			if !first_inverted:
				emit_signal("first_ad_inverted")
				first_inverted = true
		2:
			new_ad = "Snow Storm"
		
	label.text = new_ad
	if eff != 0 and eff != 3:
		$Animations.play(new_ad)


func _on_main_show_ad(ad_id: int) -> void:
	ad(ad_id)

func pause():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func resume():
	process_mode = Node.PROCESS_MODE_INHERIT
