extends CharacterBody2D

const BLACK_DESTROY = preload("res://Particles/Black_destroy.tscn")
const STREAK = preload("res://Particles/Streak.tscn")

const BREAK_SFX = preload("res://Scenes/SFX/break_sfx.tscn")
@export var miss_sound : AudioStream
@export var fire_sound : AudioStream

@export var res : obstacle

@export var trap : bool = false

var check = "Nothing"

@export_group("Texture_debris")
@export var white_debris : Texture2D
@export var black_debris : Texture2D
@export_group("")

var healing : int = 2
var dmg : int = 4

var menu : bool = false

var player : Area2D

@export var measure_heal: Curve = Curve.new()
@export var measure_dmg: Curve = Curve.new()

@export var begginer_heal: Curve = Curve.new()
@export var begginer_dmg: Curve = Curve.new()

@export var begginer_mid_heal: Curve = Curve.new()
@export var begginer_mid_dmg: Curve = Curve.new()

@export var pro_heal: Curve = Curve.new()
@export var pro_dmg: Curve = Curve.new()

@export var pro_hard_heal: Curve = Curve.new()
@export var pro_hard_dmg: Curve = Curve.new()

@export var dashcore_heal: Curve = Curve.new()
@export var dashcore_dmg: Curve = Curve.new()

@export var troll_heal: Curve = Curve.new()
@export var troll_dmg: Curve = Curve.new()

func _ready():
	
	match Difficulty.diff:
		0:
			healing = 3
			dmg = 2
		1:
			healing = 3
			dmg = 3
		2:
			healing = 2
			dmg = 4
		##Easter Egg
		4:
			healing = 0
			dmg = 10
	
	if FlowControl.mode == FlowControl.modes.menu:
		menu = true
	else:
		menu = false


func set_trap():
	trap = true

func set_skin(n : int):
	%Sprite.material.set_shader_parameter("WhiteColor", SkinControl.colors_set[SkinControl.new_skin])
	%Sprite.material.set_shader_parameter("BlackColor", SkinControl.colors_set[SkinControl.new_skin].inverted())
	if trap == false:
		res.skin = n
		%Sprite.play(str(res.skin) + "_" + SkinControl.new_skin)
	else:
		res.skin = n
		if res.skin == 1:
			%Sprite.play("3_" + SkinControl.new_skin)
		else:
			%Sprite.play("2_" + SkinControl.new_skin)
	if res.skin == 0:
		%Sprite.material.set_shader_parameter("ColoringMode",false)
	else:
		%Sprite.material.set_shader_parameter("ColoringMode",true)

#region functionality

func _physics_process(delta):
	if typeof(check) == TYPE_STRING:
		velocity.y = Difficulty.velocity
		move_and_collide(velocity * delta)

func _process(_delta):
	if $Block.get_overlapping_areas().size() >= 1:
		_on_block_area_entered($Block.get_overlapping_areas()[0])

func _on_block_area_entered(area):
	player = area
	
	if player.is_in_group("Thunder"):
		$Squash.play("Squash")
		return
	
	if area.is_in_group("Miss"):
		velocity.y = Difficulty.velocity
		var temp_sfx = BREAK_SFX.instantiate()
		temp_sfx.get_node("Break").stream = miss_sound
		var path = "Main" if !Difficulty.measure else "Tutorial"
		get_tree().get_root().get_node(path).add_child(temp_sfx)
		ComboManager.loose()
		$Shake.play("shake")
		%Sprite.material.set_shader_parameter("Miss",true)
		%Sprite.self_modulate = Color(1,1,1,0.8)
		player = null
	
	if area.is_in_group("Op_Blocks"):
		if !menu:
			var temp_sfx = BREAK_SFX.instantiate()
			temp_sfx.get_node("Break").stream = fire_sound
			var path = "Main" if !Difficulty.measure else "Tutorial"
			get_tree().get_root().get_node(path).add_child(temp_sfx)
			StatsManager.hurt(dmg)
			CameraShake.hurt()
			CameraShake.shake()
		queue_free()
	
	#await get_tree().create_timer(0.15).timeout
	
	if trap == false:
		if res.skin == 0:
			if area.is_in_group("White"):
				check = 0
				velocity.y = 0
				$Squash.play("Squash")
			else:
				pass
		else:
			if area.is_in_group("Black"):
				check = 1
				velocity.y = 0
				$Squash.play("Squash")
			else:
				pass
	elif trap == true:
		if res.skin == 0:
			if area.is_in_group("Black"):
				check = 1
				velocity.y = 0
				$Squash.play("Squash")
			else:
				pass
		else:
			if area.is_in_group("White"):
				check = 0
				velocity.y = 0
				$Squash.play("Squash")
			else:
				pass
		
#endregion


func destroy():
	if is_instance_valid(player):
		if player.has_node("Bounce"):
			player.get_node("Bounce").play("Feedback")
		else:
			queue_free()
			return
	
	ComboManager.add()
	if ComboManager.multiplier < 2:
		block_sfx()
		debris()
	else:
		get_parent().combo_sfx()
		var particle = STREAK.instantiate()
		particle.global_position = self.global_position
		particle.emitting = true
		var path: String = "Main/Particles" if !Difficulty.measure else "Tutorial/Particles"
		get_tree().get_root().get_node(path).add_child(particle)
	CameraShake.shake()
	##Custom points
	StatsManager.change_p(1)
	StatsManager.heal(healing)
	queue_free()


func block_sfx():
	get_parent().restart_combo()
	var sfx_brk = BREAK_SFX.instantiate()
	var path: String = "Main/SFX" if !Difficulty.measure else "Tutorial/SFX"
	get_tree().get_root().get_node(path).add_child(sfx_brk)


#region debris list
func debris():
	var particle = BLACK_DESTROY.instantiate()
	particle.texture = black_debris
	particle.global_position = self.global_position
	particle.emitting = true
	if res.skin == 0:
		particle.texture = white_debris
		particle.material.set_shader_parameter("Color",SkinControl.colors_set[SkinControl.new_skin])
	else:
		particle.texture = black_debris
		particle.material.set_shader_parameter("Color",SkinControl.colors_set[SkinControl.new_skin].inverted())
	var path: String = "Main/Particles" if !Difficulty.measure else "Tutorial/Particles"
	get_tree().get_root().get_node(path).add_child(particle)
#endregion

func _on_squash_animation_finished(_anim_name: StringName) -> void:
	velocity.y = Difficulty.velocity
	destroy()

func _on_shake_animation_finished(_anim_name: StringName) -> void:
	self.position.y += 50
	velocity.y = Difficulty.velocity

func get_dmg_and_heal(points: int):
	
	if Difficulty.measure:
		@warning_ignore("integer_division")
		return [measure_heal.sample(int(points/100)) * 10, measure_dmg.sample(int(points/100)) * 10]
	
	if Difficulty.diff == 15:
		@warning_ignore("integer_division")
		return [troll_heal.sample(int(points/100)) * 10, troll_dmg.sample(int(points/100)) * 10]
	
	match Difficulty.diff:
		0:
			@warning_ignore("integer_division")
			return [begginer_heal.sample(int(points/100)) * 10, begginer_dmg.sample(int(points/100)) * 10]
		1:
			@warning_ignore("integer_division")
			return [begginer_mid_heal.sample(int(points/100)) * 10, begginer_mid_dmg.sample(int(points/100)) * 10]
		2:
			@warning_ignore("integer_division")
			return [pro_heal.sample(int(points/100)) * 10, pro_dmg.sample(int(points/100)) * 10]
		3:
			@warning_ignore("integer_division")
			return [pro_hard_heal.sample(int(points/100)) * 10, pro_hard_dmg.sample(int(points/100)) * 10]
		4:
			@warning_ignore("integer_division")
			return [dashcore_heal.sample(int(points/100)) * 10, dashcore_dmg.sample(int(points/100)) * 10]

func _on_timer_timeout() -> void:
	var heal_dmg = get_dmg_and_heal(StatsManager.points)
	healing = heal_dmg[0]
	dmg = heal_dmg[1]


func pause():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func resume():
	process_mode = Node.PROCESS_MODE_ALWAYS
