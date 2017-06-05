-- Third party.
sti = require "lib/sti"
bump = require "lib/bump"
inspect = require "lib/inspect"
anim8 = require "lib/anim8"

-- My modules.
controlling = require "controlling"
loadmap = require "loadmap"
onscreen = require "onscreen"

-- Constants.
tileSize = 16
playerSpeed = 100
visibleNumberOfBlocksAroundPlayer = 6

-- Debug stuff.
enableDebug = false
debugInfo = {'DEBUG'}
function debug(mystr)
  if mystr then
    table.insert(debugInfo, mystr)
  end
end

-- Game states
titlescreenState = require "gamestates/titlescreen"
gameState = require "gamestates/game"
gamestate = titlescreenState

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
  -- Load hero image and quads.
  heroSprite = love.graphics.newImage('assets/hero-sprite.png')
  heroRightQuad = love.graphics.newQuad(0, tileSize*0, tileSize, tileSize, tileSize*3, tileSize*4)
  heroDownQuad  = love.graphics.newQuad(0, tileSize*1, tileSize, tileSize, tileSize*3, tileSize*4)
  heroLeftQuad  = love.graphics.newQuad(0, tileSize*2, tileSize, tileSize, tileSize*3, tileSize*4)
  heroUpQuad    = love.graphics.newQuad(0, tileSize*3, tileSize, tileSize, tileSize*3, tileSize*4)
  local g = anim8.newGrid(tileSize, tileSize, heroSprite:getWidth(), heroSprite:getHeight())
  heroRightAnim = anim8.newAnimation(g('1-3',1), 0.1)
  heroDownAnim  = anim8.newAnimation(g('1-3',2), 0.1)
  heroLeftAnim  = anim8.newAnimation(g('1-3',3), 0.1)
  heroUpAnim    = anim8.newAnimation(g('1-3',4), 0.1)

  -- Load map file
  world = bump.newWorld()
  local loadedData = loadmap('maps/20x20.lua', world)
  map = loadedData.map
  player = loadedData.player

  -- Load on-screen controls.
  onscreen:load()

  -- Load fonts.
  debugFont = love.graphics.newFont(12)
  -- pixelFont = love.graphics.newFont('assets/fonts/04b03Regular.ttf')

  -- Load gamestates.
  titlescreenState:load()
  gameState:load()
end

function love.keyreleased(key, code)
  if gamestate.keyreleased then
    gamestate:keyreleased(key, code)
  end
end

function love.mousepressed(x, y, button, isTouch)
  if gamestate.mousepressed then
    gamestate:mousepressed(x, y, button, isTouch)
  end
end

function love.update(dt)
  -- Quit game.
  if love.keyboard.isDown('escape', 'q') then
    love.event.push('quit')
  end

  if gamestate.update then
    gamestate:update(dt)
  end
end

function love.draw()
  gamestate:draw()

  -- Print debug info.
  if enableDebug then
    love.graphics.setFont(debugFont)
    love.graphics.setColor(255,255,255,255)
    debug(string.format('FPS: %d', love.timer.getFPS()))
    debug(string.format('Window: %.2f, %.2f', getGameWindowWidth(), getGameWindowHeight()))
    for i,v in ipairs(debugInfo) do
      love.graphics.print(v, 0, (i-1)*14)
    end
    debugInfo = {'DEBUG'}
  end
end
