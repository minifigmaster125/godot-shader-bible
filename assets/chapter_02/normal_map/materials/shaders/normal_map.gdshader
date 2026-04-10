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
	vec3 normal_map = texture(_NormalMap, UV).rgb;
	normal_map = normal_map * 2. -1.;
	normal_map *= _Scale;
	float n_z = clamp(dot(normal_map.xy, normal_map.xy), 0.0, 1.0);
	normal_map.z = sqrt(1. - n_z);
	
	mat3 TBN = mat3(TANGENT.xyz, BINORMAL.xyz, NORMAL.xyz);
	vec3 normal_vs = normalize(TBN * normal_map);
	NORMAL = normal_vs;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
