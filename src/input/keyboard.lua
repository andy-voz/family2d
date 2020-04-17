KeyboardController = {}

local nodes = {}

function KeyboardController.addNode(node)
  table.insert(nodes, node)
end

function KeyboardController.removeNode(node)
  local index = nil
  for i, n in ipairs(nodes) do
    if node == n then
      index = i
      break
    end
  end

  if index ~= nil then table.remove(nodes, index) end
end

local function iterate(type, arg1, arg2, arg3)
  for _, node in ipairs(nodes) do
    if not node.getEnabled() then goto continue end

    local callback = node.getController()[type]
    if callback ~= nil then
      callback(arg1, arg2, arg3)
    end
    ::continue::
  end
end

function KeyboardController.keyPressed(key, scancode, isRepeat)
  iterate("key_pressed", key, scancode, isRepeat)
end

function KeyboardController.keyReleased(key, scancode)
  iterate("key_released", key, scancode)
end

function KeyboardController.textInput(text)
  iterate("text_input", text)
end
