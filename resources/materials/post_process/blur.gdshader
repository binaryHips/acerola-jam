shader_type spatial;
render_mode unshaded;
uniform float amount: hint_range(0.0, 5.0);
uniform sampler2D screen_texture:hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_texture: source_color, hint_depth_texture, filter_nearest;
void fragment() {
	
	if (texture(depth_texture, SCREEN_UV).x < 20.0) ALPHA = 0.0;
	
	
	ALBEDO = textureLod(screen_texture, SCREEN_UV, amount).rgb;
}
