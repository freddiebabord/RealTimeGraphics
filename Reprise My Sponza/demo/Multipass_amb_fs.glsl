#version 440
#extension GL_EXT_texture_array : enable


layout (std140) uniform DataBlock {
	vec3 camera_position;
	vec3 global_ambient_light;
};

layout (location=1) uniform sampler2DArray textureArray;
layout (location=2) uniform sampler2DArray specularTextureArray;

uniform bool useTextures;

in vec3 vertexPos;
in vec3 vertexNormal;
in vec2 text_coord;
in vec3 vert_diffuse_colour;
in vec3 vert_specular_colour;
in float vert_is_vertex_shiney;
in float vert_diffuse_texture_ID;

out vec4 fragment_colour;



void main(void)
{
	vec3 final_colour = global_ambient_light;
	
	if(useTextures && vert_diffuse_texture_ID <= 27)
	{
		#ifdef GL_EXT_texture_array
			final_colour *= texture2DArray(textureArray, vec3(text_coord, vert_diffuse_texture_ID)).rgb;
		#else
			final_colour *= texture(textureArray, vec3(text_coord, vert_diffuse_texture_ID)).xyz;
		#endif
	}
	else
	{
		final_colour *= vert_diffuse_colour;
	}
	fragment_colour = vec4(final_colour, 1.0);
}
