local family_path = family_path or (...):match("(.-)[^%/%.]+$")
require(family_path.."node")

function Grid(rows, columns, margin_x, margin_y)
  self = Node()
 
  local rows = rows or 0
  local columns = columns or 0

  local margin_x = margin_x or 0
  local margin_y = margin_y or 0

  local space_x = 0
  local space_y = 0

  function self.onChildAdd(index)
    self.updateFromIndex(index)
  end

  function self.onChildRemove(index)
    salf.updateFromIndex(index)
  end

  function self.updateFromIndex(index)
    local index = index or 0

    for i = index, #self.getChildren() do
      rect = self.getChildren()[i].getRect()
      
      column = math.fmod(i, columns)
      if column == 0 then column = columns end
      column = column - 1
      rect.x = column * (space_x + margin_x)
      
      row = math.floor(i / rows)
      rect.y = row * (space_y + margin_y)
      rect.width = space_x
      rect.height = space_y
      self.getChildren()[i].setRect(rect)
      print(rect)
    end
  end 

  function self.calcSpaceX()
    space_x = (self.getRect().width - margin_x * (columns - 1)) / columns
  end

  function self.calcSpaceY()
    space_y = (self.getRect().height - margin_y * (rows - 1)) / rows
  end
  
  self.calcSpaceX()
  self.calcSpaceY()

  super_setRect = self.setRect
  function self.setRect(rect)
    super_setRect(rect)

    self.calcSpaceX()
    self.calcSpaceY()
  end

  function self.setRows(new_rows)
    rows = new_rows
    self.calcSpaceY()
  end

  function self.getRows()
    return rows
  end

  function self.setColumns(new_columns)
    columns = new_columns
    self.calcSpaceX()
  end

  function self.getColumns()
    return columns
  end

  function self.setMarginX(new_margin)
    margin_x = new_margin
    self.calcSpaceX()
  end

  function self.getMarginX()
    return margin_x
  end

  function self.setMarginY(new_margin)
    margin_y = new_margin
    self.calcSpaceY()
  end

  function self.getMarginY()
    return margin_y
  end

  return self
end
