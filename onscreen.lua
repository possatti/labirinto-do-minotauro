-- Directional that will be drawn on screen.

return {
  load = function(self)

    -- Load images.
    local directionalImage = love.graphics.newImage('assets/onscreen-controls/shadedLight/shadedLight01.png')
    local pauseImage = love.graphics.newImage('assets/onscreen-controls/shadedLight/shadedLight14.png')

    -- Calculate the scale of buttons.
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local scale = 1
    local desiredDirectionalWidth = screenWidth / 10
    scale = desiredDirectionalWidth / directionalImage:getWidth()

    self.pause = {}
    self.pause['image'] = pauseImage
    self.pause['x'] = 18 * screenWidth / 20
    self.pause['y'] = 1 * screenHeight / 20
    self.pause['width'] = pauseImage:getWidth() * scale
    self.pause['height'] = pauseImage:getHeight() * scale
    self.pause['clickbox'] = {
      x = self.pause['x'],
      y = self.pause['y'],
      width = self.pause['width'],
      height = self.pause['height'],
      right = self.pause['x'] + self.pause['width'],
      bottom = self.pause['y'] + self.pause['height'],
    }
    self.pause['scale'] = scale

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
    self.directional['clickradius'] = self.directional['width'] * 1.5
    self.directional['scale'] = scale
  end,

  mousepressed = function(self, mx, my, button, isTouch)
    local pcb = self.pause.clickbox
    if pcb.x < mx and mx < pcb.right and
      pcb.y < my and my < pcb.bottom then
      return 'pause'
    end
  end,

  update = function(self, dt)
    if love.mouse.isDown(1) then
      local dCenter = self.directional.center
      local radius = self.directional.clickradius
      mx, my = love.mouse.getPosition()
      dx = math.abs(mx - dCenter.x)
      dy = math.abs(my - dCenter.y)

      distance = math.sqrt((mx - dCenter.x)^2 + (my - dCenter.y)^2)
      if distance < radius then
        direction = math.atan2(my - dCenter.y, mx - dCenter.x)
        debug(string.format('Analog click: dist: %.2f; direc: %.2f', distance, direction))
        return {
          distance = distance,
          direction = direction,
        }
      end

      -- local dY = player.y + math.sin(p.direction) * tileSize
      -- local dX = player.x + math.cos(p.direction) * tileSize
    end
  end,

  draw = function(self)
    local d = self.directional
    love.graphics.setColor(255,255,255,125)
    love.graphics.draw(d.image, d.x, d.y, 0, d.scale)
    love.graphics.setColor(255,255,255,255)

    local p = self.pause
    love.graphics.setColor(255,255,255,125)
    love.graphics.draw(p.image, p.x, p.y, 0, p.scale)
    love.graphics.setColor(255,255,255,255)

    if enableDebug then
      -- Draw directional's click radius.
      love.graphics.setColor(255,255,0,125)
      love.graphics.circle('fill', d.center.x, d.center.y, d.clickradius)

      -- Draw center of the directional.
      love.graphics.setColor(0,0,0,255)
      love.graphics.setPointSize(15)
      love.graphics.points(d.center.x, d.center.y)

      -- Draw the pause clickbox.
      love.graphics.setColor(255,255,0,125)
      love.graphics.rectangle('fill', p.clickbox.x, p.clickbox.y, p.clickbox.width, p.clickbox.height)
      love.graphics.setColor(255,255,255,255)
    end
  end
}
