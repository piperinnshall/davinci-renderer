shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float threshold : hint_range(0.0, 2.0, 0.01) = 0.3;
uniform vec3 line_color : source_color = vec3(0.4);
uniform vec3 background_color : source_color = vec3(0.9);

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

void fragment() {
	mat3 luminance;
	for (int x = -1; x <= 1; x++) {
		vec3 row;
		for (int y = -1; y <= 1; y++) {
			vec2 offset = SCREEN_PIXEL_SIZE * vec2(float(x), float(y));
			vec3 cell = texture(screen_texture, SCREEN_UV + offset).rgb;
			row[y + 1] = dot(cell, vec3(0.299, 0.587, 0.114));
		}
		luminance[x + 1] = row;
	}

	float gx = 0.0;
	float gy = 0.0;
	for (int i = 0; i <= 2; i++) gx += dot(kernel_h[i], luminance[i]);
	for (int i = 0; i <= 2; i++) gy += dot(kernel_v[i], luminance[i]);
	float sobel = sqrt(gx * gx + gy * gy);

	COLOR = vec4(sobel > threshold ? line_color : background_color, 1.0);
}