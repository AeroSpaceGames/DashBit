extends Node

const EASY_BUTTON = preload("uid://b5ec75xkh4kgs")
const HARD_BUTTON = preload("uid://off7dq5glu4y")
const MID_BUTTON = preload("uid://cbtqaj4fra8k")
const SPOOKY_BUTTON = preload("uid://c02nj4ewrd81s")
const WINTER_BUTTON = preload("uid://ixyci6xj0gff")

##Library of directories
# load("res://Assets/PNG/UI/ModsBGs/DefaultModBG.png") -> "1"

# load("res://Assets/PNG/Backgrounds/DIFF_Background.png") -> ExtraDiffs [/, /, /, (), /, /]
# load("res://Assets/PNG/Backgrounds/DIFF_Part.png") -> ExtraDiffs [/, /, /, /, (), /]

# load("res://Assets/PNG/UI/MODNAME_Decoration.png") -> "2"
# load("res://Assets/PNG/UI/MODNAME.png") -> "3"

# load("res://Resources/MODNAMEGift.tres") -> "5" [/, /, /, /, /, (), /]
# load("res://Resources/BigMODNAMEGift.tres") -> "5" [/, /, /, /, /, /, ()]

# Begginer Color Color(0.03529412, 1, 0.6784314, 1)
# Pro Color Color(1, 1, 0.49019608, 1)
# Dashcore color Color(0.9254902, 0.3647059, 0.5921569, 1)

var active_mod: Dictionary = {
"0": "Easter",
"1": load("res://Assets/PNG/UI/ModsBGs/DefaultModBG4.png"),
"2": load("res://Assets/PNG/UI/Easter_Decoration.png"),
"3": load("res://Assets/PNG/UI/Easter_Logo.png"),
"4": true,
"5": [Color(1.0, 0.0, 0.6941, 1.0), Color(1.0, 0.0, 0.6941, 1.0), Color(0.1608, 0.1608, 0.1608, 1.0), 5, 5, load("res://Resources/EasterGift.tres"), load("res://Resources/BigEasterGift.tres"), 6050],
"ExtraDiffs": [["Begginer", EASY_BUTTON, 0, load("res://Assets/PNG/Backgrounds/Easy_Background.png"), load("res://Assets/PNG/Backgrounds/Easy_Part.png"), [0, 1], 1.0, Color(0.03529412, 1, 0.6784314, 1)], ["Pro", MID_BUTTON, 2, load("res://Assets/PNG/Backgrounds/Mid_Background.png"), load("res://Assets/PNG/Backgrounds/Mid_Part.png"), [0, 1], 2.0 , Color(1, 1, 0.49019608, 1)], ["Dashcore", HARD_BUTTON, 4, load("res://Assets/PNG/Backgrounds/Dashcore_Background.png"), load("res://Assets/PNG/Backgrounds/Dashcore_Part.png"), [0, 1], 3.3, Color(0.9254902, 0.3647059, 0.5921569, 1)]]
}


func number_of_diffs() -> int:
	var n: int = 0
	n = len(active_mod["ExtraDiffs"])
	return n
