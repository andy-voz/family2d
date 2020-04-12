local function Event(type)
  local self = {
    type = type or error("Event type undefined!")
  }

  return self
end

function MouseEvent(type, x, y, button, istouch, presses)
  local self = Event(type)

  self.x = x
  self.y = y
  self.button = button
  self.istouch = istouch
  self.presses = presses

  return self
end

function MouseMoveEvent(type, x, y, dx, dy, istouch)
  local self = Event(type)

  self.x = x
  self.y = y
  self.dx = dx
  self.dy = dy
  self.istouch = istouch

  return self
end

function TouchEvent(type, id, x, y, dx, dy, pressure)
  local self = Event(type)

  self.id = id
  self.x = x
  self.y = y
  self.dx = dx
  self.dy = dy
  self.pressure = pressure

  return self
end
