require "loadmap"
local bump = require "lib/bump"

-- WINDOW_WIDTH = love.graphics.getWidth()
-- WINDOW_HEIGHT = love.graphics.getHeight()

tileWidth = 32
tileHeight = 32

wallWidth = 32
wallHeight = 32
playerWidth = 24
playerHeight = 24
playerSpeed = 100

GAME_WINDOW_WIDTH = tileWidth * 5
GAME_WINDOW_HEIGHT = tileHeight * 5

youwon = false

function love.load()
  -- Load images.
  love.graphics.setDefaultFilter('nearest', 'nearest')
  atlas = love.graphics.newImage('assets/atlas.png')

  -- Load music/sounds.
  -- music = love.audio.newSource("assets/foorocks.ogg")
  -- music:setVolume(0.8)
  -- music:setLooping(true)
  -- music:rewind()
  -- music:play()

  -- Load fonts.
  bigFont = love.graphics.newFont(40)

  -- Set up quads.
  wallQuad = love.graphics.newQuad(0, 0, 32, 64, 320, 320)
  topWallQuad = love.graphics.newQuad(0, 64, 32, 64, 320, 320)
  grassQuad = love.graphics.newQuad(32, 0, 32, 32, 320, 320)
  trophieQuad = love.graphics.newQuad(32, 32, 32, 32, 320, 320)
  playerDownQuad =  love.graphics.newQuad(64, 0, 32, 64, 320, 320)
  playerRightQuad = love.graphics.newQuad(96, 0, 32, 64, 320, 320)
  playerUpQuad =    love.graphics.newQuad(128, 0, 32, 64, 320, 320)
  playerLeftQuad =  love.graphics.newQuad(160, 0, 32, 64, 320, 320)
  currentPlayerQuad = playerUpQuad

  -- Set up mouse.
  -- love.mouse.setVisible(true)
  -- love.mouse.setGrabbed(true)

  -- Load map.
  map = loadmap('maps/20x20-slim.txt')

  -- Prepare player.
  r, c = findstart(map)
  player = {x = c*wallWidth+playerWidth/2, y = r*wallHeight+playerHeight/2, speed = playerSpeed}
  playerDirection = 0

  -- Prepare bumping world.
  world = bump.newWorld(32)
  for r,row in ipairs(map) do
    for c,char in ipairs(row) do
      if char == 'W' then
        world:add({name='wall'}, c*wallWidth, r*wallHeight, wallWidth, wallHeight)
      end
      if char == 'E' then
        world:add({name='end'}, c*wallWidth, r*wallHeight, wallWidth, wallHeight)
      end
    end
  end
  playerObj = {name='player'}
  world:add(playerObj, player.x, player.y, playerWidth, playerHeight)

end

function love.update(dt)
  -- Quit game.
  if love.keyboard.isDown('escape', 'q') then
    love.event.push('quit')
  end

  -- Direction of mouse onscreen relative to the player.
  mouseX, mouseY = love.mouse.getPosition()
  movementDirection = math.atan2(mouseY - love.graphics.getHeight()/2, mouseX - love.graphics.getWidth()/2)

  -- Player movement.
  oldpos = {x=player.x, y=player.y}
  newpos = {x=player.x, y=player.y}
  if love.mouse.isDown(1) then
    newpos.y = player.y + math.sin(movementDirection) * player.speed * dt
    newpos.x = player.x + math.cos(movementDirection) * player.speed * dt
  else
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
  end

  -- Check where the player is facing to.
  -- if  (newpos.x == oldpos.x and newpos.x == oldpos.x) then
    playerDirection = math.atan2(newpos.y - oldpos.y, newpos.x - oldpos.x)
    if playerDirection > -math.pi/4 and playerDirection <= math.pi/4 then
      currentPlayerQuad = playerRightQuad
    elseif playerDirection > math.pi/4 and playerDirection <= 3*math.pi/4 then
      currentPlayerQuad = playerDownQuad
    elseif playerDirection > 3*math.pi/4 or playerDirection < -3*math.pi/4 then
      currentPlayerQuad = playerLeftQuad
    elseif playerDirection <= math.pi/4 and playerDirection >= -3*math.pi/4 then
      currentPlayerQuad = playerUpQuad
    end
  -- end

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
  -- love.graphics.scale(0.5) -- zoom the camera
  -- love.graphics.scale(love.graphics.getWidth()/GAME_WINDOW_WIDTH, love.graphics.getHeight()/GAME_WINDOW_HEIGHT) -- zoom the camera
  love.graphics.scale(love.graphics.getWidth()/GAME_WINDOW_WIDTH) -- zoom the camera
  love.graphics.translate(-player.x - playerWidth/2 + GAME_WINDOW_WIDTH/2, -player.y - playerHeight/2 + GAME_WINDOW_HEIGHT/2) -- move the camera position
  
  -- Draw the backgroud.
  love.graphics.setBackgroundColor(190, 190, 190, 255)
  for r=-1,#map+2 do
    for c=-1,#map[1]+2 do
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.draw(atlas, grassQuad, c*tileWidth, r*tileHeight)
    end
  end

  -- Draw Walls behind the player.
  playerRow = math.floor(player.y/tileHeight)
  for r=1,playerRow do
    row = map[r]
    for c=1,#row do
      char = row[c]
      if char == 'W' then
        love.graphics.setColor(255, 255, 255, 255)
        if r+1 <= #map and map[r+1][c] == 'W' then
          love.graphics.draw(atlas, topWallQuad, c*wallWidth, (r-1)*wallHeight)
        else
          love.graphics.draw(atlas, wallQuad, c*wallWidth, (r-1)*wallHeight)
        end
      elseif char == 'E' then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(atlas, trophieQuad, c*tileWidth, (r)*tileHeight)
      end
    end
  end
  -- for r,row in ipairs(map) do
  --   for c,char in ipairs(row) do
  --     if char == 'W' then
  --       -- love.graphics.setColor(0, 145, 255, 255)
  --       -- love.graphics.rectangle('fill', c*wall_width, r*wall_height, wall_width, wall_height)
  --       love.graphics.setColor(255, 255, 255, 255)
  --       if r+1 <= #map and map[r+1][c] == 'W' then
  --         love.graphics.draw(atlas, topWallQuad, c*wallWidth, (r-1)*wallHeight)
  --       else
  --         love.graphics.draw(atlas, wallQuad, c*wallWidth, (r-1)*wallHeight)
  --       end

  --     end
  --     if char == 'E' then
  --       -- love.graphics.setColor(0, 255, 0, 255)
  --       -- love.graphics.rectangle('fill', c*wallWidth, r*wallHeight, wallWidth, wallHeight)
  --       love.graphics.setColor(255, 255, 255, 255)
  --       love.graphics.draw(atlas, trophieQuad, c*tileWidth, (r)*tileHeight)
  --     end
  --   end
  -- end

  -- Draw the player
  love.graphics.setColor(0, 0, 255, 255)
  love.graphics.rectangle('fill', player.x, player.y, playerWidth, playerHeight)
  -- love.graphics.circle('fill', player.x+playerWidth/2, player.y+playerHeight/2, playerHeight/2, 32)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(atlas, currentPlayerQuad, player.x - tileWidth/2 + playerWidth/2, player.y - tileHeight*2 + playerHeight)

  -- Draw Walls in front of the player.
  for r=playerRow,#map do
    row = map[r]
    for c=1,#row do
      char = row[c]
      if char == 'W' then
        love.graphics.setColor(255, 255, 255, 255)
        if r+1 <= #map and map[r+1][c] == 'W' then
          love.graphics.draw(atlas, topWallQuad, c*wallWidth, (r-1)*wallHeight)
        else
          love.graphics.draw(atlas, wallQuad, c*wallWidth, (r-1)*wallHeight)
        end
      elseif char == 'E' then
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.draw(atlas, trophieQuad, c*tileWidth, (r)*tileHeight)
      end
    end
  end

  -- Zoom out back again.
  love.graphics.pop()

  debug = true
  if debug then
    love.graphics.print(playerDirection, 0, 0)
  end

  -- Show a winning message.
  if youwon then
    love.graphics.setFont(bigFont)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print("You won!", love.graphics.getWidth()/2-80, love.graphics.getHeight()/2-50)
  end
end