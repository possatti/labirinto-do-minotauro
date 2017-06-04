local direction = 0

local controlling = {
  read = function(dt)
    local newpos = {
      x = player.x,
      y = player.y,
    }

    -- Read keyboard.
    if love.keyboard.isDown('up', 'w') then
      newpos.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown('down', 's') then
      newpos.y = player.y + player.speed * dt
    end
    if love.keyboard.isDown('left', 'a') then
      newpos.x = player.x - player.speed * dt
    end
    if love.keyboard.isDown('right', 'd') then
      newpos.x = player.x + player.speed * dt
    end

    -- Mouse events
    if love.mouse.isDown(1) then
      local mouse = {}
      mouse.x, mouse.y = love.mouse.getPosition()
      local dirCenter = onscreen.directional.center
      direction = math.atan2(mouse.y - dirCenter.y, mouse.x - dirCenter.x)
      newpos.y = player.y + math.sin(direction) * player.speed * dt
      newpos.x = player.x + math.cos(direction) * player.speed * dt
    else
      positionChanged = not (newpos.x == player.x and newpos.y == player.y)
      if positionChanged then
        direction = math.atan2(newpos.y - player.y, newpos.x - player.x)
      end
    end

    return {
      x = newpos.x,
      y = newpos.y,
      direction = direction,
    }
  end
}

return controlling
