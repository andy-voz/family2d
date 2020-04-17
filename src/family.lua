-- Getting folder that contains our src
FAMILY = FAMILY or (...):match("(.-)[^%/%.]+$")

function recursiveEnumerate(folder, file_consumer)
  local lfs = love.filesystem
  local filesTable = lfs.getDirectoryItems(folder)
  for i,v in ipairs(filesTable) do
    local file = folder.."/"..v
    local info = lfs.getInfo(file)
    if info.type == "file" then
      file_consumer(file)
    elseif info.type == "directory" then
      recursiveEnumerate(file, file_consumer)
    end
  end
end

function require_family()
  print("Require FAMILY")
  local files = recursiveEnumerate(string.sub(FAMILY, 1, #FAMILY - 1), function(file)
    if string.find(file, "family.lua") then return end

    print("Require "..file)
    local name = string.sub(file, 1, #file - 4)
    require(name)
  end)
end

