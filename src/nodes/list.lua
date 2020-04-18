require(FAMILY.."nodes.node")

Orientation = {
  vertical = 0,
  horizontal = 1
}

function List()
  local self = Node()

  local pressed = false

  local orientation = Orientation.vertical

  local delta_x = 0
  local delta_y = 0

  local content_w = 0
  local content_h = 0

  local content_delta_w = 0
  local content_delta_h = 0

  local need_update = false

  self.setScissor(true)

  ProcessedController.addNode(self)

  self.setProcessed(function(node, event)
    if node == self then return end

    pressed = false
  end)

  self.setMoved(function(event)
    if not pressed then return false end

    delta_x = delta_x + event.dx
    delta_y = delta_y + event.dy

    delta_x = math.min(0, delta_x)
    delta_y = math.min(0, delta_y)

    delta_x = math.max(content_delta_w, delta_x)
    delta_y = math.max(content_delta_h, delta_y)

    need_update = true
    return true
  end)

  self.setPressed(function()
    pressed = true
    return true
  end)

  self.setReleased(function()
    pressed = false
    return true
  end)

  function self.update(dt)
    if not need_update then return end

    local pos = 0
    local scale_x, _, _, _, _, scale_y = self.getGlobalTransform():getMatrix()

    if orientation == Orientation.vertical then
      pos = delta_y / scale_y
    elseif orientation == Orientation.horizontal then
      pos = delta_x / scale_x
    end

    for _, child in ipairs(self.getChildren()) do
      if orientation == Orientation.vertical then
        child.setRect(child.getRect().x, pos, child.getRect().width, child.getRect().height)
        pos = pos + child.getRect().height
      elseif orientation == Orientation.horizontal then
        child.setRect(pos / scale_x, child.getRect().y, child.getRect().width, child.getRect().height)
        pos = pos + child.getRect().width
      end

      child.update(dt)
    end
  end

  function self.calcContentSize()
    content_w = 0
    content_h = 0

    for _, child in ipairs(self.getChildren()) do
      content_w = content_w + child.getRect().width
      content_h = content_h + child.getRect().height
    end

    content_delta_w = self.getRect().width - content_w
    content_delta_h = self.getRect().height - content_h
  end

  function self.onChildAdd(index)
    need_update = true

    self.calcContentSize()
  end

  function self.onChildRemove(index)
    need_update = true

    self.calcContentSize()
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    super_setRect(x, y, width, height)

    need_update = true
    return self
  end

  function self.setOrientation(new_orientation)
    orinetation = new_orientation
    delta = 0
    need_update = true
    return self
  end

  function self.getOrientation()
    return orientation
  end

  return self
end
