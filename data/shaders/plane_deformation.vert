//#if GL_ES
//precision mediump float;
//#endif

uniform mat4 transform;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec2 texCoord;

varying vec4 vertTexCoord;

void main(){
	vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
	gl_Position = transform * vertex;
}