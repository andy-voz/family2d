require(FAMILY.."nodes.image")
require(FAMILY.."nodes.text")
require(FAMILY.."input.processed")

function Button()
  local self = Image()

  local thin = false

  local states = {
    normal = nil,
    pressed = nil,
    disabled = nil
  }

  local threshold = 10

  local current_shift_x = 0
  local current_shift_y = 0

  local state = "normal"

  local callbacks = {}

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local but_data = data.button
    if but_data ~= nil then
      thin = but_data.thin or thin
      threshold = but_data.threshold or threshold

      if but_data.states ~= nil then
        local path = but_data.states.normal
        if path ~= nil then
          states.normal = self.getR() ~= nil and
            self.getR().getImage(path) or
            love.graphics.newImage(path)
        end

        path = but_data.states.pressed
        if path ~= nil then
          states.pressed = self.getR() ~= nil and
            self.getR().getImage(path) or
            love.graphics.newImage(path)
        end

        path = but_data.states.disabled
        if path ~= nil then
          states.disabled = self.getR() ~= nil and
            self.getR().getImage(path) or
            love.graphics.newImage(path)
        end
      end
    end

    return self
  end

  ProcessedController.addNode(self)

  self.addInputProcessor("processed", function(node, event)
    if node == self or state ~= "pressed" then return end

    if event.type == "released" then
      self.setState("normal")
    elseif event.type == "moved" then
      current_shift_x = current_shift_x + math.abs(event.dx)
      current_shift_y = current_shift_y + math.abs(event.dy)

      local max_shift = math.max(current_shift_x, current_shift_y)
      if (max_shift > threshold) then
        self.setState("normal")
      end
    end
  end)

  self.addInputProcessor("pressed", function()
    current_shift_x = 0
    current_shift_y = 0

    self.setState("pressed")
    return not thin
  end)

  self.addInputProcessor("released", function()
    if state ~= "pressed" then return not thin end

    self.setState("normal")
    for _, callback in ipairs(callbacks) do
      callback(self)
    end
    return not thin
  end)

  local super_destroy = self.destroy
  function self.destroy()
    ProcessedController.removeNode(self)
    super_destroy()
  end

  local super_setEnabled = self.setEnabled
  function self.setEnabled(on)
    super_setEnabled(on)

    if not on then
      self.setState("disabled")
    elseif state == "disabled" and on then
      self.setState("normal")
    end

    return self
  end

  function self.addStateImage(name, image)
    states[name] = image
    if name == state then
      self.setState(state)
    end
    return self
  end

  function self.setState(new_state)
    state = new_state
    self.setImage(states[state])
    return self
  end

  function self.getState()
    return state
  end

  function self.addOnClick(callback)
    table.insert(callbacks, callback)
    return self
  end

  function self.removeOnClick(callback)
    local index = nil
    for i, c in ipairs(callbacks) do
      if c == callback then
        index = i
        break
      end
    end

    if index ~= nil then table.remove(callbacks, index) end
    return self
  end

  function self.setThin(new_thin)
    thin = new_thin
    return self
  end

  function self.getThin()
    return thin
  end

  function self.setThreshold(new_threshold)
    threshold = new_threshold
    return self
  end

  function self.getThreshold()
    return threshold
  end

  return self
end

NodeTypes.Button = Button
