
shader_type spatial;
render_mode blend_mix, depth_draw_never, unshaded, cull_disabled;

void vertex() {
	// Billboarding code for trails
	// CUSTOM0 contains the tangent of the trail and the width
	if (dot(CUSTOM0.xyz, CUSTOM0.xyz) > 0.0) {
		vec3 p = (inverse(MODELVIEW_MATRIX) * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
		p = VERTEX - p;
		vec3 t = CUSTOM0.xyz;
		vec3 binormal = normalize(cross(p, t));
		vec3 normal = normalize(cross(t, binormal));
		vec3 tangent = normalize(cross(binormal, normal));
		VERTEX += CUSTOM0.w * binormal;
		NORMAL = normal;
		TANGENT = tangent;
		BINORMAL = binormal;
	}
}

void fragment() {
	ALBEDO = vec3(1.0, 0.0, 0.0);
	EMISSION = vec3(1.0, 0.0, 0.0) * 1.0; // 100% = multiplier of 1.0
	ALPHA = COLOR.a;
}
