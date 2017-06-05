return {
  load = function(self)
  end,

  update = function(self, dt)
    -- Update hero's animations.
    heroRightAnim:update(dt)
    heroDownAnim:update(dt)
    heroLeftAnim:update(dt)
    heroUpAnim:update(dt)

    -- Update world
    map:update(dt)
  end,

  draw = function(self)
    -- Zoom scale and translation factors.
    local sx = getXScale()
    local tx = -player.x + getGameWindowWidth()/2
    local ty = -player.y + getGameWindowHeight()/2
    tx = math.floor(tx)
    ty = math.floor(ty)

    -- Draw world.
    map:draw(tx, ty, sx, sx)

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
}
