shader_type spatial;
render_mode unshaded;

uniform float pixelate = 85.0;
uniform float posterize = 3.0;

uniform sampler2D screen_texture: source_color, hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture: source_color, hint_depth_texture, filter_nearest;
uniform sampler2D normal_texture: source_color, hint_normal_roughness_texture, filter_nearest;

float get_depth(vec2 uv, mat4 inv_proj_matrix){
	
	float depth = texture(depth_texture, uv).x;
	
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth); //may change if using opengl backend (?)
	vec4 view = inv_proj_matrix * vec4(ndc, 1.0);
	view.xyz = view.xyz / view.w;
	
	return -view.z; // final depth value
	
}

vec3 colorband(vec3 color){
	float power = 2.0;
	color.x = log(color.x);
	color.y = log(color.y);
	color.z = log(color.z);
	
	return vec3(
		exp(round(color.r * posterize) / posterize), 
		exp(round(color.g * posterize) / posterize),
		exp(round(color.b * posterize) / posterize)
	);
}

//shamelessly stolen from bitbrain
vec3 texturePointSmooth(sampler2D smp, vec2 uv, vec2 pixel_size)
{
	vec2 ddx = dFdx(uv);
	vec2 ddy = dFdy(uv);
	vec2 lxy = sqrt(ddx * ddx + ddy * ddy);
	
	vec2 uv_pixels = uv / pixel_size;
	
	vec2 uv_pixels_floor = round(uv_pixels) - vec2(0.5f);
	vec2 uv_dxy_pixels = uv_pixels - uv_pixels_floor;
	
	uv_dxy_pixels = clamp((uv_dxy_pixels - vec2(0.5f)) * pixel_size / lxy + vec2(0.5f), 0.0f, 1.0f);
	
	uv = uv_pixels_floor * pixel_size;
	
	return textureGrad(smp, uv + uv_dxy_pixels * pixel_size, ddx, ddy).rgb;
}

void vertex() {
	//POSITION = vec4(VERTEX, 1.0);
}

//based on https://www.youtube.com/watch?v=WBoApONC7bM
void fragment() {
	
	vec2 pixel_UV = vec2(SCREEN_UV.x * (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y), SCREEN_UV.y);
	pixel_UV = round(pixel_UV * pixelate) / pixelate;
	pixel_UV.x /= (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y);
	
	vec2 texel_size = vec2(1.0 / pixelate, (1.0 / pixelate));
	texel_size.x /= (VIEWPORT_SIZE.x / VIEWPORT_SIZE.y);
	
	vec3 original = texture(screen_texture, pixel_UV).xyz;
	
	vec3 normal = texture(normal_texture, pixel_UV).xyz * 2.0 - 1.0;
	
	float depth = get_depth(pixel_UV, INV_PROJECTION_MATRIX);
	
	
	//compute color
	ALBEDO = texturePointSmooth(screen_texture, UV, texel_size);
	ALBEDO = colorband(texture(screen_texture, pixel_UV).xyz);
	
	//compute outlines
	
	
	vec2 uvs[4] = {
		
		vec2(pixel_UV.x, pixel_UV.y + texel_size.y),
		vec2(pixel_UV.x, pixel_UV.y - texel_size.y),
		vec2(pixel_UV.x + texel_size.x, pixel_UV.y),
		vec2(pixel_UV.x - texel_size.x, pixel_UV.y)
	};
	
	float depth_diff = 0.0;
	for (int i = 0; i<4; ++i){
		float d = get_depth(uvs[i], INV_PROJECTION_MATRIX);
		depth_diff += depth-d;
	}
	
	if (depth_diff > 2.0){
		
		ALBEDO *= 0.2;
	}
	
	float normal_sum = 0.0;
	for (int i = 0; i<4; ++i){
		
		vec3 n = texture(normal_texture, uvs[i]).xyz * 2.0 - 1.0;
		vec3 normal_diff = normal-n;
		
		vec3 normal_edge_bias = vec3(1, 1, 1);
		float normal_bias_diff = dot(normal_diff, normal_edge_bias);
		float normal_indicator = smoothstep(-0.01, 0.01, normal_bias_diff);
		
		normal_sum += dot(normal_diff, normal_diff) * normal_indicator;
	}
	
	float normal_edge = sqrt(normal_sum);
	
	if (normal_edge > depth/100.0){
		
		ALBEDO *= 0.5;
	}
}


void light() {
	// Called for every pixel for every light affecting the material.
}
