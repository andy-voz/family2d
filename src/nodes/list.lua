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

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local list_data = data.list
    if list_data ~= nil then
      orientation = Orientation[data.orientation]
    end

    return self
  end

  self.setScissor(true)

  ProcessedController.addNode(self)

  self.addInputProcessor("processed", function(node, event)
    if node == self then return end

    pressed = false
  end)

  self.addInputProcessor("moved", function(event)
    if not pressed then return false end

    delta_x = delta_x + event.dx
    delta_y = delta_y + event.dy

    delta_x = math.min(0, delta_x)
    delta_y = math.min(0, delta_y)

    delta_x = math.max(content_delta_w, delta_x)
    delta_y = math.max(content_delta_h, delta_y)

    self.setDirty()
    return true
  end)

  self.addInputProcessor("pressed", function()
    pressed = true
    return true
  end)

  self.addInputProcessor("released", function()
    pressed = false
    return true
  end)

  local super_destroy = self.destroy
  function self.destroy()
    ProcessedController.removeNode(self)
    super_destroy()
  end

  function self.onUpdate(dt)
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
    end
  end

  function self.calcContentSize()
    content_w = 0
    content_h = 0

    for _, child in ipairs(self.getChildren()) do
      content_w = content_w + child.getRect().width
      content_h = content_h + child.getRect().height
    end

    content_delta_w = math.min(0, self.getRect().width - content_w)
    content_delta_h = math.min(0, self.getRect().height - content_h)
  end

  function self.onChildAdd(index)
    self.setDirty()

    self.calcContentSize()
  end

  function self.onChildRemove(index)
    self.setDirty()

    self.calcContentSize()
  end

  function self.setOrientation(new_orientation)
    orinetation = new_orientation
    delta = 0
    self.setDirty()
    return self
  end

  function self.getOrientation()
    return orientation
  end

  return self
end

NodeTypes.List = List
