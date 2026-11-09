shader_type spatial;
// cull_front ensures we only render the expanded back-faces (the outer rim)
// unshaded keeps it flat-colored without lighting calculations
render_mode blend_mix, cull_front, unshaded;

// Optional: toggle and styling controls
uniform bool enable_outline = true;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_width : hint_range(0.0, 0.1, 0.001) = 0.015;

void vertex() {
	if (enable_outline) {
		// Extrude vertices outward along their normals
		VERTEX += NORMAL * outline_width;
	}
}

void fragment() {
	if (!enable_outline) {
		discard;
	}
	
	ALBEDO = outline_color.rgb;
	ALPHA = outline_color.a;
}