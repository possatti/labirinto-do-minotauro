local function loadmap(path, world)
  local newmap = sti(path, {"bump"})
  newmap:bump_init(world)

  -- Create new dynamic data layer called "Sprites" as the 8th layer
  local spritesLayer = newmap:addCustomLayer("Sprites", 8)
  local playerData
  for k, object in pairs(newmap.objects) do
    if object.name == "Player" then
      playerData = object
      break
    end
  end

  -- Grab the loaded tileset.
  local tileset
  for i,v in ipairs(newmap.tilesets) do
    if v.name == '16x16 Dungeon Tileset' then
      tileset = v
      break
    end
  end

  -- Create player object
  local player = {
    atlas   = tileset.image,
    quad    = love.graphics.newQuad(0, tileSize*4, tileSize, tileSize, 256, 160),
    x       = playerData.x,
    y       = playerData.y,
    ox      = tileSize/2,
    oy      = tileSize,
    width   = tileSize,
    height  = tileSize,
    speed   = playerSpeed,
    bump = {
      offset = {
        x = tileSize/4,
        y = tileSize/4,
      },
      width  = tileSize/2,
      height = tileSize/2,
    },
  }
  spritesLayer.player = player
  world:add(player, player.x - player.bump.offset.x, player.y - player.bump.offset.y, player.bump.width, player.bump.height)

  -- Update player location.
  spritesLayer.update = function(self, dt)
    newpos = {
      x = self.player.x,
      y = self.player.y,
    }
    if love.keyboard.isDown('up', 'w') then
      newpos.y = newpos.y - player.speed * dt
    end
    if love.keyboard.isDown('down', 's') then
      newpos.y = newpos.y + player.speed * dt
    end
    if love.keyboard.isDown('left', 'a') then
      newpos.x = newpos.x - player.speed * dt
    end
    if love.keyboard.isDown('right', 'd') then
      newpos.x = newpos.x + player.speed * dt
    end
    local actualX, actualY, cols, len = world:move(self.player, newpos.x - player.bump.offset.x, newpos.y - player.bump.offset.y)

    self.player.x = actualX + player.bump.offset.x
    self.player.y = actualY + player.bump.offset.y
  end

  -- Draw the player.
  spritesLayer.draw = function(self)
    local p = self.player
    love.graphics.draw(
      self.player.atlas,
      self.player.quad,
      math.floor(self.player.x),
      math.floor(self.player.y),
      0,
      1,
      1,
      self.player.ox,
      self.player.oy
    )
    if enableDebug then
      -- Collision box.
      love.graphics.setColor(0,0,255,125) -- blue
      love.graphics.rectangle('fill', math.floor(p.x - p.bump.offset.x), math.floor(p.y - p.bump.offset.y), p.bump.width, p.bump.height)
      debug(string.format('player: %d, %d', self.player.x, self.player.y))

      -- Point marking player location.
      love.graphics.setColor(255,255,255,255)
      love.graphics.setPointSize(2)
      love.graphics.points(math.floor(self.player.x), math.floor(self.player.y))
    end
  end

  return {map = newmap, player = player}
end

return loadmap
