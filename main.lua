local sti = require "lib/sti"
local bump = require "lib/bump"
local inspect = require "lib/inspect"

-- Constants.
tileSize = 16
playerSpeed = 100
visibleNumberOfBlocksAroundPlayer = 6

-- Debug stuff.
enableDebug = true
debugInfo = {'DEBUG'}
function debug(mystr)
  table.insert(debugInfo, mystr)
end

-- Zoom stuff.
function getGameWindowWidth()
  return math.floor(tileSize * visibleNumberOfBlocksAroundPlayer * (love.graphics.getWidth()/love.graphics.getHeight()))
end
function getGameWindowHeight()
  return math.floor(tileSize * visibleNumberOfBlocksAroundPlayer)
end
function getXScale()
  return love.graphics.getWidth() / getGameWindowWidth()
end


function love.load()
  -- Load map file
  world = bump.newWorld()
  map = sti("maps/20x20.lua", {"bump"})
  map:bump_init(world)
  -- print(inspect(map)) -- #!#

  -- Create new dynamic data layer called "Sprites" as the 8th layer
  local spritesLayer = map:addCustomLayer("Sprites", 8)
  local playerData
  for k, object in pairs(map.objects) do
    if object.name == "Player" then
      playerData = object
      break
    end
  end

  -- Grab the loaded tileset.
  local tileset
  for i,v in ipairs(map.tilesets) do
    if v.name == '16x16 Dungeon Tileset' then
      tileset = v
      break
    end
  end

  -- Create player object
  player = {
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
end

function love.update(dt)
  -- Quit game.
  if love.keyboard.isDown('escape', 'q') then
    love.event.push('quit')
  end

  -- Update world
  map:update(dt)
end

function love.draw()
  -- Zoom scale and translation factors.
  local sx = getXScale()
  local tx = -player.x + getGameWindowWidth()/2
  local ty = -player.y + getGameWindowHeight()/2
  tx = math.floor(tx)
  ty = math.floor(ty)

  -- Draw world.
  map:draw(tx, ty, sx, sx)

  -- Draw collision boxes.
  if enableDebug then
    love.graphics.push()
    love.graphics.scale(sx)
    love.graphics.translate(tx, ty)
    -- map:bump_draw(world,0,0,1,1)
    love.graphics.pop()
  end

  -- Print debug info.
  if enableDebug then
    debug(string.format('FPS: %d', love.timer.getFPS()))
    debug(string.format('Window: %.2f, %.2f', getGameWindowWidth(), getGameWindowHeight()))
    for i,v in ipairs(debugInfo) do
      love.graphics.print(v, 0, (i-1)*14)
    end
    debugInfo = {'DEBUG'}
  end
end
