sti = require "lib/sti"
bump = require "lib/bump"
inspect = require "lib/inspect"
local loadmap = require "loadmap"

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
  local loadedData = loadmap('maps/20x20.lua', world)
  map = loadedData.map
  player = loadedData.player
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
