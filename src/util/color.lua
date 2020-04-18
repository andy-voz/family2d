ColorUtil = {}

function ColorUtil.random()
  return Color(math.random(), math.random(), math.random(), 1)
end

function Color(r, g, b, a)
  local self = {}

  function self.set(r, g, b, a)
    if type(r) == "string" then
      self.r, self.g, self.b, self.a = self.hexToRGBA(r)
    else
      self.r = r or 0
      self.g = g or 0
      self.b = b or 0
      self.a = a or 0
    end
  end

  function self.hexToRGBA(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)) / 255, tonumber("0x"..hex:sub(3,4)) / 255, tonumber("0x"..hex:sub(5,6)) / 255, tonumber("0x"..hex:sub(7,8)) / 255
  end

  self.set(r, g, b, a)

  return self
end
