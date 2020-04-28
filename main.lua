require "src.family"
require_family()

local root = nil

local tapped_string = ""

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.keyboard.setKeyRepeat(true)
  root = Node()

  root
    .setRect(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    .setScale(1)
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
    .setRect(0, 50, 100, 150)
    .setAnchor("center", "center")
    .setBackgroundColor("#AA95E8FF")
    .setScale(3)
    .setOrigin(50, 75)

  for i = 0, 10 do
    local node1 = TextButton("Click Me!", font)
      .setRect(0, 0, 100, 30)
      .addStateImage("normal", love.graphics.newImage("res/b_normal.png"))
      .addStateImage("pressed", love.graphics.newImage("res/b_pressed.png"))
      .addStateImage("disabled", love.graphics.newImage("res/b_disabled.png"))
      .setThin(true)
      .setMode("center", "center", "fill")
      .addOnClick(function()
        print(tostring(i).." Clicked")
      end)

    node1.getTextNode().setVirtualHeight(12)

    if i == 4 then
      node1.setEnabled(false)
    end
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
    .setScale(3)

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
