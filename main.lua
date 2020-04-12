require "src/family"
require(family_path.."nodes/node")
require(family_path.."nodes/image")
require(family_path.."nodes/grid")

local root = nil

local tapped_string = ""

function love.load()
  root = Node()

  root.setRect(100, 100, 300, 300)
  root.setDebug(true)
  root.setScale(1.5)
  root.setBackgroundColor(0.2, 0.2, 0.2, 1)

  local callback = function(x, y)
    tapped_string = "root"
  end
  root.setOnTap(callback)

  local child1 = Node()
  child1.setOnTap(function(x, y)
    tapped_string = "child 1"
  end)
  child1.setRect(20, 20, 30, 30)
  root.addChild(child1)

  local child2 = Image('res/image.png')
  child2.setOnTap(function(x, y)
    tapped_string = "child 2"
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
    grid_item.setOnTap(function(x, y)
      tapped_string = "Grid item "..tostring(i)
    end)
    grid.addChild(grid_item)
  end
  grid.setBackgroundColor(0.5, 0.8, 0.1, 1)
  root.addChild(grid)
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
  root.tap(x, y)
end
