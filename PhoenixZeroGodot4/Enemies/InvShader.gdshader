shader_type spatial;

render_mode blend_add;

uniform vec4 color_gap: source_color = vec4(0.25);
uniform vec4 color_stripe: source_color = vec4(1.0, 0.75, 0.0, 1.0);
uniform float divisions = 8.0; // increase for more stripe density
uniform float stripe_bias = 2.6; // 1.0 means no stripes; 2.0 means stripes and gaps are equal size
const float speed = 1.5;
const float angle = 1.0; // in radians

void fragment() {
//	vec4 test = VIEW_MATRIX * vec4(VERTEX.y, VERTEX.z,VERTEX.x, 0.1);
	float w = cos(angle) * VERTEX.y + sin(angle) * VERTEX.z - speed * TIME;
//	float w = cos(angle) * UV.x + sin(angle) * UV.y - speed * TIME;
	if (floor(mod(w * divisions, stripe_bias)) < 0.0001) {
		vec3 final;
		final.r = color_gap.r* (mod(w * divisions, stripe_bias));
		final.g = color_gap.g* (mod(w * divisions, stripe_bias));
		final.b = color_gap.b* (mod(w * divisions, stripe_bias));
		ALBEDO = final;
		ALPHA = color_gap.a * (mod(w * divisions, stripe_bias));
	} else {
		vec3 final;
		final.r = color_stripe.r;
		final.g = color_stripe.g;
		final.b = color_stripe.b;
		ALBEDO = final;
		ALPHA = color_stripe.a;
	}
}
