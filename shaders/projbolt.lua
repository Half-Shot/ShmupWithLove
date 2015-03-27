sProjBolt = love.graphics.newShader[[
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  //color = color * 2;
  number width = 500;
  number startx = 700;
  number xfac = texture_coords.x * 8;
  if(xfac > 1){
    xfac = 1 - (xfac - 1);
  }
  
  number yfac = texture_coords.y * 2;
  if(yfac > 1){
    yfac = 1 - (yfac - 1);
  }
  
  color.a = xfac * yfac;
  
  return color;
}
]]
