require(FAMILY.."nodes.node")
require(FAMILY.."util.color")
require(FAMILY.."util.drawmode")

function Image(image)
  local self = Node()

  local mode_info = ModeInfo()

  if image ~= nil then
    mode_info.calculate(self.getRect(), image)
  end

  function self.onDraw()
    if image ~= nil then
      mode_info.draw(image)
    end
  end

  function self.setImage(new_image)
    image = new_image
    if image ~= nil then
      mode_info.calculate(self.getRect(), image)
    end
    return self
  end

  function self.getImage()
    return image
  end

  function self.setMode(mode_x, mode_y, scale, scroll_x, scroll_y)
    mode_info.set(mode_x, mode_y, scale, scroll_x, scroll_y)
    if image ~= nil then
      mode_info.calculate(self.getRect(), image)
    end
    return self
  end

  function self.getMode()
    return mode_info
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    if image ~= nil then
      mode_info.calculate(self.getRect(), image)
    end
    return self
  end

  return self
end
