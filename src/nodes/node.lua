require(FAMILY.."util.rect")
require(FAMILY.."util.color")
require(FAMILY.."input.controller")

function Node()
  local self = {}

  local local_transform = love.math.newTransform()
  local global_transform = love.math.newTransform()

  local rect = Rect()
  local world_rect = Rect()

  -- scale factor of the node
  local scale_x = 1
  local scale_y = 1

  -- origin of the node
  local origin_x = 0
  local origin_y = 0

  -- node rotation
  local rotation = 0

  -- skew factor
  local skew_x = 0
  local skew_y = 0

  -- should draw node with it's children or not
  local visible = true

  -- can node process input events.
  local enabled = true

  -- if true, will draw node's rect
  local debug = false

  local scissor = false

  local debug_color = ColorUtil.random()

  local background_color = Color()

  local tint_color = Color(1, 1, 1, 1)

  -- array of inner nodes
  local children = {}

  -- parent of current node
  local parent = nil

  local controller = InputController()

  -- Drawing node if visible
  function self.draw()
    if not visible then return end

    love.graphics.replaceTransform(global_transform)

    local s_x, s_y, s_w, s_h = love.graphics.getScissor()
    if scissor then
      love.graphics.setScissor(world_rect.x, world_rect.y, world_rect.width, world_rect.height)
    end

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(background_color.r, background_color.g, background_color.b, background_color.a)
    love.graphics.rectangle("fill", 0, 0, rect.width, rect.height)

    love.graphics.setColor(tint_color.r, tint_color.g, tint_color.b, tint_color.a)
    self.onDraw()

    if debug then
      love.graphics.setColor(debug_color.r, debug_color.b, debug_color.g, 1)
      love.graphics.rectangle("line", 0, 0, rect.width, rect.height)
    end

    love.graphics.setColor(r, g, b, a)

    for _, child in ipairs(children) do
      child.draw()
    end
    love.graphics.setScissor(s_x, s_y, s_w, s_h)
  end

  -- Empty function for overriding in "subclasses"
  function self.onDraw()
  end

  function self.update(dt)
    for _, child in ipairs(children) do
      child.update(dt)
    end
  end

  --
  function self.input(input_event)
    if not enabled or not visible then return nil end

    for i = #children, 1, -1 do
      local processed = children[i].input(input_event)
      if processed ~= nil then return processed end
    end

    local local_x, local_y = self.fromWorld(input_event.x, input_event.y)
    if not rect.inBounds(local_x, local_y) then return nil end

    local processed = false
    for _, processor in ipairs(controller[input_event.type]) do
      processed = processed or processor(input_event)
    end

    if processed then return self else return nil end
  end

  function self.addChild(node, pos)
    node.setParent(self)
    index = pos or #children + 1
    table.insert(children, index, node)
    self.onChildAdd(index)
    return self
  end

  function self.addChildren(append_children)
    for _, child in ipairs(append_children) do
      self.addChild(child)
    end
    return self
  end

  function self.onChildAdd(index)
  end

  function self.removeChild()
    local removing_index = nil
    for i, child in ipairs(children) do
      if child == self then
        child.setParent(nil)
        removing_index = i
        break
      end
    end

    if removing_index ~= nil then table.remove(children, removing_index) end
    self.onChildRemove(removing_index)
    return self
  end

  function self.clearChildren()
    for i, child in ipairs(children) do
      child.setParent(nil)
      children[i] = nil
    end
    self.onClearChildren()
    return self
  end

  function self.onChildRemove(index)
  end

  function self.onClearChildren()
  end

  function self.getChildren()
    return children
  end

  -- Updating parent field,
  -- global transform by multiplying parent global and child local matrixes
  function self.setParent(new_parent)
    parent = new_parent
    self.updateTransform()
    if not debug and parent.getDebug() then
      self.setDebug(true)
    end
    return self
  end

  function self.updateTransform()
    local_transform:setTransformation(rect.x, rect.y, rotation, scale_x, scale_y, origin_x, origin_y, skew_x, skew_y)
    self.updateGlobalTransform()
    self.updateWorldRect()
    for _, child in ipairs(children) do
      child.updateTransform()
    end
  end

  function self.updateWorldRect()
    local x1, y1 = self.toWorld(0, 0)
    local x2, y2 = self.toWorld(rect.width, 0)
    local x3, y3 = self.toWorld(rect.width, rect.height)
    local x4, y4 = self.toWorld(0, rect.height)

    local min_x = math.min(x1, x2, x3, x4)
    local max_x = math.max(x1, x2, x3, x4)

    local min_y = math.min(y1, y2, y3, y4)
    local max_y = math.max(y1, y2, y3, y4)

    world_rect.set(min_x, min_y, max_x - min_x, max_y - min_y)
  end

  function self.updateGlobalTransform()
    if parent == nil then
      global_transform = local_transform
    else
      global_transform = parent.getGlobalTransform() * local_transform
    end
  end

  function self.fromWorld(x, y)
    return global_transform:inverseTransformPoint(x, y)
  end

  function self.toWorld(x, y)
    return global_transform:transformPoint(x, y)
  end

  -- @return Transformation object, using to convert coordinates from global to local
  -- and vice versa
  function self.getGlobalTransform()
    return global_transform
  end

  function self.setRect(x, y, width, height)
    rect.set(x, y, width, height)

    self.updateTransform()
    return self
  end

  function self.getRect()
    return rect
  end

  function self.getWorldRect()
    return world_rect
  end

  function self.setScale(new_scale_x, new_scale_y)
    scale_x = new_scale_x or 1
    scale_y = new_scale_y or scale_x

    self.updateTransform()
    return self
  end

  function self.getScale()
    return scale_x, scale_y
  end

  function self.setRotation(new_rotation)
    rotation = new_rotation or 0

    self.updateTransform()
    return self
  end

  function self.getRotation()
    return rotation
  end

  function self.setOrigin(x, y)
    origin_x = x or 0
    origin_y = y or 0

    self.updateTransform()
    return self
  end

  function self.getOrigin()
    return origin_x, origin_y
  end

  function self.setSkew(x, y)
    skew_x = x or 0
    skew_y = y or 0

    self.updateTransform()
    return self
  end

  function self.getSkew()
    return skew_x, skew_y
  end

  function self.setEnabled(on)
    enabled = on
    return self
  end

  function self.getEnabled()
    return enabled
  end

  function self.setVisible(on)
    visible = on
    return self
  end

  function self.getVisible()
    return visible
  end

  function self.setDebug(on)
    debug = on

    if debug then
      for _, child in ipairs(children) do
        child.setDebug(debug)
      end
    end
    return self
  end

  function self.getDebug()
    return debug
  end

  function self.setScissor(on)
    scissor = on
    return self
  end

  function self.getScissor()
    return scissor
  end

  function self.setBackgroundColor(r, g, b, a)
    background_color.set(r, g, b, a)
    return self
  end

  function self.getBackgroundColor()
    return background_color
  end

  function self.getTintColor()
    return tint_color
  end

  function self.setTintColor(r, g, b, a)
    tint_color.set(r, g, b, a)
    return self
  end

  function self.setController(new_controller)
    controller = new_controller
    return self
  end

  function self.getController()
    return controller
  end

  function self.addInputProcessor(type, processor)
    table.insert(controller[type], processor)
  end

  function self.removeInputProcessor(type, processor)
    local index = nil
    for i, p in ipairs(controller[type]) do
      if processor == p then
        index = i
        break
      end
    end

    if index ~= nil then table.remove(controller[type], index) end
  end

  function self.getGlobalTransform()
    return global_transform
  end

  function self.getLocalTransform()
    return local_transform
  end

  return self
end
