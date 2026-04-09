extends Control

@export var in_col = Color(0, 0.851, 0.694)
@export var max_col = Color(0, 0.851, 1)

var prev_combo: int = 1

func _ready():
	if Difficulty.measure:
		%Quit.hide()
		%Quit_text.hide()
	
	#print(%Points.theme.normal_font_size, " ", typeof(%Points.theme.normal_font_size))
	%Points.add_theme_font_size_override("normal_font_size", 250)
	%Points.self_modulate = in_col
	animation()

func _process(_delta):
	
	if ComboManager.multiplier <= 1:
		$Combos.stop()
		%Combo.visible = false
		%Fire.hide()
	
	%Combo.text = "x" + str(ComboManager.multiplier)
	%Points.text = "[wave]" + str(StatsManager.points)
	
	if len(%Points.text.trim_prefix("[wave]")) >= 1 and len(%Points.text.trim_prefix("[wave]")) < 2:
		%Combo.global_position = Vector2($comb_1.global_position.x - 50, 120)
	elif len(%Points.text.trim_prefix("[wave]")) >= 2 and len(%Points.text.trim_prefix("[wave]")) < 3:
		%Combo.global_position = Vector2($comb_2.global_position.x - 50, 120)
	elif len(%Points.text.trim_prefix("[wave]")) >= 3 and len(%Points.text.trim_prefix("[wave]")) < 4:
		%Combo.global_position = Vector2($comb_3.global_position.x - 50, 120)
	elif len(%Points.text.trim_prefix("[wave]")) >= 4 and len(%Points.text.trim_prefix("[wave]")) < 5:
		%Points.add_theme_font_size_override("normal_font_size", 200)
		%Combo.global_position = Vector2($comb_4.global_position.x - 50, 120)
	%Fire.position.x = %Combo.position.x + 140
	%WhiteCircle.position.x = %Fire.position.x
	
	if ComboManager.multiplier != prev_combo and ComboManager.multiplier != 1:
		$UPG.play("UPG")
		prev_combo = ComboManager.multiplier
	elif ComboManager.multiplier == 1:
		prev_combo = 1

func color_change():
	if %Points.self_modulate != max_col:
		%Points.self_modulate.b += 0.02

func color_reset():
	%Points.self_modulate = in_col

func animation():
	var rot: Array = [-6,6]
	if StatsManager.points % 100 <= 1:
		rot = [-15,15]
	if StatsManager.points % 1000 <= 1:
		rot = [-30,30]
	%Points.rotation_degrees = rot.pick_random()
	$Animations.play("Change")

func show_combo():
	if $Combos.is_playing() == false:
		$Combos.play("Combo_show")

func _on_timer_timeout():
	color_change()

func _on_quit_button_down():
	StatsManager.life = 0
