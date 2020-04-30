require(FAMILY.."nodes.button")
require(FAMILY.."nodes.text")

function TextButton(text, font)
  local self = Button()

  local text = Text(text or "Button", font)
    .setMode("center", "center")

  self.addChild(text)

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local but_data = data.text_button
    if but_data ~= nil then
      if but_data.text ~= nil then text.load(but_data.text) end
    end

    return self
  end

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
