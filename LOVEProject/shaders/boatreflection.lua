sReflectionLayer = love.graphics.newShader[[
extern number distort;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  //texture_coords.y -= dist;
  
  vec4 p = Texel(texture, texture_coords );
  
  texture_coords.x -= distort;
  number pX = 1/screen_coords.x;
  number pY = 1/screen_coords.y;
  vec2 top = texture_coords;
  top.y -= pY;
  vec2 left = texture_coords;
  top.x -= pX;
  vec2 right = texture_coords;
  top.x += pX;
  vec2 down = texture_coords;
  top.y += pY;
  
  vec4 pTop = Texel(texture, top );//This is the current pixel color
  vec4 pLeft = Texel(texture, left );//This is the current pixel color
  vec4 pRight = Texel(texture, right );//This is the current pixel color
  vec4 pDown = Texel(texture, down );//This is the current pixel color
  
  vec4 pixel = vec4((pTop.r+pLeft.r+pRight.r+pDown.r)/4,(pTop.g+pLeft.g+pRight.g+pDown.g)/4,(pTop.b+pLeft.b+pRight.b+pDown.b)/4,1);
  pixel.a -= 0.15;
  return pixel;
}
]]
