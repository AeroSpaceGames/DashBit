extends Node

@export_category("Cheers")
@export var c_min: int
@export var c_max: int

@export_category("Normal Sentences")
@export var n_min: int
@export var n_max: int

@export_category("Shopping Sentences")
@export var p_min: int
@export var p_max: int

@export_category("Bought Sentences")
@export var g_min: int
@export var g_max: int

@export_category("Cryings")
@export var b_min: int
@export var b_max: int

@export_category("Secrets")
@export var s_min: int
@export var s_max: int

var prev_text: int

enum STATES {
	normal,
	angry,
	talking,
	shopping,
	bought,
	crying
}

var current_state = STATES.normal

@onready var voice = %Voice
@onready var cry_voice = %Cry

func _ready() -> void:
	say(randi_range(c_min, c_max), 1)

func say(id: int, new_st: int = 1):
	#Change State
	match new_st:
		0:
			current_state = STATES.normal
		1:
			current_state = STATES.talking
		2:
			current_state = STATES.angry
		3:
			current_state = STATES.crying
		4:
			current_state = STATES.shopping
		5:
			current_state = STATES.bought
	
	if current_state != STATES.crying and current_state != STATES.shopping:
		%Anims.play("Talk")
	elif current_state == STATES.shopping:
		%Anims.play("Sure")
	%Dialog.text = Dialogues.dialogues[id][DialogueManager.current_lenguage]
	for i in len(%Dialog.text) - 1:
		if current_state == STATES.talking or current_state == STATES.shopping:
			voice.stop()
			voice.pitch_scale = randf_range(1, 1.3)
			voice.play()
			await get_tree().create_timer(randf_range(0.05,0.1)).timeout
		elif current_state == STATES.normal:
			break
		elif current_state == STATES.angry:
			voice.stop()
			voice.pitch_scale = randf_range(0.8, 1)
			voice.play()
			await get_tree().create_timer(randf_range(0.1,0.25)).timeout
		elif current_state == STATES.crying:
			cry_voice.stop()
			cry_voice.pitch_scale = randf_range(0.8, 1)
			cry_voice.play()
			await get_tree().create_timer(randf_range(0.1,0.25)).timeout
		elif current_state == STATES.bought:
			voice.stop()
			voice.pitch_scale = randf_range(1.3, 1.5)
			voice.play()
			await get_tree().create_timer(randf_range(0.02,0.06)).timeout

func realease():
	current_state = STATES.normal
	$Check.start(0.5)

func _on_respond_pressed() -> void:
	send_message()

func send_message():
	if current_state == STATES.normal:
		var probs: Array
		probs.resize(n_max-c_max)
		probs.fill(0)
		probs.append(1)
		var secret: int = probs.pick_random()
		if secret == 0:
			var new_dialogue_id: int = randi_range(n_min, n_max)
			while new_dialogue_id == prev_text:
				new_dialogue_id = randi_range(n_min, n_max)
			say(new_dialogue_id)
			prev_text = new_dialogue_id
		elif secret == 1:
			var new_dialogue_id: int = randi_range(s_min, s_max)
			while new_dialogue_id == prev_text:
				new_dialogue_id = randi_range(s_min, s_max)
			say(new_dialogue_id, 2)
			prev_text = new_dialogue_id

func bully_player():
	var new_dialogue_id: int = randi_range(b_min, b_max)
	say(new_dialogue_id, 3)
	prev_text = new_dialogue_id

func buy_things():
	var new_dialogue_id: int = randi_range(p_min, p_max)
	say(new_dialogue_id, 4)
	prev_text = new_dialogue_id

func gain():
	var new_dialogue_id: int = randi_range(g_min, g_max)
	say(new_dialogue_id, 5)
	prev_text = new_dialogue_id


func _on_check_timeout() -> void:
	if current_state == STATES.normal and %SkinFace.animation != "Idle":
		%Anims.play("Idle")
	elif current_state == STATES.talking and %SkinFace.animation == "Talk":
		send_message()
