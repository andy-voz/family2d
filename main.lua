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

  root.setRect(100, 100, 300, 300)
  root.setDebug(true)
  root.setScale(1.5)
  root.setBackgroundColor(0.2, 0.2, 0.2, 1)

  local callback = function(x, y, input_event)
    tapped_string = input_event.type.." root"
    return true
  end
  root.setPressed(callback)

  local child1 = Node()
  child1.setReleased(function(x, y, input_event)
    tapped_string = input_event.type.." child 1"
    return true
  end)
  child1.setRect(20, 20, 30, 30)
  root.addChild(child1)

  local child2 = Image('res/image.png')
  child2.setPressed(function(x, y, input_event)
    tapped_string = input_event.type.." child 2"
    return true
  end)
  child2.load()
  child2.setRect(75, 100, 50, 100)
  child2.setTintColor(0, 1, 1, 0.5)
  child2.setMode("fill")
  child2.setRotation(1.2)
  child2.setOrigin(25, 50)
  root.addChild(child2)

  local grid = Grid(3, 4, 10, 5)
  grid.setRect(200, 20, 100, 100)
  for i = 0, 11 do
    local grid_item = Image("res/image.png")
    grid_item.load()
    grid_item.setMode("center_proportional")
    grid_item.setMoved(function(x, y, input_event)
      tapped_string = input_event.type.." Grid item "..tostring(i)
      return true
    end)
    grid.addChild(grid_item)
  end
  grid.setBackgroundColor(0.5, 0.8, 0.1, 1)
  root.addChild(grid)

  local text = Text("Brand New Scene Graph Library!\nWelcome to the family!!!")
  text.setRect(50, 200, 200, 100)
  text.setMode("center_proportional")
  root.addChild(text)
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.push()
  root.draw()
  love.graphics.pop()
  love.graphics.setColor(1, 0, 0, 1)
  love.graphics.print("Tapped node: "..tapped_string)
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
