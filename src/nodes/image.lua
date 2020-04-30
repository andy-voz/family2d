require(FAMILY.."nodes.node")
require(FAMILY.."util.color")
require(FAMILY.."util.drawmode")

function Image(image)
  local self = Node()

  local mode_info = ModeInfo()

  if image ~= nil then
    mode_info.calculate(self.getRect(), image)
  end

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local image_data = data.image
    if image_data ~= nil then
      if image_data.image ~= nil then
        image = self.getR() ~= nil and
          self.getR().getImage(image_data.image) or
          love.graphics.newImage(image)
      end

      if image_data.mode ~= nil then
        local new_mode = image_data.mode
        mode_info.set(
          new_mode.mode_x,
          new_mode.mode_y,
          new_mode.scale,
          new_mode.scroll_x,
          new_mode.scroll_y
        )
      end
    end

    return self
  end

  function self.onUpdate(dt)
    if image ~= nil then
      mode_info.calculate(self.getRect(), image)
    end
  end

  function self.onDraw()
    if image ~= nil then
      mode_info.draw(image)
    end
  end

  function self.setImage(new_image)
    image = new_image
    self.setDirty()
    return self
  end

  function self.getImage()
    return image
  end

  function self.setMode(mode_x, mode_y, scale, scroll_x, scroll_y)
    mode_info.set(mode_x, mode_y, scale, scroll_x, scroll_y)
    self.setDirty()
    return self
  end

  function self.getMode()
    return mode_info
  end

  return self
end

NodeTypes.Image = Image
