sHitEffect = love.graphics.newShader[[
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  pixel.r += 0.35;
  pixel.g += 0.25;
  pixel.b += 0.25;
  return pixel * color;
}
]]
