shader_type spatial;
render_mode ambient_light_disabled;

float lambert(vec3 light, vec3 normal, float attenuation) {
	return max(0.0, dot(normal, light)) * attenuation;
}

float phong(vec3 view, vec3 light, vec3 normal, float sharpness) {
	vec3 reflected_light = reflect(-light, normal);
	return pow(max(0.0, dot(reflected_light, view)), sharpness);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {

	float diffuse = lambert(LIGHT, NORMAL, ATTENUATION);
	float s = phong(VIEW, LIGHT, NORMAL, 200.0);
	
	DIFFUSE_LIGHT += vec3(diffuse) * 0.3;
	SPECULAR_LIGHT += vec3(s);
}
