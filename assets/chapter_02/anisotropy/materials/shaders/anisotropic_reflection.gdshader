shader_type spatial;

uniform sampler2D _MainTex;
uniform float _AU : hint_range(0., 256., 0.1);
uniform float _AV : hint_range(0., 256., 0.1);
uniform float _ReflectionFactor : hint_range(0., 1., 0.1);

varying vec3 _tangent;
varying vec3 _binormal;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	_tangent = TANGENT;
	_binormal = BINORMAL;
	
	vec3 albedo = texture(_MainTex, UV).rgb;
	ALBEDO = albedo;
}

float lambert(float i, vec3 l, vec3 n){
	return max(0, dot(n, l)) * i;
}

float ashikhmin_shirley(float rs, float au, float av, vec3 n, vec3 l, vec3 v, vec3 t, vec3 b)
{
	vec3 h = normalize(l + v);
	float NdotL = max(dot(n, l), 0.00001);
	float NdotV = max(dot(n, v), 0.0001);
	float NdotH = max(dot(n,h), 0.0001);
	float VdotH = max(dot(v,h), 0.0001);
	
	float HdotT = dot(h, t);
	float HdotB = dot(h, b);
	
	float exponent = au * pow(HdotT, 2.) + av * pow(HdotB, 2.);
	exponent /= 1. - pow(NdotH, 2.);
	
	float specular = sqrt((au + 1.0) * (av + 1.0)) * pow(NdotH, exponent);
	specular /= (8. * PI) * VdotH * max(NdotL, NdotV);
	
	float fresnel = rs + (1.0 - rs) * pow(1. - VdotH, 5.);
	specular *= fresnel;
	
	return specular;
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
	
	float aniso = ashikhmin_shirley(_ReflectionFactor, _AU, _AV, NORMAL, LIGHT, VIEW, _tangent, _binormal);
	vec3 albedo = ALBEDO;
	aniso *= albedo.r * albedo.g * albedo.b;
	aniso = smoothstep(0.0, 0.1, aniso);
	aniso *= lambert(ATTENUATION, LIGHT, NORMAL);

	DIFFUSE_LIGHT += albedo;
	SPECULAR_LIGHT += aniso;
}
