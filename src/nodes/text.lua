require(FAMILY.."nodes.node")
require(FAMILY.."util.drawmode")

function Text(text, font)
  local self = Node()

  local font = font or love.graphics.newFont()

  local mode = "normal"

  local mode_info = ModeInfo()

  local text_string = text or ""

  local text = love.graphics.newText(font, text_string)

  function self.onDraw()
    mode_info.draw(text)
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    mode_info.set(DrawMode[mode](self.getRect(), text))
    return self
  end

  function self.setText(new_text)
    text_string = new_text
    text:set(text_string)
    mode_info.set(DrawMode[mode](self.getRect(), text))
    return self
  end

  function self.getText()
    return text_string
  end

  function self.setFont(new_font)
    font = new_font
    mode_info.set(DrawMode[mode](self.getRect(), text))
    return self
  end

  function self.getFont()
    return font
  end

  function self.setMode(new_mode)
    mode = new_mode
    mode_info.set(DrawMode[mode](self.getRect(), text))
    return self
  end

  function self.getMode()
    return mode
  end

  return self
end
