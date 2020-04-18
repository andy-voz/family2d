local DrawMode = {}

function DrawMode.center(rect_size, drawable_size)
  return (rect_size - drawable_size) / 2
end

function DrawMode.start()
  return 0
end

function DrawMode.ending(rect_w, drawable_w)
  return rect_w - drawable_w
end

function DrawMode.none()
  return 1, 1
end

function DrawMode.proportional(rect, drawable)
  local scale_x = rect.width / drawable:getWidth()
  local scale_y = rect.height / drawable:getHeight()
  local scale = math.min(scale_x, scale_y)

  return scale, scale
end

function DrawMode.fill(rect, drawable)
  local scale_x = rect.width / drawable:getWidth()
  local scale_y = rect.height / drawable:getHeight()
  return scale_x, scale_y
end

function ModeInfo(rect, drawable, mode_x, mode_y, scale, scroll_x, scroll_y)
  local self = {}

  function self.set(mode_x, mode_y, scale, scroll_x, scroll_y)
    self.mode_x = mode_x or "start"
    self.mode_y = mode_y or "start"
    self.scale = scale or "none"
    self.scroll_x = scroll_x or false
    self.scroll_y = scroll_y or false
  end

  function self.calcScale(rect, drawable)
     return DrawMode[self.scale](rect, drawable)
  end

  function self.calculate(rect, drawable)
    self.scale_x, self.scale_y = self.calcScale(rect, drawable)
    self.x = DrawMode[self.mode_x](rect.width, drawable:getWidth() * self.scale_x)
    if self.scroll_x then
      local dx = rect.width - drawable:getWidth() * self.scale_x
      if dx < 0 then
        self.x = self.x + dx
      end
    end

    self.y = DrawMode[self.mode_y](rect.height, drawable:getHeight() * self.scale_y)
    if self.scroll_y then
      local dy = rect.height - drawable:getHeight() * self.scale_y
      if dy < 0 then
        self.y = self.y + dy
      end
    end
  end

  function self.draw(drawable)
    love.graphics.draw(drawable, self.x, self.y, 0, self.scale_x, self.scale_y)
  end

  self.set(mode_x, mode_y, scale, scroll)
  if rect ~= nil and drawable ~= nil then
    self.calculate(rect, drawable)
  end

  return self
end

