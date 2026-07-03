shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE: hint_normal_roughness_texture, filter_linear_mipmap;

uniform float threshold: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec3 line_color: source_color = vec3(0.4);
uniform vec3 background_color: source_color = vec3(0.9);

const mat3 kernel_h = mat3(
	vec3(1.0, 2.0, 1.0),
	vec3(0.0, 0.0, 0.0),
	vec3(-1.0, -2.0, -1.0)
);

const mat3 kernel_v = mat3(
	vec3(1.0, 0.0, -1.0),
	vec3(2.0, 0.0, -2.0),
	vec3(1.0, 0.0, -1.0)
);

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	vec3 normal = texture(NORMAL_TEXTURE, SCREEN_UV).rgb * 2.0 - 1.0;
	
	mat3 pixels;
	for (int x = -1; x <= 1; x++){
		vec3 row;
		for (int y = -1; y <= 1; y++){
			vec2 offset = pixel_size * vec2(float(x), float(y));
			vec3 cell = texture(NORMAL_TEXTURE, SCREEN_UV + offset).rgb;
			row[y + 1] = length(cell - normal);
		}
		pixels[x + 1] = row;
	}
	
	float gx = 0.0;
	float gy = 0.0;
	for (int i = 0; i <= 2; i++) gx += dot(kernel_h[i], pixels[i]);
	for (int i = 0; i <= 2; i++) gy += dot(kernel_v[i], pixels[i]);
	float sobel = sqrt(gx * gx + gy * gy);
	
	ALBEDO = sobel > threshold ? line_color : background_color;
}
