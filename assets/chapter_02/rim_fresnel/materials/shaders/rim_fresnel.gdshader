shader_type spatial;
render_mode ambient_light_disabled;

float lambert(vec3 light, vec3 normal, float attenuation) {
	return max(0.0, dot(normal, light)) * attenuation;
}

float phong(vec3 view, vec3 light, vec3 normal, float sharpness) {
	vec3 reflected_light = reflect(-light, normal);
	return pow(max(0.0, dot(reflected_light, view)), sharpness);
}

float fresnel(vec3 normal, vec3 view, float sharpness, float roughness){
	return roughness *  pow((1. - max(0.0, dot(view, normal))), sharpness);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {

	float diffuse = lambert(LIGHT, NORMAL, ATTENUATION) * .3;
	float s = phong(VIEW, LIGHT, NORMAL, 200.0);
	float rim = fresnel(NORMAL, VIEW, 10., 10.);
	
	DIFFUSE_LIGHT += vec3(diffuse + rim);
	SPECULAR_LIGHT += vec3(s);
}
