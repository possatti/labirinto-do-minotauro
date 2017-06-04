-- Directional that will be drawn on screen.

return {
  load = function(self)
    local directionalImage = love.graphics.newImage('assets/onscreen-controls/shadedLight/shadedLight01.png')
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local scale = 1
    local desiredDirectionalWidth = screenWidth / 10
    scale = desiredDirectionalWidth / directionalImage:getWidth()

    self.directional = {}
    self.directional['image'] = directionalImage
    self.directional['width'] = directionalImage:getWidth() * scale
    self.directional['height'] = directionalImage:getHeight() * scale
    self.directional['x'] = (screenWidth/20)*3
    self.directional['y'] = screenHeight - (screenHeight/20)*4 - self.directional.width
    self.directional['center'] = {
      x = self.directional.x + self.directional.width/2,
      y = self.directional.y + self.directional.height/2,
    }
    self.directional['scale'] = scale
  end,
  draw = function(self)
    local d = self.directional
    love.graphics.setColor(255,255,255,125)
    love.graphics.draw(d.image, d.x, d.y, 0, d.scale)
    love.graphics.setColor(255,255,255,255)

    -- Draw center of the directional.
    if enableDebug then
      love.graphics.setColor(0,0,0,255)
      love.graphics.setPointSize(15)
      love.graphics.points(d.center.x, d.center.y)
      love.graphics.setColor(255,255,255,255)
    end
  end
}
