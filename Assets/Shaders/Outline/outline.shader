shader_type canvas_item;
render_mode unshaded;

uniform vec4 outline_color : hint_color;
uniform bool _outline : hint_bool = true;

//$sprite.material.set_shader_param("_outline", true)

void fragment() {
	COLOR = texture(TEXTURE, UV);
	vec4 screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	//_outline = true;
	//check if pixel is drawn?
	//if(COLOR.rgb != screen.rgb) {
		//_outline = false;
		//COLOR = outline_color
		//}
	
	vec4 left = texture(TEXTURE, UV + (vec2(-1.0, 0.0) * TEXTURE_PIXEL_SIZE));
	vec4 right = texture(TEXTURE, UV + (vec2(1.0, 0.0) * TEXTURE_PIXEL_SIZE));
	vec4 up = texture(TEXTURE, UV + (vec2(0.0, -1.0) * TEXTURE_PIXEL_SIZE));
	vec4 down = texture(TEXTURE, UV + (vec2(0.0, 1.0) * TEXTURE_PIXEL_SIZE));
	
	//checks if pixel is transparent and neighbors are not, gives outline
	if(_outline && COLOR.a == 0.0 && (left.a !=0.0 || right.a != 0.0 || up.a != 0.0 || down.a != 0.0 )) {
		COLOR = outline_color
	}
}