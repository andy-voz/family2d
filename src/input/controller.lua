function InputController(pressed, released, moved, key_pressed, key_released, text_input, processed)
  local self = {
    pressed = pressed or nil,
    released = released or nil,
    moved = moved or nil,
    key_pressed = key_pressed or nil,
    key_released = key_released or nil,
    text_input = text_input or nil,
    processed = nil
  }

  return self
end
