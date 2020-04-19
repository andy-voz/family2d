require(FAMILY.."nodes.text")
require(FAMILY.."input.keyboard")
require(FAMILY.."input.processed")

local utf8 = require("utf8")

function Input(text, font)
  self = Text(text, font)

  KeyboardController.addNode(self)
  ProcessedController.addNode(self)

  local max = nil

  local focused = false

  local on_focus = nil
  local on_focus_lost = nil
  local on_confirm = nil

  self.setScissor(true)
  self.setMode("start", "ending", "none", true)

  self.addInputProcessor("pressed", function()
    self.setFocused(true)
    return true
  end)

  self.addInputProcessor("processed", function(node, event)
    if event.type ~= "pressed" then return end

    if node ~= self then
      self.setFocused(false)
    end
  end)

  self.addInputProcessor("text_input", function(text)
    if not focused or (max ~= nil and self.getText():len()) >= max then return end

    self.setText(self.getText()..text)
  end)

  self.addInputProcessor("key_pressed", function(key)
    if not focused then return end

    local text_string = self.getText()

    if key == "backspace" then
      if text_string:len() <= 0 then return end

      local byteoffset = utf8.offset(text_string, -1)
      self.setText(string.sub(text_string, 1, byteoffset - 1))
    elseif key == "return" and on_confirm ~= nil then
      on_confirm()
    end
  end)

  function self.setMax(new_max)
    max = new_max
    return self
  end

  function self.getMax()
    return max
  end

  function self.setFocused(new_focused)
    if focused == new_focused then return self end

    focused = new_focused
    if focused then
      if on_focus ~= nil then on_focus() end
      love.keyboard.setTextInput(true)
    elseif on_focus_lost ~= nil then
      on_focus_lost()
      love.keyboard.setTextInput(false)
    end

    return self
  end

  function self.getFocused()
    return focused
  end

  function self.setOnFocus(new_on_focus)
    on_focus = new_on_focus
    return self
  end

  function self.getOnFocus()
    return on_focus
  end

  function self.setOnFocusLost(new_on_focus_lost)
    on_focus_lost = new_on_focus_lost
    return self
  end

  function self.getOnFocusLost()
    return on_focus_lost
  end

  function self.setOnConfirm(new_on_confirm)
    on_confirm = new_on_confirm
    return self
  end

  function self.getOnConfirm()
    return on_confirm
  end

  return self
end
