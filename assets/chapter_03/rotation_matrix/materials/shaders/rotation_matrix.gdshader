shader_type spatial;

uniform sampler2D _BaseMap : source_color;

uniform vec3 _Angles;

#define RX(a) mat3( \
	vec3(1,0,0),	\
	vec3(0, cos(a), -sin(a)), \
	vec3(0, sin(a), cos(a))) 
	
#define RY(a) mat3( \
	vec3(cos(a),0, sin(a)),	\
	vec3(0, 1, 0), \
	vec3(-sin(a), 0, cos(a))) 
	
#define RZ(a) mat3( \
	vec3(cos(a), -sin(a),0), \
	vec3(sin(a), cos(a), 0), \
	vec3(0, 0, 1)) 

void vertex() {
	// Called for every vertex the material is visible on.
	vec3 angles = _Angles * (PI / 180.0);
	mat3 EULER_ZXY = RY(angles.y) * RX(angles.x) * RZ(angles.z);
	VERTEX = EULER_ZXY * VERTEX;
	NORMAL = normalize(EULER_ZXY * NORMAL);
	
}

void fragment() {
	vec3 albedo = texture(_BaseMap, UV).rgb;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
