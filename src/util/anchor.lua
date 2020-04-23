local AnchorType = {}

function AnchorType.start()
  return 0
end

function AnchorType.ending(parent_size, child_size)
  return parent_size - child_size
end

function AnchorType.center(parent_size, child_size)
  return parent_size / 2
end

function Anchor(x, y)
  local self = {}

  function self.set(x, y)
    self.x = x or "start"
    self.y = y or "start"
  end

  function self.calc(parent, child)
    if parent == nil then return 0, 0 end

    local s_x, s_y = child.getScale()
    local x = AnchorType[self.x](parent.getRect().width, child.getRect().width * s_x)
    local y = AnchorType[self.y](parent.getRect().height, child.getRect().height * s_y)

    return x, y
  end

  self.set(x, y)

  return self
end
