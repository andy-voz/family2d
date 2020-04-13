require(FAMILY.."nodes.node")
require(FAMILY.."util.drawmode")

function Text(text, font)
  local self = Node()

  local font = font or love.graphics.newFont()

  local mode = "normal"

  local mode_info = ModeInfo()

  local text = love.graphics.newText(font, text or "")

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
    text:set(new_text)
    mode_info.set(DrawMode[mode](self.getRect(), text))
    return self
  end

  function self.getText()
    return text
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
