local AnchorType = {}

function AnchorType.start()
  return 0
end

function AnchorType.ending(parent_size, child_size)
  return parent_size - child_size
end

function AnchorType.center(parent_size, child_size)
  return (parent_size - child_size) / 2
end

function Anchor(x, y)
  local self = {}

  function self.set(x, y)
    self.x = x or "start"
    self.y = y or "start"
  end

  function self.calc(parent, child)
    if parent == nil then return 0, 0 end

    local x = AnchorType[self.x](parent.getRect().width, child.getRect().width) + child.getRect().x
    local y = AnchorType[self.y](parent.getRect().width, child.getRect().height) + child.getRect().y

    return x, y
  end

  self.set(x, y)

  return self
end
