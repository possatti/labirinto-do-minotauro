local world

return {
  load = function(self)
    -- Define the levels sequence
    self.levels = {
      'maps/first-level.lua',
      'maps/second-level.lua',
      'maps/the-end.lua',
    }

    self.currentLevel = 1

    -- Load level.
    self:loadlevel(self.currentLevel)
  end,

  update = function(self, dt)
    -- Update hero's animations.
    heroRightAnim:update(dt)
    heroDownAnim:update(dt)
    heroLeftAnim:update(dt)
    heroUpAnim:update(dt)

    -- Update world
    self.map:update(dt)
  end,

  draw = function(self)
    -- Zoom scale and translation factors.
    local sx = getXScale()
    local tx = -self.player.x + getGameWindowWidth()/2
    local ty = -self.player.y + getGameWindowHeight()/2
    tx = math.floor(tx)
    ty = math.floor(ty)

    -- Draw world.
    self.map:draw(tx, ty, sx, sx)

    -- Draw onscreen controls
    onscreen:draw()

    -- Draw collision boxes.
    if enableDebug then
      love.graphics.push()
      love.graphics.scale(sx)
      love.graphics.translate(tx, ty)
      -- map:bump_draw(world,0,0,1,1)
      love.graphics.pop()
    end
  end,

  loadlevel = function(self, levelnumber)
    self.currentLevel = levelnumber
    self.world = bump.newWorld()
    local loadedData = loadmap(self.levels[self.currentLevel], self.world, self)
    self.map = loadedData.map
    self.player = loadedData.player
  end,
}
