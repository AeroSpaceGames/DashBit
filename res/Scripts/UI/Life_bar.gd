extends Control

@onready var health_bar = $Progress_bar
@onready var effect_bar = $Effect_bar
@onready var effect = $Effect

@onready var health = StatsManager.life : set = _set_health

var first_fail: bool = false

func _set_health(new_health):
	var prev_health = health
	health = min(StatsManager.max_life, new_health)
	health_bar.value = health
	
	if health < prev_health:
		if !first_fail:
			get_parent().get_parent().emit_signal("first_fail")
			first_fail = true
		effect.start(0.2)
	else:
		effect_bar.value = health

func _ready():
	match Difficulty.diff:
		0:
			StatsManager.max_life = 45
		1:
			StatsManager.max_life = 35
		2:
			StatsManager.max_life = 30
	StatsManager.life = StatsManager.max_life
	health = StatsManager.life
	init_health(health)

func init_health(_health):
	StatsManager.life = _health
	$Progress_bar.max_value = StatsManager.life
	$Progress_bar.value = StatsManager.life
	$Effect_bar.max_value = StatsManager.life
	$Effect_bar.value = StatsManager.life

func _on_effect_timeout():
	effect_bar.value = health
