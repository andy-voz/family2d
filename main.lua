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

function load_node(path)
  local data = decode(path)
  local node = NodeTypes[data.type]()
  return node.load(data)
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.keyboard.setKeyRepeat(true)

  local image = love.graphics.newImage("res/image.png")
  local font = love.graphics.newFont("res/font.ttf", 50)

  root = load_node("res/nodes/main.json")
  local list = root.findById("list")

  for i = 0, 10 do
    local node1 = load_node("res/nodes/text_button.json")
      .addOnClick(function()
        print(tostring(i).." Clicked")
      end)

    if i == 4 then
      node1.setEnabled(false)
    end
    list.addChild(node1)
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
