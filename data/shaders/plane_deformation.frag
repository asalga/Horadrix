#if GL_ES
precision mediump float;
#endif

#define TAU 3.14159265894 * 2.0

varying float time;
uniform sampler2D iChannel0;

void main(){
	// p will range from -1 to 1
	vec2 p = 1.0 - 2.0 * gl_FragCoord.xy / vec2(400.0,400.0);
	p.x *= 1.0;//iResolution.x / iResolution.y;
	
	//vec2 cursor = 1.0 - 2.0 * iMouse.xy/iResolution.xy;
	//p += cursor;
	
	float pLength = length(p);
	
	// Use polar coordinate to sample the texture
	vec2 texel = vec2( 1.0/pLength + time * 0.3, atan(p.y/p.x)/TAU);
	
    vec4 fogCol = vec4(vec3(0.75) * pLength/2.0, 1.0);

	gl_FragColor = texture2D(iChannel0, texel) * fogCol;
}