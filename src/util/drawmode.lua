function ModeInfo(x, y, scale_x, scale_y)
  local self = {}

  function self.set(x, y, scale_x, scale_y)
    self.x = x
    self.y = y
    self.scale_x = scale_x
    self.scale_y = scale_y
  end

  function self.draw(drawable)
    love.graphics.draw(drawable, self.x, self.y, 0, self.scale_x, self.scale_y)
  end

  self.set(x or 0, y or 0, scale_x or 1, scale_y or 1)

  return self
end

DrawMode = {}

function DrawMode.normal()
  return 0, 0, 1, 1
end

function DrawMode.fill(rect, drawable)
  local scale_x = rect.width / drawable:getWidth()
  local scale_y = rect.height / drawable:getHeight()
  return 0, 0, scale_x, scale_y
end

function DrawMode.center(rect, drawable)
  local x = (rect.width - drawable:getWidth()) / 2
  local y = (rect.height - drawable:getHeight()) / 2
  return x, y, 1, 1
end

function DrawMode.proportional(rect, drawable)
  local scale_x = rect.width / drawable:getWidth()
  local scale_y = rect.height / drawable:getHeight()
  local scale = math.min(scale_x, scale_y)

  return 0, 0, scale, scale
end

function DrawMode.center_proportional(rect, drawable)
  local scale_x = rect.width / drawable:getWidth()
  local scale_y = rect.height / drawable:getHeight()
  local scale = math.min(scale_x, scale_y)

  local x = (rect.width - drawable:getWidth() * scale) / 2
  local y = (rect.height - drawable:getHeight() * scale) / 2

  return x, y, scale, scale
end
