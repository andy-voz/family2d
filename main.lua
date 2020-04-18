require "src.family"
require_family()

local root = nil

local tapped_string = ""

function love.load()
  love.keyboard.setKeyRepeat(true)
  root = Node()

  root
    .setRect(100, 100, 300, 300)
    .setScale(3)
    .setDebug(true)
    .setBackgroundColor(0.2, 0.2, 0.2, 1)

  local callback = function(input_event)
    tapped_string = input_event.type.." root"
    return true
  end
  root.setPressed(callback)

  local image = love.graphics.newImage("res/image.png")

  local grid = Grid(5, 5, 50, 30, 2, 2)
    .setRect(10, 50, 0, 0)
  for i = 0, 24 do
    local node1 = Node()
    local node2 = Image(image)
      .setRect(25, 15, 40, 20)
      .setOrigin(20, 10)
      .setMode("ending", "center", "proportional")

    node1.addChild(node2)
    grid.addChild(node1)
  end

  root.addChild(grid)

  local font = love.graphics.newFont("res/font.ttf", 50)
  local input = Input("Input Box", font)
    .setRect(10, 10, 100, 20)
    .setBackgroundColor(0.8, 0.2, 0.2, 1)
    .setMax(60)
    .setMode("start", "ending", "none", true)
    .setVirtualHeight(12)

  input.setOnFocus(function()
    input.setBackgroundColor(0.1, 0.2, 0.2, 1)
  end)

  input.setOnFocusLost(function()
    input.setBackgroundColor(0.8, 0.2, 0.2, 1)
  end)

  input.setOnConfirm(function()
    input.setFocused(false)
    print(input.getText())
  end)

  root.addChild(input)
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.push()
  root.draw()
  love.graphics.pop()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.print(tapped_string)
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
