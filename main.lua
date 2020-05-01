require "src.family"
json = require "lib.rxi-json.json"
require_family()

local root = nil

local tapped_string = ""

function decode(path)
  local file = love.filesystem.newFile(path)
  file:open("r")
  local result = json.decode(file:read())
  file:close()

  return result
end

function load_node(data)
  local node = NodeTypes[data.type]()
  return node.load(data)
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.keyboard.setKeyRepeat(true)

  root = load_node(decode("res/nodes/main.json"))
    .setRect(0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  local list = root.findById("list")
  local list_el_data = decode("res/nodes/text_button.json")
  for i = 0, 10 do
    local list_el = load_node(list_el_data)
      .addOnClick(function()
        print(tostring(i).." Clicked")
      end)

    if i == 4 then
      list_el.setEnabled(false)
    end
    list.addChild(list_el)
  end

  local grid = root.findById("grid")
  local grid_el_data = decode("res/nodes/grid_item.json")
  for i = 0, 5 do
    local grid_el = load_node(grid_el_data)
    grid.addChild(grid_el)
  end

  local input = root.findById("input")

  input.setOnFocus(function()
    input.setBackgroundColor("#9CFF92FF")
  end)

  input.setOnFocusLost(function()
    input.setBackgroundColor("#95E8D1FF")
  end)

  input.setOnConfirm(function()
    input.setFocused(false)
    print(input.getText())
  end)

  root.findById("time_but")
    .addOnClick(function()
      root.findById("time_text").setText(tostring(os.date("%D %I:%M:%S%p", os.time() - 60 * 60)))
    end)
end

function love.resize(width, height)
  root.setRect(0, 0, width, height)
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.push()
  root.draw()
  love.graphics.pop()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.print(tapped_string)
end

function love.update(dt)
  root.update(dt)
end

function love.mousepressed(x, y, button, istouch, presses)
  tapped_string = ""
  local event = MouseEvent("pressed", x, y, button, istouch, presses)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end

function love.mousereleased(x, y, button, istouch, presses)
  local event = MouseEvent("released", x, y, button, istouch, presses)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end

function love.mousemoved(x, y, dx, dy, istouch)
  local event = MouseMoveEvent("moved", x, y, dx, dy, istouch)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end

--[[function love.touchpressed(id, x, y, dx, dy, pressure)
  local event = TouchEvent("pressed", id, x, y, dx, dy, pressure)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  local event = TouchEvent("released", id, x, y, dx, dy, pressure)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
  local event = TouchEvent("moved", id, x, y, dx, dy, pressure)
  local processed = root.input(event)
  ProcessedController.processed(processed, event)
end]]--

function love.keypressed(key, scancode, isRepeat)
  KeyboardController.keyPressed(key, scancode, isRepeat)
end

function love.keyreleased(key, scancode)
  KeyboardController.keyReleased(key, scancode)
end

function love.textinput(text)
  KeyboardController.textInput(text)
end
