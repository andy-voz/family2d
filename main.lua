require "src.family"
require_family()

local root = nil

local tapped_string = ""

function love.load()
  love.keyboard.setKeyRepeat(true)
  root = Node()

  root
    .setRect(50, 50, 250, 250)
    .setScale(2)
    .setDebug(true)
    .setBackgroundColor("#B0D7FFFF")

  local callback = function(input_event)
    tapped_string = input_event.type.." root"
    return true
  end
  root.addInputProcessor("pressed", callback)

  local image = love.graphics.newImage("res/image.png")
  local font = love.graphics.newFont("res/font.ttf", 50)

  local list = List()
    .setRect(10, 50, 100, 150)
    .setBackgroundColor("#AA95E8FF")

  for i = 0, 10 do
    local node1 = Node()
      .setRect(0, 0, 100, 30)

    local node2 = Image(image)
      .setRect(75, 5, 20, 20)
      .setMode("ending", "center", "proportional")

    node1.addChild(node2)

    local node3 = Text("List entry", font)
      .setRect(10, 5, 60, 20)
      .setVirtualHeight(12)
      .setTintColor(0, 0, 0, 1)
      .setMode("center", "center")

    node1.addChild(node3)
    list.addChild(node1)
  end

  root.addChild(list)

  local input = Input("Input Box", font)
    .setRect(10, 10, 100, 20)
    .setBackgroundColor("#95E8D1FF")
    .setTintColor(0, 0, 0, 1)
    .setMax(60)
    .setMode("start", "ending", "none", true)
    .setVirtualHeight(12)

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
