extends Control

var _boxes: BoxSave
var _gift: GiftSave

@export var counts: int = 3

@export var opening_prizes: bool = false
var current_prize: int = 0
@export var prizes_count: int = 3

@export var prizes: Array = []

# Probabilities = [Coins Prob, Lower Coins Limit, Upper Coins Limit, Skin Prob, Song Prob]
var rarity_probs: Array = [0,0,0,0,0]
#0 -> Coins_limit
#3 -> Skins
#4 -> Songs
#each 0-10

var can_open: bool = false

@export var common_img: CompressedTexture2D
@export var special_img: CompressedTexture2D
@export var VIP_img: CompressedTexture2D

@onready var coins_prize = preload("res://Scenes/Boxes/coin_prize.tscn")
@onready var skin_prize = preload("res://Scenes/Boxes/skin_prize.tscn")
@onready var song_prize = preload("res://Scenes/Boxes/song_prize.tscn")

func _ready() -> void:
	if BoxesManager.opening_box <= 3:
		##Boxes
		prizes_count = 3
	else:
		##Gifts
		prizes_count = ModsManager.active_mod["5"][5].prize_count if BoxesManager.opening_box == 4 else ModsManager.active_mod["5"][6].prize_count
	
	set_skin()


func set_skin():
	
	if !BoxesManager.gift:
		prizes_count = 3
		match BoxesManager.opening_box:
			1: 
				%SpriteBox.texture = common_img
			2: 
				%SpriteBox.texture = special_img
			3: 
				%SpriteBox.texture = VIP_img
	else:
		%SpriteBox.texture = ModsManager.active_mod["5"][5].normal_texture if BoxesManager.opening_box == 4 else ModsManager.active_mod["5"][6].normal_texture
		prizes_count = ModsManager.active_mod["5"][5].prize_count if BoxesManager.opening_box == 4 else ModsManager.active_mod["5"][6].prize_count
	
	match BoxesManager.opening_box:
		1:
			##Common
			rarity_probs = [10,100,300,6,0]
			%Background.modulate = Color(0.631, 0.259, 0.0)
		2:
			##Rare
			rarity_probs = [7,500,800,8,2]
			%Background.modulate = Color(0.231, 0.605, 0.89)
		3:
			##VIP
			rarity_probs = [5,1200,2000,5,5]
			%Background.modulate = Color(0.89, 0.16, 0.659)
	
	if BoxesManager.opening_box >= 4:
		##Gift
		rarity_probs = ModsManager.active_mod["5"][5].stats if BoxesManager.opening_box == 4 else ModsManager.active_mod["5"][6].stats
		%Background.modulate = ModsManager.active_mod["5"][5].bg_color if BoxesManager.opening_box == 4 else ModsManager.active_mod["5"][6].bg_color


func _on_button_button_down() -> void:
	
	if $Animations.current_animation == "Float":
		if counts > 0:
			$Animations.play("shake")
			$NextSFX.pitch_scale += 0.05
		else:
			$Animations.play("open")
	if opening_prizes == true:
		if current_prize < prizes_count + 1:
			if can_open:
				if not $Animations.is_playing():
					$Animations.play("Flash")
					$Reveal.pitch_scale += 0.2

func set_prize():
	var prize_node = %PrizesContainer.get_node("Prize%s" % str(current_prize))
	if BoxesManager.gift:prize_node = %PrizesContainer.get_node("Prize%s" % str(current_prize))
	
	
	match prizes[current_prize - 1]:
		0:
			var temp_coins = coins_prize.instantiate()
			temp_coins.get_node("Price/Coins").text = str($PrizesManager.set_coins(rarity_probs[1],rarity_probs[2]))
			%PrizesContainer.add_child(temp_coins)
			%PrizesContainer.move_child(temp_coins, current_prize - 1) ##Sorting
		1:
			var temp_skin = skin_prize.instantiate()
			var skin_won = $PrizesManager.set_skin()
			temp_skin.get_node("Skin").play(skin_won)
			temp_skin.get_node("Skin").material.set_shader_parameter("WhiteColor", SkinControl.colors_set[skin_won])
			temp_skin.get_node("Skin").material.set_shader_parameter("BlackColor", SkinControl.colors_set[skin_won].inverted())
			%PrizesContainer.add_child(temp_skin)
			%PrizesContainer.move_child(temp_skin, current_prize - 1) ##Sorting
		2:
			var temp_song = song_prize.instantiate()
			var song_won = $PrizesManager.set_song()
			temp_song.get_node("Song").play(song_won)
			%PrizesContainer.add_child(temp_song)
			%PrizesContainer.move_child(temp_song, current_prize - 1) ##Sorting
	
	prize_node.queue_free()
	
	current_prize += 1

func can_open_now():
	can_open = true

func start_prizes():
	##Elim Boxes and Giftes
	if !BoxesManager.gift:
		if BoxSave.save_exists():
			_boxes = BoxSave.load_savegame() as BoxSave
			_boxes.boxes_list[BoxesManager.opening_slot] = [0,0,0]
			_boxes.write_savegame()
	else:
		if GiftSave.save_exists():
			_gift = GiftSave.load_savegame() as GiftSave
			_gift.opened.set(int(BoxesManager.opening_slot), 2)
			_gift.write_savegame()
	
	opening_prizes = true
	current_prize = 1
	
	#Set prizes
	for p in prizes_count:
		var coins_prob: int = randi_range(0, rarity_probs[0])
		if coins_prob >= 3: #70%
			prizes.append(0)
		else:
			var skin_prob: int = randi_range(0, rarity_probs[3])
			if skin_prob >= 5: #50%
				if $PrizesManager.is_valid_skin_or_shop(0):
					prizes.append(1)
				else:
					prizes.append(0)
			else:
				var song_prob: int = randi_range(0, rarity_probs[4])
				if song_prob > 5: #40%
					if $PrizesManager.is_valid_skin_or_shop(1):
						prizes.append(2)
					else:
						prizes.append(0)
				else:
					prizes.append(0)

func play_counts():
	if counts > 0:
		counts -= 1
	$Dots_anim.play(str(counts))

func _on_quit_button_down() -> void:
	BoxesManager.opening_slot = ""
	BoxesManager.opening_box = 0
	$Fade.play("Out")

func _on_fade_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Out":
		get_tree().change_scene_to_file("res://Scenes/Principals/Menu.tscn")

func upgrade_prob() -> bool:
	var prob: int = randi_range(0,10)
	if prob <= 8:
		return false
	else:
		return true

func upgrade_box() -> void:
	if upgrade_prob() == true:
		if !BoxesManager.gift:
			##Boxes
			if BoxesManager.opening_box <= 2:
				BoxesManager.opening_box += 1
				$Level_Up.play()
				set_skin()
		else:
			##Gifts
			if BoxesManager.opening_box <= 4:
				BoxesManager.opening_box += 1
				$Level_Up.play()
				set_skin()

func show_gifts_rewards():
	
	for i in %PrizesContainer.get_children():
		if i.get_index() < prizes_count:
			var t = create_tween()
			t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			i.show()
			t.tween_property(i, "modulate", Color(1,1,1,1), 0.1)
			await get_tree().create_timer(0.2).timeout
		else:
			i.queue_free()
	
	can_open = true

func _on_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		if !BoxesManager.gift:
			##Boxes
			$Animations.play("rewards")
		elif BoxesManager.gift:
			##Gifts
			$Animations.play("gift_rewards")
	
	if !BoxesManager.gift:
		##Boxes
		if current_prize == prizes_count:
			$Animations.animation_set_next("Flash","Quit")
	else:
		##Gifts
		if current_prize == prizes_count:
			$Animations.animation_set_next("Flash","Quit")
	
	if anim_name == "Quit":
		current_prize += 1
