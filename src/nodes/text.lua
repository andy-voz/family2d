require(FAMILY.."nodes.node")
require(FAMILY.."util.drawmode")

function Text(text, font)
  local self = Node()

  local font = font or love.graphics.newFont()

  local text_string = text or ""

  local text = love.graphics.newText(font, text_string)

  local virtual_height = text:getFont():getHeight()

  local mode_info = ModeInfo()
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

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    mode_info.calculate(self.getRect(), text)
    return self
  end

  function self.setText(new_text)
    text_string = new_text
    text:set(text_string)
    mode_info.calculate(self.getRect(), text)
    return self
  end

  function self.getText()
    return text_string
  end

  function self.setFont(new_font)
    font = new_font
    text:setFont(font)
    mode_info.calulate(self.getRect(), text)
    return self
  end

  function self.getFont()
    return font
  end

  function self.setMode(mode_x, mode_y, scale, scroll_x, scroll_y)
    mode_info.set(mode_x, mode_y, scale, scroll_x, scroll_y)
    mode_info.calculate(self.getRect(), text)
    return self
  end

  function self.getMode()
    return mode_info
  end

  function self.setVirtualHeight(new_height)
    virtual_height = new_height
    mode_info.calculate(self.getRect(), text)
    return self
  end

  function self.getVirtualHeight()
    return self
  end

  return self
end
