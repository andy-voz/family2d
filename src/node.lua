-- Getting folder that contains our src
local family_path = (...):match("(.-)[^%/%.]+$")
require(family_path..'rect')

-- Creating a new drawable node with a bunch of base methods
-- which allows to draw and update node, processing input events,
-- converting coordinates from local node coordinates to global world coords.
--
-- Each node can have an array of inner nodes.
function Node()
  local self = {}

  local local_transform = love.math.newTransform()
  local global_transform = love.math.newTransform()

  local rect = Rect()

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

  local debugColor = {
    r = math.random(),
    g = math.random(),
    b = math.random()
  }

  -- array of inner nodes
  local children = {}

  -- parent of current node
  local parent = nil

  local onTap = nil

  -- Drawing node if visible
  function self.draw()
    if not visible then return end

    love.graphics.replaceTransform(global_transform)

    if debug then
      local r, g, b, a = love.graphics.getColor()
      love.graphics.setColor(debugColor.r, debugColor.b, debugColor.g, 1)
      love.graphics.rectangle("line", 0, 0, rect.width, rect.height)
      love.graphics.setColor(r, g, b, a)
    end
    
    for _, child in ipairs(children) do
      child.draw()
    end
  end

  -- Processing tap event
  function self.tap(x, y)
    if not enabled then return false end

    for i = #children, 1, -1 do
      if children[i].tap(x, y) then return true end 
    end

    local local_x, local_y = self.fromWorld(x, y)

    if rect.inBounds(local_x, local_y) then
      if onTap ~= nil then
        onTap(local_x, local_y)
      end

      return true
    end

    return false
  end

  function self.addChild(node)
    node.setParent(self)
    table.insert(children, node)
  end

  function self.removeChild()
    local removed_index = -1
    for i, child in ipairs(children) do
      if child == self then
        child.setParent(nil)
        removed_index = i
        break
      end
    end

    if removed_index >= 0 then table.remove(children, removed_index) end
  end

  -- Updating parent field,
  -- global transform by multiplying parent global and child local matrixes
  function self.setParent(new_parent) 
    parent = new_parent
    self.updateTransform()
    if not debug then
      debug = parent.getDebug()
    end
  end

  function self.updateTransform()
    local_transform:setTransformation(rect.x, rect.y, rotation, scale_x, scale_y, origin_x, origin_y, skew_x, skew_y) 
    self.updateGlobalTransform()
    for _, child in ipairs(children) do
      child.updateGlobalTransform()
    end
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

  function self.setRect(new_rect)
    rect = new_rect

    self.updateTransform()
  end

  function self.getRect()
    return rect
  end

  function self.setScale(new_scale_x, new_scale_y)
    scale_x = new_scale_x or 1
    scale_y = new_scale_y or scale_x
    
    self.updateTransform()
  end

  function self.getScale()
    return scale_x, scale_y
  end

  function self.setRotation(new_rotation)
    rotation = new_rotation or 0
    
    self.updateTransform()
  end

  function self.getRotation()
    return rotation
  end

  function self.setOrigin(x, y)
    origin_x = x or 0
    origin_y = y or 0

    self.updateTransform()
  end

  function self.getOrigin()
    return origin_x, origin_y
  end

  function self.setSkew(x, y)
    skew_x = x or 0
    skew_y = y or 0

    self.updateTransform()
  end

  function self.getSkew()
    return skew_x, skew_y
  end

  function self.setOnTap(onTapListener)
    onTap = onTapListener
  end

  function self.setEnabled(on)
    self.enabled = on or true
  end

  function self.getEnabled()
    return enabled
  end

  function self.setVisible(on)
    visible = on or true
  end

  function self.getVisible()
    return visible  
  end

  function self.setDebug(on)
    debug = on or false

    for _, child in ipairs(children) do
      child.setDebug(debug)
    end
  end

  function self.getDebug()
    return debug
  end

  return self
end
