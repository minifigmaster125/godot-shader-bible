shader_type spatial;
render_mode ambient_light_disabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	float i = ATTENUATION;
	vec3 l = LIGHT;
	vec3 n = NORMAL;
	float D = max(0.0, dot(n, l)) * i;
	D = smoothstep(0.0, 0.05, D);
	vec3 diffuse = mix(vec3(0.12, 0.23, 0.534), vec3(1.0), D);
	
	DIFFUSE_LIGHT += diffuse;
}
