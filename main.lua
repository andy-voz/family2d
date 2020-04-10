require 'src/node'
require 'src/imagenode'

local root = nil

local tapped_string = ""

function love.load()
  root = Node()

  root.setRect(Rect(200, 200, 100, 100))
  root.setDebug(true)
  root.setScale(2)
	root.setRotation(1.57)
	root.setOrigin(50, 50)

	callback = function(x, y)
    tapped_string = "root"                    
	end
	root.setOnTap(callback)

	child1 = Node()
	child1.setOnTap(function(x, y)
    tapped_string = "child 1"
	end)
  child1.setRect(Rect(20, 20, 30, 30))
	root.addChild(child1)

	child2 = ImageNode('res/image.png')
  child2.setOnTap(function(x, y)
    tapped_string = "child 2"
  end)
  child2.load()
  child2.setRect(Rect(50, 50, child2.getImageWidth(), child2.getImageHeight()))
  root.addChild(child2)
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
