require(family_path.."nodes/node")
require(family_path.."util/color")

function ImageNode(path)
  local self = Node()

  local image = nil

  local tint_color = Color(1, 1, 1, 1)

  function self.load()
    image = love.graphics.newImage(path)
  end

  function self.onDraw()
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(tint_color.r, tint_color.g, tint_color.b, tint_color.a)
    love.graphics.draw(image)
    love.graphics.setColor(r, g, b, a)
  end

  function self.getImageWidth()
    return image == nil and 0 or image:getWidth()
  end

  function self.getImageHeight()
    return image == nil and 0 or image:getHeight()
  end

  function self.setTintColor(r, g, b, a)
    tint_color.set(r, g, b, a)
  end

  function self.getTintColor()
    return tint_color
  end

  return self
end
