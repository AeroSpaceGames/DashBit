shader_type canvas_item;

uniform sampler2D texture_a : filter_nearest;
uniform sampler2D texture_b : filter_nearest;
uniform sampler2D texture_c : filter_nearest;
uniform float blend : hint_range(0.0, 2.0, 0.1);

void fragment() {
	vec2 uv = UV;
	vec4 col_a = texture(texture_a, UV);
	vec4 col_b = texture(texture_b, UV);
	vec4 col_c = texture(texture_c, UV);

	if (blend<1.0){
		COLOR = mix(col_a, col_b, blend) * vec4(0.6,0.6,0.6,1);
	}
	else {
		COLOR = mix(col_b, col_c, blend - 1.0) * vec4(0.6,0.6,0.6,1);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
