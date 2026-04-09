extends Node

@onready var block = get_tree().get_root().get_node("Main/PlayableZone/Blocks")

enum modes {
	menu,
	playing,
	loose,
	shop,
	paused,
	starting
}

@export var mode := modes.menu : set = check_mode

func conf():
	mode = modes.starting

func check_mode(new_val: modes):
	mode = new_val
	if new_val == modes.playing:
		get_tree().call_group("PlayableObject", "resume")
	elif new_val == modes.paused:
		get_tree().call_group("PlayableObject", "pause")
