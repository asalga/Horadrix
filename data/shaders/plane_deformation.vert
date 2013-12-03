uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec2 texCoord;

varying vec4 vertTexCoord;

void main(){
	vertTexCoord = texMatrix * texCoord;
	gl_Position = transform * vertex;
}