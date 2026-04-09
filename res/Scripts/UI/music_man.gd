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

@export_category("Bullies")
@export var b_min: int
@export var b_max: int

@export_category("Secrets")
@export var s_min: int
@export var s_max: int

var prev_text: int

enum STATES {
	normal,
	angry,
	laughing,
	talking,
	shopping,
	bought
}

var current_state = STATES.normal

func _ready() -> void:
	say(randi_range(c_min, c_max), 1)

func say(id: int, new_st: int = 1):
	$RandomInteraction.start(15)
	
	#Change State
	match new_st:
		0:
			current_state = STATES.normal
		1:
			current_state = STATES.talking
		2:
			current_state = STATES.angry
		3:
			current_state = STATES.laughing
		4:
			current_state = STATES.shopping
		5:
			current_state = STATES.bought
	
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

func interact(n: int):
	match n:
		0:
			%Anims.play("Whisle")
		1:
			%Anims.play("Dozer")

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

##Check state
func _on_check_timeout() -> void:
	if current_state == STATES.normal and %MusicFace.animation != "Idle":
		%Anims.play("Idle")


func _on_random_interaction_timeout() -> void:
	var new_interaction_id: int = [0,1].pick_random()
	interact(new_interaction_id)

##DELETE AFTER RECORDING
func say_video(id: int, new_st: int = 2):
	$RandomInteraction.start(15)
	
	#Change State
	match new_st:
		0:
			current_state = STATES.normal
		1:
			current_state = STATES.talking
		2:
			current_state = STATES.angry
		3:
			current_state = STATES.laughing
		4:
			current_state = STATES.shopping
		5:
			current_state = STATES.bought
	
	if current_state != STATES.laughing:
		%Anims.play("Talk")
	%Dialog.text = "You really think you could beat me? Come here to proof it"
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
