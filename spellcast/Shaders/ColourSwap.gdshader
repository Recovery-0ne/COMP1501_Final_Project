shader_type canvas_item;
uniform vec4[10] target_colors : source_color;
uniform vec4[10] replace_colors : source_color;
uniform float tolerance : hint_range(0, 1); 
 
void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
 
	for (int i = 0; i < target_colors.length(); i++)
	    if (distance(tex_color.rgb, target_colors[i].rgb) < tolerance) {
	        tex_color.rgb = replace_colors[i].rgb;
	    }
 
    COLOR = tex_color;
}
