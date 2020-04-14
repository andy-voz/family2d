require "src.family"
require(FAMILY.."nodes.node")
require(FAMILY.."nodes.image")
require(FAMILY.."nodes.grid")
require(FAMILY.."nodes.text")
require(FAMILY.."input.event")

local root = nil

local tapped_string = ""

function love.load()
  root = Node()

  root
    .setRect(100, 100, 300, 300)
    .setScale(1.7)
    .setDebug(true)
    .setBackgroundColor(0.2, 0.2, 0.2, 1)

  local callback = function(x, y, input_event)
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
      .setMode("center_proportional")

    node1.addChild(node2)
    grid.addChild(node1)
  end

  root.addChild(grid)
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
  root.input(MouseEvent("pressed", x, y, button, istouch, presses))
end

function love.mousereleased(x, y, button, istouch, presses)
  root.input(MouseEvent("released", x, y, button, istouch, presses))
end

function love.mousemoved(x, y, dx, dy, istouch)
  root.input(MouseMoveEvent("moved", x, y, dx, dy, istouch))
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  root.input(TouchEvent("pressed", id, x, y, dx, dy, pressure))
end

function love.touchreleased(id, x, y, dx, dy, pressure)
  root.input(TouchEvent("released", id, x, y, dx, dy, pressure))
end

function love.touchmoved( id, x, y, dx, dy, pressure )
  root.input(TouchEvent("moved", id, x, y, dx, dy, pressure))
end
