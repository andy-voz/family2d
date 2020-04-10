local family_path = family_path or (...):match("(.-)[^%/%.]+$")
require(family_path.."node")

function ImageNode(path)
  self = Node()

  local image = nil

  function self.load()
    image = love.graphics.newImage(path)
  end

  function self.onDraw()
    love.graphics.draw(image)
  end

  function self.getImageWidth()
    return image == nil and 0 or image:getWidth()
  end

  function self.getImageHeight()
    return image == nil and 0 or image:getHeight()
  end

  return self
end
