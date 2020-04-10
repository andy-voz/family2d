function Rect(x, y, width, height)
  local self = {
		x = x or 0,
		y = y or 0,
		width = width or 0,
		height = height or 0
	}

  function self.contains(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height 
	end

	function self.set(x, y, width, height)
    self.x = x
		self.y = y
		self.width = width
		self.height = height
	end

	function self.copy()
    return Rect(self.x, self.y, self.width, self.height)
	end

	function self.inBounds(x, y)
    return x >= 0 and x <= self.width and y >= 0 and y <= self.height
	end

	mt = {}
	
	function mt.__tostring()
    return "X: "..tostring(self.x).." Y: "..tostring(self.y).." Width: "..tostring(self.width).." Height: "..tostring(self.height)
  end

	setmetatable(self, mt)

	return self
end
