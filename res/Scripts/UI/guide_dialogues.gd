extends Node

@export_category("Guides")
@export var g_min: int
@export var g_max: int

@export_category("Results")
@export var r_min: int

@export_category("Farewells")
@export var f_min: int

enum STATES {
	normal,
	angry,
	laughing,
	talking,
	shopping,
	bought
}

var current_state = STATES.normal

var current_guide_id: int = 0

func show_entered():
	say(g_min + current_guide_id)
	%Visuals.play(str(current_guide_id))

func say(id: int, new_st: int = 1):
	#Change State
	match new_st:
		0:
			current_state = STATES.normal
		1:
			current_state = STATES.talking
	
	if current_state != STATES.laughing:
		%Anims.play("Talk")
	%Dialog.text = Dialogues.dialogues[id][DialogueManager.current_lenguage]
	for i in len(%Dialog.text) - 1:
		if current_state == STATES.talking or current_state == STATES.shopping:
			%Voice.stop()
			%Voice.pitch_scale = randf_range(0.7, 1)
			%Voice.play()
			await get_tree().create_timer(randf_range(0.05,0.1)).timeout
		elif current_state == STATES.normal:
			break
		elif current_state == STATES.laughing:
			%Laugh.play()
		elif current_state == STATES.angry:
			%Voice.stop()
			%Voice.pitch_scale = randf_range(0.4, 0.7)
			%Voice.play()
			await get_tree().create_timer(randf_range(0.1,0.25)).timeout
		elif current_state == STATES.bought:
			%Voice.stop()
			%Voice.pitch_scale = randf_range(0.9, 1.3)
			%Voice.play()
			await get_tree().create_timer(randf_range(0.02,0.06)).timeout

func realease():
	current_state = STATES.normal
	$Check.start(0.5)
	%ContinueButton.show()

##Check state
func _on_check_timeout() -> void:
	if current_state == STATES.normal and %MusicFace.animation != "Idle":
		%Anims.play("Idle")


func _on_continue_button_pressed() -> void:
	if current_state == STATES.normal:
		await get_tree().create_timer(0.5).timeout
		if current_guide_id == 2:
			%Ad.start(10)
		
		if current_guide_id <= 2:
			%GuideAnims.play("Hide")
		elif current_guide_id == 3:
			current_guide_id += 1
			say(f_min)
		elif current_guide_id == 4:
			if is_instance_valid(get_tree()):
				await get_tree().create_timer(2).timeout
			get_parent().get_parent().go_to_menu()

func final_result():
	if StatsManager.points <= %LevelMeasuring.low_limit:
		say(r_min)
	elif StatsManager.points > %LevelMeasuring.low_limit and StatsManager.points <= %LevelMeasuring.mid_limit:
		say(r_min + 1)
	elif StatsManager.points > %LevelMeasuring.mid_limit and StatsManager.points < %LevelMeasuring.high_limit:
		say(r_min + 2)
	elif StatsManager.points >= %LevelMeasuring.high_limit:
		say(r_min + 3)
