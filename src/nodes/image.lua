require(FAMILY.."nodes.node")
require(FAMILY.."util.color")
require(FAMILY.."util.drawmode")

function Image(path)
  local self = Node()

  local image = nil

  local mode = "normal"

  local mode_info = ModeInfo()

  function self.load()
    image = love.graphics.newImage(path)
    mode_info.set(DrawMode[mode](self.getRect(), image))
  end

  function self.onDraw()
    if image ~= nil then
      mode_info.draw(image)
    end
  end

  function self.getImage()
    return image
  end

  function self.setMode(new_mode)
    mode = new_mode
    if image ~= nil then
      mode_info.set(DrawMode[mode](self.getRect(), image))
    end
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
  end

  return self
end
