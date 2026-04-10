shader_type canvas_item;

void fragment() {
  vec4 original_color = texture(TEXTURE, UV);
  
  float gray = original_color.r * 0.299 + original_color.g * 0.587 + original_color.b * 0.114;
  COLOR.rgb = vec3(gray, gray, gray);
  COLOR.a = original_color.a;
}