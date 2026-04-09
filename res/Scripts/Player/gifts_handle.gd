extends Node

var _gifts: GiftSave

var gifts_unlock: Array = [625,1250,1875,2500]

func _ready() -> void:
	check_progress()

func check_progress():
	if GiftSave.save_exists():
		_gifts = GiftSave.load_savegame() as GiftSave
		%Presents.value = _gifts.gift_progress
		%TotalPoints.text = str(_gifts.gift_progress)
		
		if _gifts.gift_progress >= gifts_unlock[0]:
			%Gift1.state = 1
		if _gifts.gift_progress >= gifts_unlock[1]:
			%Gift2.state = 1
		if _gifts.gift_progress >= gifts_unlock[2]:
			%Gift3.state = 1
		if _gifts.gift_progress >= gifts_unlock[3]:
			%Gift4.state = 1
		
		##Show Opened Gifts
		var r: int = 0
		for i in _gifts.opened:
			if i == 1 and r < 3:
				%Container.get_child(r).state = 2
			elif i == 1 and r >= 3:
				%Gift4.state = 2
			r += 1
		
