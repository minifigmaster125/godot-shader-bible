shader_type spatial;
render_mode ambient_light_disabled;

uniform sampler2D _MainTex : source_color;
uniform vec3 _GroundColor : source_color;
uniform vec3 _SkyColor : source_color;
uniform float _Smoothness: hint_range(0.0, 0.5, 0.01);

float hemisphere(vec3 n, float s){
	float t = n.y * 0.5 + 0.5;
	return smoothstep(0.0 + s, 1.0 - s, t);
}

float lambert(vec3 n, vec3 l, vec3 i){
	return max(0.0, dot(n,l)) * i;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 albedo = texture(_MainTex, UV).rgb;
	ALBEDO = albedo;
}

void light() {
	vec3 normal_ws = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	vec3 lambert = lambert(NORMAL, LIGHT, ATTENUATION) * LIGHT_COLOR;
	DIFFUSE_LIGHT += lambert;
	
	float gradient = hemisphere(normal_ws, _Smoothness);
	vec3 custom_ambient = mix(_GroundColor, _SkyColor, gradient);
	
	DIFFUSE_LIGHT += custom_ambient;
}
