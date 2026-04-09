extends Node2D

const block = preload("res://Scenes/Obstacles/Obstacle.tscn")

const STREAK_SFX = preload("res://Scenes/SFX/combo_sfx.tscn")

var combo_rate : float = 0.04
var combo_acum : float = 1.0
var combo_max : float = 1.68

var rng = RandomNumberGenerator.new()

var skn : int = 0

var mode : int 

var delay = 0.8
var maximum = 0.5

var max_speed = 1700

var traps_lvl : int = 50

var passive : bool = false

@export var begginer_vel: Curve = Curve.new()
@export var easy_pro_vel: Curve = Curve.new()
@export var pro_vel: Curve = Curve.new()
@export var pro_hard_vel: Curve = Curve.new()
@export var dashcore_vel: Curve = Curve.new()

@export var measurement_vel: Curve = Curve.new()

var first_trap: bool = false
signal trapped

func _ready():
	check_state_flow()
	
	passive = false
	$Spawn.start(delay)
	
	if Difficulty.diff != 15: #Troll
		match ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][2]:
			0:
				Difficulty.velocity = 900
				max_speed = 1500
				delay = 1.2
				maximum = 0.8
				traps_lvl = 100
			1:
				Difficulty.velocity = 900
				max_speed = 1450
				delay = 1.2
				maximum = 0.6
				traps_lvl = 100
			2:
				Difficulty.velocity = 1000
				max_speed = 1500
				delay = 1.0
				maximum = 0.6
				traps_lvl = 70
			3:
				Difficulty.velocity = 1100
				max_speed = 1700
				delay = 1.0
				maximum = 0.4
				traps_lvl = 50
			4:
				Difficulty.velocity = 1200
				max_speed = 1850
				maximum = 0.4
				traps_lvl = 50
		
	else:
		##Easter Egg
		max_speed = 1000
		delay = 0.2
		maximum = 0.5
		traps_lvl = 0

	if Difficulty.measure:
		Difficulty.velocity = 700
		traps_lvl = 70

func check_state_flow():
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	await get_tree().create_timer(0.5).timeout
	if FlowControl.mode == FlowControl.modes.starting:
		self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		passive = false
	else:
		self.process_mode = Node.PROCESS_MODE_ALWAYS
		passive = true

func _on_spawn_timeout():
	if StatsManager.points < traps_lvl:
		mode = [1,2,3].pick_random()
	else:
		mode = [1,2,3,4,5,6].pick_random()
	
	if mode >= 4 and !first_trap:
		emit_signal("trapped")
		first_trap = true
	
	match mode:
		1:
			skn += 1
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_skin(skn)
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			block_temp.global_position = $Pos_1.global_position
		2:
			skn += 1
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_skin(skn)
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			block_temp.global_position = $Pos_2.global_position
		3:
			skn += 1
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_skin(skn)
			block_temp.global_position = $Pos_1.global_position
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			var block_temp2 = block.instantiate()
			if block_temp.res.skin == 0:
				block_temp2.set_skin(1)
			else:
				block_temp2.set_skin(0)
			block_temp2.global_position = $Pos_2.global_position
			if passive == true:
				block_temp2.menu = true
			add_child(block_temp2)
		4:
			var go = rng.randi_range(1,30)
			if go == 7:
				#mode = 1
				pass
			skn += 2
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_trap()
			block_temp.set_skin(skn)
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			block_temp.global_position = $Pos_1.global_position
		5:
			var go = rng.randi_range(1,30)
			if go == 7:
				#mode = 2
				pass
			skn += 2
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_trap()
			block_temp.set_skin(skn)
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			block_temp.global_position = $Pos_2.global_position
		6:
			var go = rng.randi_range(1,30)
			if go == 7:
				#mode = 3
				pass
			skn += 2
			skn %= 2
			var block_temp = block.instantiate()
			block_temp.set_trap()
			block_temp.set_skin(skn)
			block_temp.global_position = $Pos_1.global_position
			if passive == true:
				block_temp.menu = true
			add_child(block_temp)
			var block_temp2 = block.instantiate()
			block_temp2.set_trap()
			if block_temp.res.skin == 0:
				block_temp2.set_skin(1)
			else:
				block_temp2.set_skin(0)
			block_temp2.global_position = $Pos_2.global_position
			if passive == true:
				block_temp2.menu = true
			add_child(block_temp2)
		
	$Spawn.start(delay)

#Combo sfx pitch
func combo_sfx():
	var sfx_strk = STREAK_SFX.instantiate()
	if (combo_acum + combo_rate) <= combo_max:
		combo_acum += 0.07
	else:
		combo_acum = 1
	sfx_strk.get_node("Combo").pitch_scale = combo_acum
	var path: String = "Main/SFX" if !Difficulty.measure else "Tutorial/SFX"
	get_tree().get_root().get_node(path).add_child(sfx_strk)

func restart_combo():
	combo_acum = 1.0

func _on_faster_timeout():
	if delay > maximum:
		delay -= 0.02
	else:
		$Faster.stop()


func _on_speed_timeout():
	if Difficulty.velocity < max_speed:
		if !Difficulty.measure:
			match ModsManager.active_mod["ExtraDiffs"][Difficulty.diff][2]:
				0:
					Difficulty.velocity = int(begginer_vel.sample(float(StatsManager.points)/100) * 1000)
				1:
					Difficulty.velocity = int(easy_pro_vel.sample(float(StatsManager.points)/100) * 1000)
				2:
					Difficulty.velocity = int(pro_vel.sample(float(StatsManager.points)/100) * 1000)
				3:
					Difficulty.velocity = int(pro_hard_vel.sample(float(StatsManager.points)/100) * 1000)
				4:
					Difficulty.velocity = int(dashcore_vel.sample(float(StatsManager.points)/100) * 1000)
		else:
			Difficulty.velocity = int(measurement_vel.sample(float(StatsManager.points)/100) * 1000)
	else:
		$Speed.stop()

func pause():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func resume():
	process_mode = Node.PROCESS_MODE_ALWAYS
