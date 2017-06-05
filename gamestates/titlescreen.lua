return {
  load = function(self)
    self.pixelFont = love.graphics.newFont('assets/fonts/04b03Regular.ttf', 50)
    self.selected = nil
    local itensBoxTop = 90
    local spacing = self.pixelFont:getHeight() * 2
    self.itens = {
      {
        name = 'START',
        action = function(self)
          gamestate = gameState
        end
      }, {
        name = 'OPTIONS',
        action = function(self)
          print(self.name)
        end
      }, {
        name = 'CREDITS',
        action = function(self)
          print(self.name)
        end
      }, {
        name = 'EXIT',
        action = function(self)
          love.event.push('quit')
        end
      },
    }
    for i, item in ipairs(self.itens) do
      item.n = i
      item.x = 0
      item.y = i * spacing + itensBoxTop
      item.right = love.graphics.getWidth()
      item.bottom = item.y + self.pixelFont:getHeight()
      item.width = item.right - item.x
      item.height = item.bottom - item.y
    end
    self.itensBox = {
      x = 0,
      y = 90,
      rightLimit = love.graphics.getWidth(),
      spacing = self.pixelFont:getHeight() * 2,
    }
  end,

  keyreleased = function(self, key, code)
    if key == 'return' or key == 'space' then
      if self.selected then
        self.selected:action()
      end
    elseif key == 'up' then
      if self.selected then
        local newindex = math.max(1, self.selected.n - 1)
        self.selected = self.itens[newindex]
      else
        self.selected = self.itens[#self.itens]
      end
    elseif key == 'down' then
      if self.selected then
        local newindex = math.min(#self.itens, self.selected.n + 1)
        self.selected = self.itens[newindex]
      else
        self.selected = self.itens[1]
      end
    end
  end,

  mousepressed = function(self, mx, my, button, isTouch)
    for i, item in ipairs(self.itens) do
      if item.x < mx and mx < item.right and
        item.y < my and my < item.bottom then
        if item == self.selected then
          item:action()
        else
          self.selected = item
        end
      end
    end
  end,

  update = function(self) end,

  draw = function(self)
    -- Draw itens.
    love.graphics.setBackgroundColor(15,15,15,255)
    love.graphics.setFont(self.pixelFont)
    for i, item in ipairs(self.itens) do
      -- Draw click boundaries.
      if enableDebug then
        love.graphics.setColor(0,0, 200,50)
        love.graphics.rectangle('fill', item.x, item.y, item.width, item.height)
      end

      -- Draw item.
      if item == self.selected then
        love.graphics.setColor(200,200,0,255)
        love.graphics.printf('[ '..item.name..' ]', item.x, item.y, item.right, 'center')
      else
        love.graphics.setColor(200,200,200,255)
        love.graphics.printf(item.name, item.x, item.y, item.right, 'center')
      end
    end
  end
}
