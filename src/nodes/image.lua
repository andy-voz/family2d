require(FAMILY.."nodes.node")
require(FAMILY.."util.color")
require(FAMILY.."util.drawmode")

function Image(image)
  local self = Node()

  local mode = "normal"

  local mode_info = ModeInfo()

  if image ~= nil then
    mode_info.set(DrawMode[mode](self.getRect(), image))
  end

  function self.onDraw()
    if image ~= nil then
      mode_info.draw(image)
    end
  end

  function self.setImage(new_image)
    image = new_image
    if image ~= nil then
      mode_info.set(DrawMode[mode](self.getRect(), image))
    end
    return self
  end

  function self.getImage()
    return image
  end

  function self.setMode(new_mode)
    mode = new_mode
    if image ~= nil then
      mode_info.set(DrawMode[mode](self.getRect(), image))
    end
    return self
  end

  function self.getMode()
    return mode
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    if image ~= nil then
      mode_info.set(DrawMode[mode](self.getRect(), image))
    end
    return self
  end

  return self
end
