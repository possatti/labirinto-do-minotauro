-- Filter to be used in world:move().
local function bumpfilter(item, other)
  -- Let the player cross the Upstairs/Downstairs areas.
  if other.name == 'Upstairs' or other.name == 'Downstairs' then
    return 'cross'
  else
    return 'slide'
  end
end

--- Loads a map from Tiled using STI.
-- @param gameInstance An instance to the gameState (game.lua). This is here againts my very will.
--                     But I can't see any better way to change the level right now.
local function loadmap(path, world, gameInstance)
  -- Check that the map file exists.
  if not love.filesystem.exists(path) then
    error(string.format("The map file '%s' doesn't exist.", path))
  end

  -- Start the new map.
  local newmap = sti(path, {"bump"})
  newmap:bump_init(world)

  -- Create new dynamic data layer.
  local dynamicLayer = newmap:addCustomLayer("Dynamic Layer")
  local playerObject
  for k, object in pairs(newmap.objects) do
    if object.name == "Player" then
      playerObject = object
    elseif object.name == "Upstairs" then
      upstairsObject = object
    elseif object.name == "Downstairs" then
      downstairsObject = object
    end
  end

  -- Create player object
  local player = {
    x         = playerObject.x,
    y         = playerObject.y,
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
  dynamicLayer.player = player
  dynamicLayer.upstairs = upstairsObject
  dynamicLayer.downstairs = downstairsObject
  world:add(player, player.x - player.bump.offset.x, player.y - player.bump.offset.y, player.bump.width, player.bump.height)
  if upstairsObject then
    world:add(upstairsObject, upstairsObject.x, upstairsObject.y, upstairsObject.width, upstairsObject.height)
  end
  if downstairsObject then
    world:add(downstairsObject, downstairsObject.x, downstairsObject.y, downstairsObject.width, downstairsObject.height)
  end

  -- Update player location.
  dynamicLayer.update = function(self, dt)
    local newpos = controlling.read(dt, player)
    local actualX, actualY, cols, len = world:move(self.player, newpos.x - player.bump.offset.x, newpos.y - player.bump.offset.y, bumpfilter)

    self.player.x = actualX + player.bump.offset.x
    self.player.y = actualY + player.bump.offset.y
    self.player.direction = newpos.direction
    self.player.hasMoved  = newpos.hasMoved

    for i, col in ipairs(cols) do
      if col.other.name == 'Upstairs' then
        gameInstance.currentLevel = gameInstance.currentLevel + 1
        gameInstance:loadlevel(gameInstance.currentLevel)
        debug('Move upstairs.')
      elseif col.other.name == 'Downstairs' then
        gameInstance.currentLevel = gameInstance.currentLevel - 1
        gameInstance:loadlevel(gameInstance.currentLevel)
        debug('Move downstairs.')
      end
    end
  end

  -- Draw the player.
  dynamicLayer.draw = function(self)
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
      local dY = p.y + math.sin(p.direction) * tileSize
      local dX = p.x + math.cos(p.direction) * tileSize
      love.graphics.points(math.floor(dX), math.floor(dY))
      love.graphics.setColor(255,255,255,255)
    end
  end

  return {map = newmap, player = player}
end

return loadmap
