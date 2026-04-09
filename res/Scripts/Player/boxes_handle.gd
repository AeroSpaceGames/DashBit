extends Node

var _boxes: BoxSave

const SFX = preload("res://Scenes/SFX/break_sfx.tscn")
@export var click : AudioStream

@export var basic_text: Texture2D
@export var rare_text: Texture2D
@export var vip_text: Texture2D

var basic_timer: int = 3600
var rare_timer: int = 7200
var vip_timer: int = 18000

#1h - 3600
#2h - 7200
#5h - 18000

var actual_time: float

var selected_slot: String

func _ready() -> void:
	actual_time = Time.get_unix_time_from_system()
	check_boxes_state()

func check_boxes_state():
	var necesary_time: int
	if BoxSave.save_exists():
		_boxes = BoxSave.load_savegame() as BoxSave
		for i in _boxes.boxes_list.keys():
			match _boxes.boxes_list[i][0]:
				1:
					necesary_time = basic_timer
				2:
					necesary_time = rare_timer
				3:
					necesary_time = vip_timer
			if _boxes.boxes_list[i][1] != 0:
				if abs(actual_time - _boxes.boxes_list[i][1]) >= necesary_time:
					_boxes.boxes_list[i][2] = 2
					_boxes.write_savegame()
			match _boxes.boxes_list[i][2]:
				0:
					%Slots_container.get_node(i).get_node("Secs").visible = false
				1:
					%Slots_container.get_node(i).self_modulate = Color.GREEN
					
					if int(necesary_time - (actual_time - _boxes.boxes_list[i][1])) < 60:
						%Slots_container.get_node(i).get_node("Secs").text = str(int(necesary_time - (actual_time - _boxes.boxes_list[i][1]))) + "s"
					elif int(necesary_time - (actual_time - _boxes.boxes_list[i][1])) >= 60 and int(necesary_time - (actual_time - _boxes.boxes_list[i][1])) < 3600: 
						%Slots_container.get_node(i).get_node("Secs").text = str((int(necesary_time - (actual_time - _boxes.boxes_list[i][1])))/60) + "m"
					elif int(necesary_time - (actual_time - _boxes.boxes_list[i][1])) >= 3600: 
						%Slots_container.get_node(i).get_node("Secs").text = str((int(necesary_time - (actual_time - _boxes.boxes_list[i][1])))/3600) + "h"
					%Slots_container.get_node(i).get_node("Secs").visible = true
				2:
					%Slots_container.get_node(i).self_modulate = Color.DEEP_SKY_BLUE
					%Slots_container.get_node(i).get_node("Secs").visible = false
	

func _on_timer_timeout() -> void:
	actual_time = Time.get_unix_time_from_system()
	check_boxes_state()

#Slots logic
func _on_slot_temp_interact(nm: String) -> void:
	var temp_sfx = SFX.instantiate()
	temp_sfx.get_node("Break").stream = click
	add_child(temp_sfx)
	selected_slot = nm
	var necesary_time: int
	var alt_1: String = "Slot"
	var alt_2: String = "Slot"
	for i in range(1,4):
		if str(i) != nm.trim_prefix("Slot"):
			if alt_1 == "Slot":
				alt_1 += str(i)
			else:
				alt_2 += str(i)
	if BoxSave.save_exists():
		_boxes = BoxSave.load_savegame() as BoxSave
		match _boxes.boxes_list[nm][0]:
			1:
				necesary_time = basic_timer
			2:
				necesary_time = rare_timer
			3:
				necesary_time = vip_timer
		if _boxes.boxes_list[nm][0] != 0:
			if _boxes.boxes_list[alt_1][2] != 1 and _boxes.boxes_list[alt_2][2] != 1:
				if _boxes.boxes_list[nm][1] == 0:
					match _boxes.boxes_list[nm][0]:
						1:
							%BoxName.text = "Basic Box"
							%SpriteBox.texture = basic_text
						2:
							%BoxName.text = "Special Box"
							%SpriteBox.texture = rare_text
						3:
							%BoxName.text = "VIP Box"
							%SpriteBox.texture = vip_text
					%Open.text = "Unlock"
					$Boxes_anim.play("Show")
			else:
				advertice(_boxes.boxes_list[nm][2])
			if _boxes.boxes_list[nm][1] != 0:
				if abs(actual_time - _boxes.boxes_list[nm][1]) >= necesary_time:
					match _boxes.boxes_list[nm][0]:
						1:
							%BoxName.text = "Basic Box"
							%SpriteBox.texture = basic_text
						2:
							%BoxName.text = "Special Box"
							%SpriteBox.texture = rare_text
						3:
							%BoxName.text = "VIP Box"
							%SpriteBox.texture = vip_text
					%Open.text = "Open"
					$Boxes_anim.play("Show")
					_boxes.boxes_list[nm][2] = 2
					_boxes.write_savegame()

func _on_quit_button_down() -> void:
	$Boxes_anim.play("Close")

func _on_open_button_down() -> void:
	if %Open.text == "Unlock":
		if BoxSave.save_exists():
			_boxes = BoxSave.load_savegame() as BoxSave
			_boxes.boxes_list[selected_slot][1] = int(Time.get_unix_time_from_system())
			_boxes.boxes_list[selected_slot][2] = 1
			_boxes.write_savegame()
			$Boxes_anim.play("Close")
	elif %Open.text == "Open":
		if BoxSave.save_exists():
			_boxes = BoxSave.load_savegame() as BoxSave
			BoxesManager.opening_box = _boxes.boxes_list[selected_slot][0]
			BoxesManager.opening_slot = selected_slot
			BoxesManager.gift = false
			get_tree().change_scene_to_file("res://UI/unboxing.tscn")
	check_boxes_state()


func advertice(state: int):
	if state != 2:
		var tween = get_tree().create_tween()
		tween.tween_property(%Adverticement,"modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
		tween.tween_property(%Adverticement,"modulate", Color(1.0, 1.0, 1.0, 0.0), 2)
