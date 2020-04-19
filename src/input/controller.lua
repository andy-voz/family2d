function InputController(pressed, released, moved, key_pressed, key_released, text_input, processed)
  local self = {
    pressed = pressed or {},
    released = released or {},
    moved = moved or {},
    key_pressed = key_pressed or {},
    key_released = key_released or {},
    text_input = text_input or {},
    processed = {}
  }

  return self
end
