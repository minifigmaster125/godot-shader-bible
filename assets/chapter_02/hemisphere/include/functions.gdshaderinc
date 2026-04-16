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