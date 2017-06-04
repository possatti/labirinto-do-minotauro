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
    x         = playerData.x,
    y         = playerData.y,
    ox        = tileSize/2,
    oy        = tileSize,
    width     = tileSize,
    height    = tileSize,
    speed     = playerSpeed,
    direction = 0,
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
    local newpos = controlling.read(dt)
    local actualX, actualY, cols, len = world:move(self.player, newpos.x - player.bump.offset.x, newpos.y - player.bump.offset.y)

    self.player.x = actualX + player.bump.offset.x
    self.player.y = actualY + player.bump.offset.y
    self.player.direction = newpos.direction
    self.player.hasMoved  = newpos.hasMoved
  end

  -- Draw the player.
  spritesLayer.draw = function(self)
    local p = self.player

    -- Find which quad should be used to draw the player.
    local playerQuad = heroRightQuad
    local playerAnim = heroRightAnim
    if p.direction > math.pi/4 and p.direction <= 3*math.pi/4 then
      playerQuad = heroDownQuad
      playerAnim = heroDownAnim
    elseif p.direction < -math.pi/4 and p.direction >= -3*math.pi/4 then
      playerQuad = heroUpQuad
      playerAnim = heroUpAnim
    elseif p.direction > 3*math.pi/4 or p.direction < -3*math.pi/4 then
      playerQuad = heroLeftQuad
      playerAnim = heroLeftAnim
    end

    -- Draw player.
    if p.hasMoved then
      -- Draw player's walking animation.
      playerAnim:draw(heroSprite, math.floor(p.x) - p.ox, math.floor(p.y) - p.oy)
    else
      -- Draw static player.
      love.graphics.draw(
        heroSprite,
        playerQuad,
        math.floor(p.x),
        math.floor(p.y),
        0, -- rotation
        1, -- scale x
        1, -- scale y
        p.ox,
        p.oy
      )
    end

    if enableDebug then
      -- Collision box.
      love.graphics.setColor(0,0,255,125) -- blue
      love.graphics.rectangle('fill', math.floor(p.x - p.bump.offset.x), math.floor(p.y - p.bump.offset.y), p.bump.width, p.bump.height)
      debug(string.format('player: %d, %d, %.4f', p.x, p.y, p.direction))

      -- Point marking player location.
      love.graphics.setColor(255,255,255,255)
      love.graphics.setPointSize(2)
      love.graphics.points(math.floor(p.x), math.floor(p.y))

      -- Point marking player direction.
      love.graphics.setColor(255,0,0,255)
      local dY = player.y + math.sin(p.direction) * tileSize
      local dX = player.x + math.cos(p.direction) * tileSize
      love.graphics.points(math.floor(dX), math.floor(dY))
      love.graphics.setColor(255,255,255,255)
    end
  end

  return {map = newmap, player = player}
end

return loadmap
