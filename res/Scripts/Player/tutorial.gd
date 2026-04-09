extends Node2D

var _save: SaveGame

@export var easy_part: CompressedTexture2D
@export var mid_part: CompressedTexture2D
@export var dashcore_part: CompressedTexture2D

@export var song : AudioStreamPlayer

@export var Dashcore : AudioStream

@onready var inverted = $Inverted
@onready var ad = $Ad

var eff_start : int = 100
var effects = [0,1]

var new_eff : int

signal show_ad(ad_id: int)

var once_1: bool = false
var once_2: bool = false
var once_final: bool = false

var once_invert: bool = false

func _ready() -> void:
	_playsong()
	set_background(0)
	
	##Configure things
	FlowControl.mode = FlowControl.modes.starting
	CameraShake.conf()
	StatsManager.restart()
	StatsManager.conf()
	ComboManager.conf()
	ComboManager.loose()
	
	wait_for_playing()

func _process(_delta: float) -> void:
	#Background shades
	if StatsManager.points >= $LevelMeasuring.low_limit and !once_1:
		set_background(1)
		$LevelMeasuring.change_background(1)
		once_1 = true
	elif StatsManager.points >= $LevelMeasuring.mid_limit + 100 and !once_2:
		set_background(2)
		$LevelMeasuring.change_background(2)
		once_2 = true
	
	if $SFX.get_child_count() > 1:
		$SFX.get_child(1).queue_free()
	
	if Difficulty.measure:
		if StatsManager.points >= 250:
			StatsManager.life = 0
	
	if StatsManager.life < 1:
		if SaveGame.save_exists():
			_save = SaveGame.load_savegame() as SaveGame
			_save.player_level = $LevelMeasuring.measure()
			_save.new_player = false
			
			_save.write_savegame()
		
		if !once_final:
			FlowControl.mode = FlowControl.modes.paused
			%MusicManDialogue.current_guide_id = 3
			%GuideAnims.play("ShowFinalResult")
			once_final = true
	
	if StatsManager.points > eff_start:
		if ad.is_stopped():
			ad.start()
	
	if StatsManager.points >= 150 and StatsManager.points < 160 and !inverted.is_playing() and !once_invert:
		new_eff = 1
		emit_signal("show_ad",new_eff)
		$Aply.start(1)
		%Ad.start(10)
		once_invert = true

func set_background(id: int):
	##Background
	match id:
		0:
			%Ambient.texture = easy_part
		1:
			%Ambient.texture = mid_part
		2:
			%Ambient.texture = dashcore_part

func _playsong():
	song.stream = Dashcore
	song.play()
	await get_tree().create_timer(0.5).timeout
	$Playlist.playing()

func _on_ad_timeout():
	inverted.play("hide")
	if FlowControl.mode == FlowControl.modes.playing:
		new_eff = effects.pick_random()
		emit_signal("show_ad",new_eff)
	$Aply.start(1)

func _on_aply_timeout():
	match new_eff:
			0:
				pass
			1:
				if FlowControl.mode == FlowControl.modes.playing:
					inverted.play("show")

func wait_for_playing():
	while FlowControl.mode != FlowControl.modes.playing:
		await get_tree().create_timer(2).timeout
	%FirstGuide.start(15)

func first_fail():
	FlowControl.mode = FlowControl.modes.paused
	%MusicManDialogue.current_guide_id = 0
	%GuideAnims.play("Show")

func first_inverted():
	await get_tree().create_timer(2).timeout
	FlowControl.mode = FlowControl.modes.paused
	%MusicManDialogue.current_guide_id = 2
	%GuideAnims.play("Show")

func first_trap():
	await get_tree().create_timer(0.7).timeout
	FlowControl.mode = FlowControl.modes.paused
	%MusicManDialogue.current_guide_id = 1
	%GuideAnims.play("Show")

func continue_play():
	FlowControl.mode = FlowControl.modes.playing

func go_to_menu():
	get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")
	
