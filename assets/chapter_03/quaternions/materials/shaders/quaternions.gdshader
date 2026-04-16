shader_type spatial;
render_mode unshaded;

uniform sampler2D _FrontMap : source_color, repeat_disable;
uniform sampler2D _BackMap : source_color, repeat_disable;
uniform sampler2D _SpotMap : source_color, repeat_disable;
uniform vec3 _LightRotation;
uniform vec3 _LightPosition;

void vertex() {
	// Called for every vertex the material is visible on.
	

	

}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec3 vertex_ws = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).rgb;
	vec3 position_ws = vertex_ws - _LightPosition;
	
	vec3 front_map = texture(_FrontMap, UV).rgb;
	vec3 back_map = texture(_BackMap, UV).rgb;
	float spot_map = texture(_SpotMap, position_ws.xy).r;
	
	ALBEDO = vec3(spot_map);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
