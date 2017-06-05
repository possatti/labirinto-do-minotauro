local direction = 0
local playerMoved

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
    -- if love.mouse.isDown(1) then
    --   local mouse = {}
    --   mouse.x, mouse.y = love.mouse.getPosition()
    --   local dirCenter = onscreen.directional.center
    --   direction = math.atan2(mouse.y - dirCenter.y, mouse.x - dirCenter.x)
    --   newpos.y = player.y + math.sin(direction) * player.speed * dt
    --   newpos.x = player.x + math.cos(direction) * player.speed * dt
    -- else
    --   playerMoved = not (newpos.x == player.x and newpos.y == player.y)
    --   if playerMoved then
    --     direction = math.atan2(newpos.y - player.y, newpos.x - player.x)
    --   end
    -- end
    dirPress = onscreen:update(dt)
    if dirPress then
      direction = dirPress.direction
      newpos.y = player.y + math.sin(direction) * player.speed * dt
      newpos.x = player.x + math.cos(direction) * player.speed * dt
      playerMoved = true
    else
      -- If player moved without touching the screen, we find the derection he is facing.
      if not (newpos.x == player.x and newpos.y == player.y) then
        direction = math.atan2(newpos.y - player.y, newpos.x - player.x)
        playerMoved = true
      else
        playerMoved = false
      end
    end

    return {
      x = newpos.x,
      y = newpos.y,
      direction = direction,
      hasMoved = playerMoved
    }
  end
}

return controlling
