extends Node

@onready var shake_flash = get_tree().get_root().get_node("Main/Screen_shake")
@onready var flash = get_tree().get_root().get_node("Main/Hurt_fx")
@onready var camera = get_tree().get_root().get_node("Main/Camera")

func conf():
	shake_flash = get_tree().get_root().get_node("Main/Screen_shake") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Screen_shake")
	flash = get_tree().get_root().get_node("Main/Hurt_fx") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Hurt_fx")
	camera = get_tree().get_root().get_node("Main/Camera") if !Difficulty.measure else get_tree().get_root().get_node("Tutorial/Camera")

func shake():
	if StatsManager.visuals:
		shake_flash.play("shake_1")
		scree_shake(12, 0.2)

func scree_shake(intensity: int, time: float):
	camera.screen_shake(intensity, time)

func hurt():
	if StatsManager.visuals:
		flash.play("Flash")
