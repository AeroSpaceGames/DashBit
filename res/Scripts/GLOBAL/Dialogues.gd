extends Node

var dialogues: Dictionary

func _init() -> void:
	load_dialogues()

func load_dialogues():
	var json_data = DialogueManager.load_json_data_from_path(DialogueManager.PATH_JSON_DATA)
	if json_data != null:
		for i in range(0, json_data.size()):
			parse_dialogue_from_dict(i, json_data[str(i)])

func parse_dialogue_from_dict(id: int, json_data: Dictionary):
	dialogues[id] = json_data
