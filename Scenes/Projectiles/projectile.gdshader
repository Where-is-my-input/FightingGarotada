shader_type canvas_item;

//uniform vec4 chroma_key: source_color = vec4(248.0,0.0,248.0,255.0);
//uniform vec4 chroma_key_replace: source_color = vec4(0.0,0.0,0.0,0.0);
//uniform float tolerance: hint_range(0.0,1.0) = 0.5;
uniform sampler2D palette;

void fragment(){
	vec4 color_a = texture(TEXTURE, UV);
	//color_a.b = 0.0;
	//vec3 color = color_a.rgb;
	//float a = color_a.a;
	//float chroma_key_len = length(chroma_key.rgb);
	//float c_len = length(color);

	//vec3 chroma_key_norm = chroma_key.rgb / chroma_key_len * c_len;
	//vec3 chroma_replace_norm = chroma_key_replace.rgb / chroma_key_len * c_len;

	//float chroma_dist = distance(color, chroma_key_norm) * 5.0 ;
	//color = mix(chroma_replace_norm, color, step(tolerance,chroma_dist));
	if (color_a.r < 255.0 && color_a.g == 0.0 && color_a.b < 255.00) { //Opacity
        color_a.a = 0.0;
    }
	//vec4 rgba = texture(TEXTURE, UV);
	//vec4 finalColor = texture(palette, vec2(rgba.r, rgba.g));
	//finalColor.a = color_a.a;

	COLOR = color_a;
	//COLOR = color_a;
}