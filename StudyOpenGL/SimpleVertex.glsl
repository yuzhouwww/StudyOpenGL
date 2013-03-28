attribute vec4 Position;
attribute vec4 SourceColor;
attribute vec3 Normal;

varying vec4 DestinationColor;

uniform mat4 Projection;
uniform mat4 Modelview;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void) {
    DestinationColor = SourceColor;
    gl_Position = Projection * Modelview * Position;
    TexCoordOut = TexCoordIn;
    
    vec3 N = Normal;
    vec4 V = Modelview * Position;
    vec3 L = normalize(vec3(5.0,5.0,-5.0) - V.xyz);
    vec3 H = normalize(L + vec3(0,0,1));
    const float specularExp = 128.0;

    float NdotL = max(0.0,dot(N,L));
    vec4 diffuse = SourceColor * vec4(NdotL);

    float NdotH = max(0.0,dot(N,H));
    vec4 specular = vec4(0.0);
    if(NdotL > 0.0)
        specular = vec4(pow(NdotH,specularExp));
        
    vec4 ambient = vec4(0.6,0.6,0.6,1.0);

    DestinationColor = diffuse + specular + ambient;
}
