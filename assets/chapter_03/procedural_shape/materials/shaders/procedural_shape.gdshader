shader_type spatial;
render_mode unshaded;

uniform float _EyebrowRotation : hint_range(0.0, 45.0, .1); // A1
uniform float _BackboneRotation : hint_range(17.0, 45.0, 0.1) = 17.0; // A2
uniform float _HeadSize : hint_range(.30, .38, 0.01) = .3; // S
uniform float _FacePosition : hint_range(.0, .1, .01) = 0.04; // P
uniform float _EyeSize : hint_range(.04, .1, .01) = .04; // T

uniform vec3 _HeadColor: source_color;
uniform vec3 _EyeColor: source_color;
uniform vec3 _BackboneColor : source_color;
uniform vec3 _BandanaColor: source_color;
uniform vec3 _EyebrowColor: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

float  eyes_shape (vec2 uv, float p, float r, float s){
	float u_coord = abs(uv.x) - 0.15;
	float v_coord = uv.y + p;
	return float(dot(vec2(u_coord, v_coord), vec2(u_coord, v_coord)) > pow(r, 2) * s);
}

vec2 rotation(float x, float y, float a){
	float ru = cos(a) * x + sin(a) * y;
	float rv = -sin(a) * x + cos(a) * y;
	return vec2(ru, rv);
}

float back_bone_shape(vec2 p){
	float r = .06;
	float u = min(.42 - abs(p.x), .04);
	float v = abs(p.y ) - .04;
	vec2 uv = vec2(u,v);
	return float(dot(uv, uv) < r*r);
}

float eyebrow_shape(vec2 p){
	float r = 0.03;
	float u = min(0.05 - abs(p.x), .0);
	float v = p.y;
	vec2 uv = vec2(u, v);
	return float(dot(uv, uv) < r*r);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float u = UV.x - 0.5;
	float v = (1. - UV.y) - 0.5;
	vec2 uv = vec2(u,v);
	
	float r1 = _EyebrowRotation * (PI/180.);
	float r2 = _BackboneRotation * PI/180.;
	vec2 p0 = rotation(u - 0.1, v - 0.15 + _FacePosition, r1);
	float eyebrow_r = eyebrow_shape(p0);
	vec2 p1 = rotation(u + 0.1, v - 0.15 + _FacePosition, -r1);
	float eyebrow_l = eyebrow_shape(p1);
	float eyebrows = eyebrow_l + eyebrow_r;
	
	vec2 p2 = rotation(u, v, r2);
	vec2 p3 = rotation(u, v, -r2);
	float back_bone_l = back_bone_shape(p2);
	float back_bone_r = back_bone_shape(p3);
	float back_bones = back_bone_l + back_bone_r;
	float back_bones_mask = 1. - float(dot(uv, uv) < pow(_HeadSize + 0.02, 2));
	back_bones *= back_bones_mask;
	
	float head = float(dot(uv, uv) < pow(_HeadSize,2.));
	float jaw = float(pow(min(_HeadSize -.23 - abs(u), 0.), 4.) + pow(min(.12 - abs(v + (_HeadSize - 0.15)), 0.0), 4.0) < pow(0.05, 4.0));
	head = clamp(head + jaw, 0.0, 1.0);
	head *= eyes_shape(uv, _FacePosition, 0.1, 1.0);
	float eyes = 1.0 - eyes_shape(uv, _FacePosition, _EyeSize, 0.5);
	float nose = 1.0 - float(-_FacePosition - v > 2.0 * abs(u) + 0.05) * float(-_FacePosition - v < 0.15);
	float bandana = float(sqrt(UV.x) < 1.0 - UV.y);
	
	head *= nose;
	bandana *= head;
	
	vec3 render_rgb = vec3(0.);
	float alpha = 0.;
	
	vec3 head_color = _HeadColor * head;
	vec3 eyes_color = _EyeColor * eyes;
	vec3 bandana_color = _BandanaColor * bandana;
	vec3 eyebrow_color = _EyebrowColor * eyebrows;
	vec3 backbone_color = _BackboneColor * back_bones;
	
	render_rgb += back_bones;
	render_rgb += head_color;
	render_rgb += eyes_color;
	render_rgb = mix(render_rgb, bandana_color, bandana);
	render_rgb = mix(render_rgb, eyebrow_color, eyebrows);
	
	ALBEDO = vec3(render_rgb);
	ALPHA = alpha + head + eyes + back_bones;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
