shader_type canvas_item;
const float precision = 0.1;
//uniform vec4 chroma_key: source_color = vec4(248.0,0.0,248.0,255.0);
//uniform vec4 chroma_key_replace: source_color = vec4(0.0,0.0,0.0,0.0);
//uniform float tolerance: hint_range(0.0,1.0) = 0.5;
uniform sampler2D palette;
uniform vec4 color1: source_color = vec4(68.0,88.0,219.0,255.0);
uniform vec4 color2: source_color = vec4(69.0,118.0,255.0,255.0);
uniform vec4 color3: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color4: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color5: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color6: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color7: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color8: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color9: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color10: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color11: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color12: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color13: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color14: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color15: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color16: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color17: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color18: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color19: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color20: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color21: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color22: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color23: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color24: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 color25: source_color = vec4(248.0,0.0,248.0,255.0);
//New palette
uniform vec4 newColor1: source_color = vec4(68.0,88.0,219.0,255.0);
uniform vec4 newColor2: source_color = vec4(69.0,118.0,255.0,255.0);
uniform vec4 newColor3: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor4: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor5: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor6: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor7: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor8: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor9: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor10: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor11: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor12: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor13: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor14: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor15: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor16: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor17: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor18: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor19: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor20: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor21: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor22: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor23: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor24: source_color = vec4(248.0,0.0,248.0,255.0);
uniform vec4 newColor25: source_color = vec4(248.0,0.0,248.0,255.0);

vec4 swap_color(vec4 color){
	vec4 original_colors[25] = vec4[25] (color1, color2, color3, color4, color5, color6, color7, color8, color9, color10, color11, color12, color13, color14, color15, color16, color17, color18, color19, color20, color21, color22, color23, color24, color25);
	vec4 replace_colors[25] = vec4[25] (newColor1, newColor2, newColor3, newColor4, newColor5, newColor6, newColor7, newColor8, newColor9, newColor10, newColor11, newColor12, newColor13, newColor14, newColor15, newColor16, newColor17, newColor18, newColor19, newColor20, newColor21, newColor22, newColor23, newColor24, newColor25);
	for (int i = 0; i < 25; i ++) {
		if (distance(color, original_colors[i]) <= precision){
			return replace_colors[i];
		}
	}
	return color;
}

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
	if (color_a.r < 248.0 && color_a.g == 0.0 && color_a.b < 248.00) { //Opacity
        color_a.a = 0.0;
    }
	//color_a = vec4(color_a.r, color_a.g, 0, color_a.a);
	//if (color_a.r == color1.r && color_a.g == color1.g && color_a.b == color1.b) {
        //color_a = vec4(newColor1.r, newColor1.g, newColor1.b, color_a.a);
    //}else if (color_a.r == color2.r && color_a.g == color2.g && color_a.b == color2.b) {
        //color_a = vec4(newColor2.r, newColor2.g, newColor2.b, color_a.a);
    //}else if (color_a.r == color3.r && color_a.g == color3.g && color_a.b == color3.b) {
        //color_a = vec4(newColor3.r, newColor3.g, newColor3.b, color_a.a);
    //}
	//vec4 rgba = texture(TEXTURE, UV);
	//vec4 finalColor = texture(palette, vec2(color_a.r, color_a.g));
	//finalColor.a = color_a.a;
	
	//COLOR = finalColor;
	COLOR = swap_color(color_a);
}
