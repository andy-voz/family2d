require(FAMILY.."nodes.node")
require(FAMILY.."util.drawmode")

function Text(text, font)
  local self = Node()

  local font = font or love.graphics.newFont()

  local text_string = text or ""

  local text = love.graphics.newText(font, text_string)

  local virtual_height = text:getFont():getHeight()

  local mode_info = ModeInfo()

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local text_data = data.text
    if text_data ~= nil then
      self.setText(text_data.text or text_string)
      virtual_height = text_data.virtual_height or virtual_height
      if text_data.font ~= nil then
        font = self.getR() ~= nil and
          self.getR().getFont(text_data.font.name) or
          love.graphics.newFont(text_data.font.name, text_data.font.height)
      end
      if text_data.mode ~= nil then
        local new_mode = text_data.mode
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

  function self.onUpdate()
    mode_info.calculate(self.getRect(), text)
  end

  local super_calcScale = mode_info.calcScale
  function mode_info.calcScale(rect, drawable)
    if virtual_height == text:getFont():getHeight() then
      return super_calcScale(rect, drawable)
    else
      scale = virtual_height / text:getFont():getHeight()
      return scale, scale
    end
  end

  mode_info.calculate(self.getRect(), text)

  function self.onDraw()
    mode_info.draw(text)
  end

  function self.setText(new_text)
    text_string = new_text
    text:set(text_string)
    self.setDirty()
    return self
  end

  function self.getText()
    return text_string
  end

  function self.setFont(new_font)
    font = new_font
    text:setFont(font)
    self.setDirty()
    return self
  end

  function self.getFont()
    return font
  end

  function self.setMode(mode_x, mode_y, scale, scroll_x, scroll_y)
    mode_info.set(mode_x, mode_y, scale, scroll_x, scroll_y)
    self.setDirty()
    return self
  end

  function self.getMode()
    return mode_info
  end

  function self.setVirtualHeight(new_height)
    virtual_height = new_height
    self.setDirty()
    return self
  end

  function self.getVirtualHeight()
    return self
  end

  return self
end

NodeTypes.Text = Text
