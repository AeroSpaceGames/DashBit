extends Node2D

var white_col: Color
var black_col: Color

var w_sprite: CompressedTexture2D = preload("res://Assets/PNG/UI/Eff_Ads/ThunderWhite.png")
var b_sprite: CompressedTexture2D = preload("res://Assets/PNG/UI/Eff_Ads/ThunderBlack.png")

var bw: int = 2

var thread: Thread = Thread.new()

func config_colors():
	white_col = SkinControl.colors_set[SkinControl.new_skin]
	black_col = SkinControl.colors_set[SkinControl.new_skin].inverted()
	%Advertisement.material.set_shader_parameter("WhiteColor", white_col)
	%Advertisement.material.set_shader_parameter("BlackColor", black_col)

func generate_thunder():
	var side: int = [0,1].pick_random()
	bw = [0,1].pick_random()
	if bw == 0:
		%Advertisement.texture = w_sprite
		%Advertisement.material.set_shader_parameter("ColoringMode", false)
		%Beam.material.set_shader_parameter("color", white_col)
		%Beam.material.set_shader_parameter("outline_color", black_col)
	else:
		%Advertisement.texture = b_sprite
		%Advertisement.material.set_shader_parameter("ColoringMode", true)
		%Beam.material.set_shader_parameter("color", black_col)
		%Beam.material.set_shader_parameter("outline_color", white_col)
	
	if side == 0:
		%Lighting.global_position.x = $Left.global_position.x
		%Advertisement.position.x = $Left.position.x
		%Beam.material.set_shader_parameter("y_offset", -0.25)
	else:
		%Lighting.global_position.x = $Right.global_position.x
		%Advertisement.position.x = $Right.position.x
		%Beam.material.set_shader_parameter("y_offset", 0.25)
	
	%Detector.position.x = self.get_child(side).position.x
	$Animations.play("AD")

func _on_timer_timeout() -> void:
	generate_thunder()


func _on_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Thunder"):
		return
	
	match bw:
		0:
			if area.is_in_group("Black"):
				StatsManager.hurt(10)
				CameraShake.hurt()
				CameraShake.shake()
		1:
			if area.is_in_group("White"):
				StatsManager.hurt(10)
				CameraShake.hurt()
				CameraShake.shake()
