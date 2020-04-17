ProcessedController = {}

local nodes = {}

function ProcessedController.addNode(node)
  table.insert(nodes, node)
end

function ProcessedController.removeNode(node)
  local index = nil
  for i, n in ipairs(nodes) do
    if node == n then
      index = i
      break
    end
  end

  if index ~= nil then table.remove(nodes, index) end
end

function ProcessedController.processed(node, event)
  for _, n in ipairs(nodes) do
    local callback = n.getController()["processed"]
    if callback ~= nil then
      callback(node, event)
    end
  end
end
