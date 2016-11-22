#version 440

layout (location = 0) uniform sampler2DRect sampler_world_position;
layout (location = 1) uniform sampler2DRect sampler_world_normal;
layout (location = 2) uniform sampler2DRect sampler_world_material;

uniform int currentSpotLight;

struct DirectionalLight
{
	vec3 direction;
	float padding1;
	vec3 intensity;
	float padding2;
};

struct PointLight
{
	vec3 position;
	float range;
	vec3 intensity;
	float padding;
};

struct AmbientLightBlock
{
	vec3 ambient_light;
	float padding;
};


struct SpotLight
{
	vec3 position;
	float range;
	vec3 direction;
	float coneAngle;
	vec3 intensity;
	bool castShadow;
};

layout(std140) uniform DataBlock
{
	PointLight pointLight[20];
	AmbientLightBlock ambientLight;
	DirectionalLight directionalLight[2];
	SpotLight spotLight[5];
	vec3 cameraPosition;
	float maxPointLights;	
	float maxDirectionalLights;
	float maxSpotlights;
};

out vec3 reflected_light;


vec3 DiffuseLight(vec3 lightPosition, vec3 lightIntensity, float attenuation);
vec3 SpotLightCalc(vec3 colour);

vec3 vertexPos = vec3(0,0,0);
vec3 vertexNormal = vec3(0,0,0);

void main(void)
{
	vec3 texel_N = texelFetch(sampler_world_normal, ivec2(gl_FragCoord.xy)).rgb;
	vertexPos = texelFetch(sampler_world_position, ivec2(gl_FragCoord.xy)).rgb;
	vertexNormal = normalize(texel_N);

	vec3 final_colour = SpotLightCalc(vec3(0,0,0));
	reflected_light = final_colour;
}


/*
Calculate the diffuse light for the point light and apply the diffuse texture.
Also call the specular for that light and add it to the diffuse value
@param currentLight - the light which the diffuse calculations need to be applied on
@param attenuation - the distance the light has an effect on
@return diffuseColour - the end result of the individual lights lighting calculation
*/
vec3 DiffuseLight(vec3 lightPosition, vec3 lightIntensity, float attenuation)
{
	vec3 L = normalize(lightPosition - vertexPos);
	float scaler = max(0, dot(L, normalize(vertexNormal))) * attenuation;

	if (scaler == 0)
		return vec3(0, 0, 0);

	vec3 diffuse_intensity = lightIntensity * scaler;


	return  diffuse_intensity;
}

vec3 SpotLightCalc(vec3 colour)
{
	
	SpotLight spot = spotLight[currentSpotLight];
		

	// Compute smoothed dual-cone effect.
	float cosDir = dot(normalize(spot.position - vertexPos), -spot.direction);
	float spotEffect = smoothstep(cos(spot.coneAngle), cos(spot.coneAngle / 2), cosDir);

	float dist = distance(spot.position, vertexPos);
	float attenuation = 1 - smoothstep(0.0, spot.range, dist);
	// Compute height attenuation based on distance from earlier.
	//float attenuation = smoothstep(spot.range, 0.0f, length(spot.position - vertexPos));

	vec3 diffuse_intensity = DiffuseLight(spot.position, spot.intensity, attenuation);
				

	colour += (diffuse_intensity * spotEffect);

	

	return colour;
}