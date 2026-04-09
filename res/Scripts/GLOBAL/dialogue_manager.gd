extends Node

@export var PATH_JSON_DATA: String = "res://Assets/Dialogues/Dialogues.json"

@export var lenguages: Array = ["EN", "ES"]
@export var current_lenguage: String = "ES"

func load_json_data_from_path(path: String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	if file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("loading json data failed getting file as string for path: ", path)
	
	if json_data == null:
		push_warning("failed to parse file data to JSON for ", path)
	
	return json_data
