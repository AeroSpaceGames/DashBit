extends Node2D

@export var extra_vel: int = 500

var rng = RandomNumberGenerator.new()

func add_vel():
	@warning_ignore("integer_division")
	#extra_vel = Difficulty.velocity/2
	#Difficulty.velocity += extra_vel
	pass

func remove_vel():
	#Difficulty.velocity -= extra_vel
	pass

func init():
	rng = randf_range(6, 9)
	$Timer.start(rng)
	$Anim.play("Show")


func _on_timer_timeout() -> void:
	$Anim.play("Hide")
