shader_type canvas_item;
render_mode skip_vertex_transform;

uniform bool _VertexAnimation;
uniform float _VertexScale : hint_range(0.,  1., 0.01);
uniform float _VertexSpeed : hint_range(1., 3., .1);
uniform float _SpecularSpeed : hint_range(.5, 2., 0.1);
uniform vec3 _SpecularColor : source_color;

float scale_from_center(float a, float x){
	float b = x * (a - 1.) * .5;
	return b;
}

float projection(vec2 a, vec2 b, vec2 c){
	return dot(a - b, c -b)/dot(c - b, c - b);
}

float segment_sd(vec2 uv, vec2 p0, vec2 p1){
	float h = projection(uv, p0, p1);
	h = clamp(h, 0., 1.);
	vec2 p2 = p0 + h * (p1 - p0);
	return distance(p2, uv);
}



void vertex() {
	// Called for every vertex the material is visible on.
	if (!_VertexAnimation){
		VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	} else {
		float color_id = dot(COLOR.rgb, COLOR.rgb);
		float time = (color_id + TIME * _VertexSpeed) * PI;
		float scale_ratio = sin(time) * _VertexScale + (1.0 + _VertexScale);
		const float pixel_scaler  = 0.5;
		vec2 resolution = pixel_scaler / TEXTURE_PIXEL_SIZE;
		float px = scale_from_center(scale_ratio, resolution.x);
		float py = scale_from_center(scale_ratio, resolution.y);
		vec2 scaled_vertex = VERTEX * vec2(scale_ratio);
		scaled_vertex -= vec2(px,py);
		VERTEX = (MODEL_MATRIX * vec4(scaled_vertex, 0., 1.)).xy;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	float time = TIME / _SpecularSpeed;
	float offset = fract(time) * 3. - 1.5;
	float offset_mask = ceil(sin(time * PI)) + 0.00001;
	
	offset *= offset_mask;
	
	vec2 p0 = vec2(.5 + offset, 0.8);
	vec2 p1 = vec2(0.5 + offset, .2);
	vec2 uv = vec2(UV.x, 1. - UV.y);
	uv += color.b;
	
	float specular = segment_sd(uv, p0, p1);
	specular = smoothstep(0.2, 0.1, specular);
	specular *= offset_mask;
	vec3 specular_color = vec3(specular) * _SpecularColor;
	color.rgb += specular_color;
	color.rgb = clamp(color.rgb, 0., 1.);
	COLOR = color;
	//COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
