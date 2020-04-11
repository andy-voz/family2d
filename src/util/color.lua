ColorUtil = {}

function ColorUtil.random()
  return Color(math.random(), math.random(), math.random(), 1)
end

function Color(r, g, b, a)
  local self = {}

  function self.set(r, g, b, a)
    self.r = r or 0
    self.g = g or 0
    self.b = b or 0
    self.a = a or 0
  end

  self.set(r, g, b, a)

  return self
end
