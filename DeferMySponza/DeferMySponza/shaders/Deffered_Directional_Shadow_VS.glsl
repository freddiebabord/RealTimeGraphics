#version 440

layout(location = 0)in vec3 vertex_position;
layout(location = 1)in vec3 vertex_normal;
layout(location = 2)in vec2 vertex_texcoord;
layout(location = 3)in int vertex_diffuse_texture_ID;
layout(location = 4)in mat4 model_matrix;

uniform mat4 lightSpaceMatrix;

void main(void)
{
	gl_Position = lightSpaceMatrix * model_matrix * vec4(vertex_position, 1.0f);
}