shader_type spatial;
render_mode diffuse_toon;
render_mode specular_toon;

uniform sampler2D _MainTex;
uniform sampler2D _NormalMap : hint_normal;
uniform float _Scale : hint_range(-16., 16., 0.1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 albedo = texture(_MainTex, UV).xyz;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
