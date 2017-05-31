require "loadmap"
local bump = require "lib/bump"

print(love.window.width)

WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()

wall_width = 20
wall_height = 20
player_width = 10
player_height = 10
player_speed = 2

GAME_WINDOW_WIDTH = wall_width * 5
GAME_WINDOW_HEIGHT = wall_height * 5 

youwon = false

function love.load()
  -- Load images.
  -- img = love.graphics.newImage('assets/foobar.png')

  -- Load music/sounds.
  -- music = love.audio.newSource("assets/foorocks.ogg")
  -- music:setVolume(0.8)
  -- music:setLooping(true)
  -- music:rewind()
  -- music:play()

  -- Load fonts.
  bigFont = love.graphics.newFont(40)

  -- Set up quads.
  -- quad = love.graphics.newQuad(0, 0, 32, 32, 128, 128)

  -- Set up mouse.
  -- love.mouse.setVisible(true)
  -- love.mouse.setGrabbed(true)

  -- Load map.
  map = loadmap('maps/20x20-slim.txt')

  -- Prepare player.
  r, c = findstart(map)
  player = {x = c*wall_width+player_width/2, y = r*wall_height+player_height/2, speed = player_speed}

  -- Prepare bumping world.
  world = bump.newWorld(64)
  for r,row in ipairs(map) do
    for c,char in ipairs(row) do
      if char == 'W' then
        world:add({name='wall'}, c*wall_width, r*wall_height, wall_width, wall_height)
      end
      if char == 'E' then
        world:add({name='end'}, c*wall_width, r*wall_height, wall_width, wall_height)
      end
    end
  end
  playerObj = {name='player'}
  world:add(playerObj, player.x, player.y, player_width, player_height)

end

function love.update(dt)
  -- Quit game.
  if love.keyboard.isDown('escape', 'q') then
    love.event.push('quit')
  end

  -- Player movement.
  newpos = {x=player.x, y=player.y}
  if love.keyboard.isDown('up', 'w') then
    newpos.y = newpos.y - player.speed
  end
  if love.keyboard.isDown('down', 's') then
    newpos.y = newpos.y + player.speed
  end
  if love.keyboard.isDown('left', 'a') then
    newpos.x = newpos.x - player.speed
  end
  if love.keyboard.isDown('right', 'd') then
    newpos.x = newpos.x + player.speed
  end

  -- Process colissions.
  local actualX, actualY, cols, len = world:move(playerObj, newpos.x, newpos.y)
  player.x = actualX
  player.y = actualY

  -- Check whether we touched the finishing line.
  for i,col in ipairs(cols) do
    if col.other.name == 'end' then
      youwon = true
    end
  end
end

function love.draw()
  -- Zoom in on the player.
  love.graphics.push()
  love.graphics.scale(WINDOW_WIDTH/GAME_WINDOW_WIDTH, WINDOW_HEIGHT/GAME_WINDOW_HEIGHT) -- zoom the camera
  love.graphics.translate(-player.x - player_width/2 + GAME_WINDOW_WIDTH/2, -player.y - player_height/2 + GAME_WINDOW_HEIGHT/2) -- move the camera position
  
  -- Backgroud is gray.
  love.graphics.setBackgroundColor(190, 190, 190, 255)

  -- Draw the map.
  for r,row in ipairs(map) do
    for c,char in ipairs(row) do
      if char == 'W' then
        love.graphics.setColor(0, 145, 255, 255)
        love.graphics.rectangle('fill', c*wall_width, r*wall_height, wall_width, wall_height)
      end
      if char == 'E' then
        love.graphics.setColor(0, 255, 0, 255)
        love.graphics.rectangle('fill', c*wall_width, r*wall_height, wall_width, wall_height)
      end
    end
  end

  -- Draw the player
  love.graphics.setColor(0, 0, 255, 255)
  -- love.graphics.rectangle('fill', player.x, player.y, player_width, player_height)
  love.graphics.circle('fill', player.x+player_width/2, player.y+player_height/2, 5)
  
  -- Zoom out back again.
  love.graphics.pop()

  -- Show a winning message.
  if youwon then
    love.graphics.setFont(bigFont)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("You won!", love.graphics.getWidth()/2-80, love.graphics.getHeight()/2-50)
  end
end
