shader_type canvas_item;

uniform sampler2D palette;

void fragment() {
	//Palette shade
	vec4 rgba = texture(TEXTURE, UV);
	vec4 finalColor = texture(palette, vec2(rgba.r, rgba.g));
	finalColor.a = rgba.a;
	
	COLOR = finalColor;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
