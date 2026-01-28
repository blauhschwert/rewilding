shader_type spatial;

uniform vec4 stalk_color : source_color = vec4(0.45, 0.81, 0.57, 1.0);
uniform vec4 node_color : source_color = vec4(0.97, 0.92, 0.85, 1.0);
uniform float node_scale = 18.0;
uniform float shift = 0.001;
uniform float noise_scale = 450.0;

float node(float y)
{
	float f = mod(y * node_scale, 1.0);
	return float(f < 0.02) * sin (f * 50.0);
}

void fragment() {
	float x = sin( cos(UV.x * noise_scale) * 6.0)  * max(sin(UV.y * node_scale) * 0.05, 0.01);
	float y = clamp(-node(UV.y - shift) + node(UV.y + shift), -0.5, 0.5);

	NORMAL_MAP = normalize(vec3(0.5 + x, 0.5 + y, 0.5 ));
	ALBEDO = mix(stalk_color.rgb, node_color.rgb, node(UV.y));
}
