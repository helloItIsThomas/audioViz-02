#version 410 core
// <primitive-types> (ShadeStyleGLSL.kt)
#define d_vertex_buffer 0
#define d_image 1
#define d_circle 2
#define d_rectangle 3
#define d_font_image_map 4
#define d_expansion 5
#define d_fast_line 6
#define d_mesh_line 7
#define d_point 8
#define d_custom 9
#define d_primitive d_expansion
// </primitive-types>



layout(origin_upper_left) in vec4 gl_FragCoord;
// <drawer-uniforms(true, true)> (ShadeStyleGLSL.kt)
            
layout(shared) uniform ContextBlock {
    uniform mat4 u_modelNormalMatrix;
    uniform mat4 u_modelMatrix;
    uniform mat4 u_viewNormalMatrix;
    uniform mat4 u_viewMatrix;
    uniform mat4 u_projectionMatrix;
    uniform float u_contentScale;
    uniform float u_modelViewScalingFactor;
    uniform vec2 u_viewDimensions;
};
            
layout(shared) uniform StyleBlock {
    uniform vec4 u_fill;
    uniform vec4 u_stroke;
    uniform float u_strokeWeight;
    uniform float[25] u_colorMatrix;
};
// </drawer-uniforms>
in vec2 va_position;
in vec2 va_texCoord0;
in float va_vertexOffset;

// <transform-varying-in> (ShadeStyleGLSL.kt)
in vec3 v_worldNormal;
in vec3 v_viewNormal;
in vec3 v_worldPosition;
in vec3 v_viewPosition;
in vec4 v_clipPosition;
flat in mat4 v_modelNormalMatrix;
// </transform-varying-in>
flat in int v_instance;
uniform float strokeMult;
uniform float strokeThr;
uniform float strokeFillFactor;
uniform sampler2D tex;
uniform vec4 bounds;

in vec3 v_objectPosition;
in vec2 v_ftcoord;
out vec4 o_color;



float strokeMask() {
	return min(1.0, (1.0-abs(v_ftcoord.x*2.0-1.0))*strokeMult) * min(1.0, v_ftcoord.y);
	//return pow(min(1.0, (1.0-abs(v_ftcoord.x*2.0-1.0)*strokeMult)) * min(1.0, v_ftcoord.y), 1.0);
    //return smoothstep(0.0, 1.0, (1.0-abs(v_ftcoord.x*2.0-1.0))*strokeMult) * smoothstep(0.0, 1.0, v_ftcoord.y);
}

    // -- fragmentConstants
    int c_instance = v_instance;
    int c_element = 0;
    vec2 c_screenPosition = gl_FragCoord.xy / u_contentScale;
    float c_contourPosition = va_vertexOffset;
    vec3 c_boundsPosition = vec3(v_objectPosition.xy - bounds.xy, 0.0) / vec3(bounds.zw,1.0);
    vec3 c_boundsSize = vec3(bounds.zw, 0.0);

void main(void) {
	float strokeAlpha = strokeMask();

    vec4 x_stroke = u_stroke;
    vec4 x_fill = u_fill;

    { 
            if (length(c_contourPosition) > 0.9) { // This condition identifies pixels near the stroke
                x_fill = vec4(1.0, 0.0, 0.0, 1.0); // Red color for stroke
            } else {
                vec2 texCoord = va_texCoord0.xy;
                texCoord = vec2(texCoord.y, 1.0 - texCoord.x);
                vec2 size = textureSize(p_image, 0);
                vec2 aspect = vec2(size.x / size.y, 1);
                texCoord = 0.5 + (texCoord - 0.5) / aspect;
                x_fill = texture(p_image, texCoord);
                """
                parameter("image", image)
            }
                 }

    vec4 color = mix(x_stroke, x_fill, strokeFillFactor)  * vec4(1, 1, 1, strokeAlpha);
    vec4 result = color;

    if (strokeAlpha < strokeThr) {
	    discard;
	}

    vec4 final = result;
	final = result;
	final.rgb *= final.a;
    o_color = final;
}
// -------------
// shade-style-custom:expansion-448144159
// created 2023-09-12T21:18:53.667466
/*
ERROR: 0:94: '<' : syntax error: syntax error
*/
