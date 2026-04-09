extends Node2D

var dust = preload("res://Particles/dust_1.tscn")

@onready var p2 = $Black
@onready var p1 = $White

var once = false

var change = false
var can_change = true

func _ready():
	$White_sprite.play(SkinControl.new_skin)
	$Black_sprite.play(SkinControl.new_skin)
	$PlayerColoring.set_players_color()

func _process(_delta):
	if can_change == true:
		if Input.is_action_just_pressed("flip"):
			if once == false:
				$Tap.play("Fade")
				FlowControl.mode = FlowControl.modes.playing
				once = true
			if change == false:
				$White/Collision.disabled = true
				$Black/Collision.disabled = true
				$Animations.play("side_2")
				CameraShake.scree_shake(3, 0.2)
				change = true
			else:
				$White/Collision.disabled = true
				$Black/Collision.disabled = true
				$Animations.play("side_1")
				CameraShake.scree_shake(3, 0.2)
				change = false
			can_change = false


func _on_animations_animation_finished(anim_name):
	can_change = true
	$White/Collision.disabled = false
	$Black/Collision.disabled = false
	if anim_name == "side_2":
		p1.global_position = $Pos_2.global_position
		p2.global_position = $Pos_1.global_position
	elif anim_name == "side_1":
		p1.global_position = $Pos_1.global_position
		p2.global_position = $Pos_2.global_position


func _on_movile_button_pressed():
	if once == false:
		$Tap.play("Fade")
		FlowControl.mode = FlowControl.modes.playing
		once = true
	if can_change == true:
		if change == false:
			$White/Collision.disabled = true
			$Black/Collision.disabled = true
			$Animations.play("side_2")
			change = true
			can_change = false
		else:
			$White/Collision.disabled = true
			$Black/Collision.disabled = true
			$Animations.play("side_1")
			change = false
			can_change = false

func _generate_dust():
	var temp_dust = dust.instantiate()
	var temp_dust2 = dust.instantiate()
	temp_dust.position = $Pos_1.position
	temp_dust2.position = $Pos_2.position
	temp_dust.emitting = true
	temp_dust2.emitting = true
	temp_dust2.scale.x = -1
	add_child(temp_dust)
	add_child(temp_dust2)

func pause():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func resume():
	process_mode = Node.PROCESS_MODE_ALWAYS
