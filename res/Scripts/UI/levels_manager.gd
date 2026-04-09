extends Node

@export var easy_back: CompressedTexture2D
@export var mid_back: CompressedTexture2D
@export var dashcore_back: CompressedTexture2D

@export var easy_part: CompressedTexture2D
@export var mid_part: CompressedTexture2D
@export var dashcore_part: CompressedTexture2D

var easy_color: Color = Color(0.035, 1.0, 0.678)
var mid_color: Color = Color(1.0, 1.0, 0.49)
var dashcore_color: Color = Color(0.925, 0.365, 0.592)

var _save: SaveGame
var _gift: GiftSave

var needed: int = 0

func check_level():
	%UnlockedLevel.play("ChangeBack")
	
	locked()

func locked():
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		if _save.player_level < Difficulty.diff and Difficulty.diff <= 2:
			%UnlockedLevel.queue("Lock")
			
			match Difficulty.diff:
				0:
					%LockedIMG.self_modulate = easy_color
					%UnlockLevel.label_settings.font_color = easy_color
					needed = 0
				1:
					%LockedIMG.self_modulate = mid_color
					%UnlockLevel.label_settings.font_color = mid_color
					needed = 1000
				2:
					%LockedIMG.self_modulate = dashcore_color
					%UnlockLevel.label_settings.font_color = dashcore_color
					needed = 5000
			
			if !_save.levels_progress >= needed:
				%Play_button.disabled = true
				%UnlockLevel.text = str(_save.levels_progress) + "/" + str(needed)
			else:
				%UnlockLevel.text = str(_save.levels_progress) + "/" + str(needed)
				level_up()
		else:
			%Play_button.disabled = false
			%Locked.hide()
			%LockedIMG.hide()
			%UnlockLevel.hide()

func level_up():
	if SaveGame.save_exists():
		_save = SaveGame.load_savegame() as SaveGame
		_save.player_level += 1
		
		_save.write_savegame()
	
	%Play_button.disabled = false
	%UnlockedLevel.queue("Unlock")

func set_background():
	##Background
	%Background.texture = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][3]
	%Ambient.texture = ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][4]
