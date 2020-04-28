require(FAMILY.."nodes.button")
require(FAMILY.."nodes.text")

function TextButton(text, font)
  local self = Button()

  local text = Text(text or "Button", font)
    .setMode("center", "center")

  self.addChild(text)

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    text.setRect(0, 0, width, height)

    return self
  end

  function self.getTextNode()
    return text
  end

  return self
end
