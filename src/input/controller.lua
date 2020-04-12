function InputController(pressed, released, moved)
  local self = {
    pressed = pressed or nil,
    released = released or nil,
    moved = moved or nil
  }

  return self
end
