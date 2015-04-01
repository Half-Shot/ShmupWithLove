sShadowMap = love.graphics.newShader[[
extern vec4 ambientLight;
extern vec4 lights[8];
extern vec2 light_pos[8];
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  color *= ambientLight;
  for(int i = 0; i <= 7; i++) {
    vec4 light = lights[i];
    number distance = distance(light_pos[i],texture_coords);
    if (distance <= light.a){
      light.a -= distance;
    }
    else{
      continue;
    }
    light.r *= light.a;
    light.g *= light.a;
    light.b *= light.a;
    
    color += light;
  }
  return pixel * color ;
}
]]
