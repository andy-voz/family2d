require(FAMILY.."nodes.node")
require(FAMILY.."util.color")

ImageMode = {
  normal = function()
    return 0, 0, 1, 1
  end,

  fill = function(rect, image)
    local scale_x = rect.width / image:getWidth()
    local scale_y = rect.height / image:getHeight()
    return 0, 0, scale_x, scale_y
  end,

  center = function(rect, image)
    local x = (rect.width - image:getWidth()) / 2
    local y = (rect.height - image:getHeight()) / 2
    return x, y, 1, 1
  end,

  proportional = function(rect, image)
    local scale_x = rect.width / image:getWidth()
    local scale_y = rect.height / image:getHeight()
    local scale = math.min(scale_x, scale_y)

    return 0, 0, scale, scale
  end,

  center_proportional = function(rect, image)
    local scale_x = rect.width / image:getWidth()
    local scale_y = rect.height / image:getHeight()
    local scale = math.min(scale_x, scale_y)

    local x = (rect.width - image:getWidth() * scale) / 2
    local y = (rect.height - image:getHeight() * scale) / 2

    return x, y, scale, scale
  end
}

function Image(path)
  local self = Node()

  local image = nil

  local tint_color = Color(1, 1, 1, 1)

  local mode = "normal"

  local mode_quad = {
    set = function(self, x, y, scale_x, scale_y)
      self.x = x
      self.y = y
      self.scale_x = scale_x
      self.scale_y = scale_y
    end
  }

  mode_quad:set(0, 0, 1, 1)

  function self.load()
    image = love.graphics.newImage(path)
    mode_quad:set(ImageMode[mode](self.getRect(), image))
  end

  function self.onDraw()
    if image ~= nil then
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(tint_color.r, tint_color.g, tint_color.b, tint_color.a)

      love.graphics.draw(image, mode_quad.x, mode_quad.y, 0, mode_quad.scale_x, mode_quad.scale_y)
      love.graphics.setColor(r, g, b, a)
    end
  end

  function self.getImageWidth()
    return image == nil and 0 or image:getWidth()
  end

  function self.getImageHeight()
    return image == nil and 0 or image:getHeight()
  end

  function self.setTintColor(r, g, b, a)
    tint_color.set(r, g, b, a)
  end

  function self.getTintColor()
    return tint_color
  end

  function self.setMode(new_mode)
    mode = new_mode
    if image ~= nil then
      mode_quad:set(ImageMode[mode](self.getRect(), image))
    end
  end

  function self.getMode()
    return mode
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    if image ~= nil then
      mode_quad:set(ImageMode[mode](self.getRect(), image))
    end
  end

  return self
end
