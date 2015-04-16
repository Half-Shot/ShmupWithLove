sWater = love.graphics.newShader[[
extern number scrollx;
extern number scrolly;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  texture_coords.y= texture_coords.y - scrolly;
  if (texture_coords.y < 0){
    texture_coords.y = texture_coords.y + 1;
  }
  
  texture_coords.x = texture_coords.x - scrollx;
  if (texture_coords.x < 0){
    texture_coords.x = texture_coords.x + 1;
  }
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  pixel.a = ((pixel.r + pixel.g + pixel.b) / 3) - 0.20;
  return pixel*color;
}
]]
