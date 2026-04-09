extends Node

@export var res: Mod

func change_value(stat_id: int, new_val: Variant):
	match stat_id:
		##Change Name
		0:
			if typeof(new_val) == TYPE_STRING:
				res.Name = new_val
		
		##Change BG Panel
		1:
			if typeof(new_val) == TYPE_OBJECT:
				res.BG_panel = new_val
		
		##Change Decorations
		2:
			if typeof(new_val) == TYPE_OBJECT:
				res.decoration = new_val
		
		##Change Title
		3:
			if typeof(new_val) == TYPE_OBJECT:
				res.title = new_val
		
		##Change Has Gamepass
		4:
			if typeof(new_val) == TYPE_BOOL:
				res.has_gamepass = new_val
		
		##Change Gamepass/Main Color
		5:
			if typeof(new_val) == TYPE_COLOR:
				res.gamepass[0] = new_val
		
		##Change Gamepass/Upper Color
		6:
			if typeof(new_val) == TYPE_COLOR:
				res.gamepass[1] = new_val
		
		##Change Gamepass/Bottom Color
		7:
			if typeof(new_val) == TYPE_COLOR:
				res.gamepass[2] = new_val
		
		##Change Gamepass/Number of Steps
		8:
			if typeof(new_val) == TYPE_INT:
				res.gamepass[3] = new_val
		
		##Change Gamepass/Maximum value
		9:
			if typeof(new_val) == TYPE_INT:
				res.gamepass[4] = new_val
		
		##Change Gamepass/Gift resource
		10:
			if typeof(new_val) == TYPE_OBJECT:
				res.gamepass[5] = new_val
		
		##Change Gamepass/Big Gift resource
		11:
			if typeof(new_val) == TYPE_OBJECT:
				res.gamepass[6] = new_val
		
		##Change Gamepass/Max Points Progress
		12:
			if typeof(new_val) == TYPE_INT:
				res.gamepass[7] = new_val


func get_value(stat_id: int):
	match stat_id:
		0:
			return res.Name
		1:
			return res.BG_panel
		2:
			return res.decoration
		3:
			return res.title
		4:
			return res.has_gamepass
		5:
			return res.gamepass
