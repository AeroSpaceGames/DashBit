extends Node2D

@export var song : AudioStreamPlayer

@export_group("Songs")
@export var Dashcore : AudioStream
@export var Glass : AudioStream
@export var Kobra : AudioStream
@export var Lectron : AudioStream
@export var Riuka : AudioStream
@export var Shutdown : AudioStream
@export var Smartwatch : AudioStream
@export var Cthulhu : AudioStream
@export var Sunkin : AudioStream
@export var Graveyard : AudioStream
@export var Snowball : AudioStream
@export var Maladiff : AudioStream
@export_group("")

var songs_list: Array

@onready var inverted = $Inverted

var eff_start : int = 60

var effects = [0,1]
# 0 nothing
# 1 inverted
# 2 SnowStorm
# 3 Thunders
# 4 Laces

var new_eff : int

signal show_ad(ad_id: int)

func _ready():
	#$Thunders.config_colors()
	set_background()
	
	songs_list = [Dashcore, Glass, Kobra, Lectron, Riuka, Shutdown, Smartwatch, Cthulhu, Sunkin, Graveyard, Snowball, Maladiff]
	
	_playsong()
	%Thunders.config_colors()
	
	##Configure things
	FlowControl.conf()
	CameraShake.conf()
	StatsManager.restart()
	StatsManager.conf()
	ComboManager.conf()
	ComboManager.loose()
	
	if Difficulty.diff == 15:
		##Easter Egg
		eff_start = 0
		$Rect.global_position = Vector2i(0,0)
		$Rect.size = Vector2i(720,1600)
	else:
		eff_start = (-10 * ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][2]) + 50
		$Rect.global_position = Vector2i(0,900)
		$Rect.size = Vector2i(720,700)
		effects = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][5] ## Mechanics

func _playsong():
	song.stream = songs_list[SongsControl.songs_textures.keys().find(SongsControl.new_song)]
	song.play()
	await get_tree().create_timer(0.5).timeout
	$Playlist.playing()

func _process(_delta):
	if $SFX.get_child_count() > 1:
		$SFX.get_child(1).queue_free()
	
	if Difficulty.measure:
		if StatsManager.points >= 250:
			StatsManager.life = 0
	
	if StatsManager.life < 1:
		if FlowControl.mode != FlowControl.modes.loose:
			$PlayableZone/Ambient.process_mode = Node.PROCESS_MODE_DISABLED
			FlowControl.mode = FlowControl.modes.loose
			$Rect.visible = false
			$Transition.play("In")

		
	if StatsManager.points > eff_start:
		if $Ad.is_stopped():
			$Ad.start()
	
	#Begginer balance
	if Difficulty.diff == 0:
		if !Difficulty.begginer_balance:
			balance_diff()
	
	##THUNDERS
	"""
	if Difficulty.diff == 3:
		if StatsManager.points > 100:
			if $Thunders/Timer.is_stopped():
				$Thunders/Timer.start(3)
	"""

func balance_diff():
	if StatsManager.points >= 200:
		Difficulty.begginer_balance = true

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "In":
		get_tree().change_scene_to_file("res://UI/loose.tscn")

func _on_aply_timeout():
	match new_eff:
			0:
				pass
			1:
				if FlowControl.mode == FlowControl.modes.playing:
					inverted.play("show")
			3:
				if FlowControl.mode == FlowControl.modes.playing:
					$%Thunders._on_timer_timeout()

func show_snow_storm():
	%SnowStorm.init()


func _on_ad_timeout():
	inverted.play("hide")
	if FlowControl.mode == FlowControl.modes.playing:
		new_eff = effects.pick_random()
		emit_signal("show_ad",new_eff)
	$Aply.start(1)

func set_background():
	##Background
	if Difficulty.diff != 15: #Troll
		%Background.texture = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][3]
		%Ambient.texture = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][4]
