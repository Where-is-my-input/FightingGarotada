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

uniform vec4 chromaKey0: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey1: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey2: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey3: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey4: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey5: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey6: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey7: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey8: source_color = vec4(252.0,2.0,252.0,255.0);
uniform vec4 chromaKey9: source_color = vec4(252.0,2.0,252.0,255.0);

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
	vec4 chromaArray[10] = vec4[10](chromaKey0,chromaKey1,chromaKey2,chromaKey3,chromaKey4,chromaKey5,chromaKey6,chromaKey7,chromaKey8,chromaKey9);
	for(int i = 0; i < 10; i++){
		if (distance(color_a, chromaArray[i]) <= precision){
			color_a.a = 0.0;
			break;
		}
	}
	//if (color_a.r > 248.0 && color_a.g < 5.0 && color_a.b > 248.00) { //Opacity
        //color_a.a = 0.0;
    //}
	COLOR = swap_color(color_a);
}
