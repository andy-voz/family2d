require(FAMILY.."nodes.node")

function Grid(rows, columns, cell_x, cell_y, margin_x, margin_y)
  local self = Node()

  local rows = rows or 0
  local columns = columns or 0

  local cell_x = cell_x or 0
  local cell_y = cell_y or 0

  local margin_x = margin_x or 0
  local margin_y = margin_y or 0

  local need_update = false

  function self.updateFromIndex(index)
    local index = index or 0

    for i = index, #self.getChildren() do
      column = math.fmod(i, columns)
      if column == 0 then column = columns end
      column = column - 1
      local x = column * (cell_x + margin_x)

      row = math.floor((i - 1) / columns)
      local y = row * (cell_y + margin_y)
      local width = cell_x
      local height = cell_y
      self.getChildren()[i].setRect(x, y, width, height)
    end
  end

  local super_update = self.update
  function self.update(dt)
    super_update(dt)

    if not need_update then return end

    self.setRect(self.getRect().x, self.getRect().y, 0, 0)
    self.updateFromIndex(0)
    need_update = false
  end

  function self.onChildAdd(index)
    self.updateFromIndex(index)
  end

  function self.onChildRemove(index)
    self.updateFromIndex(index)
  end

  local super_setRect = self.setRect
  function self.setRect(x, y, width, height)
    local width = cell_x * columns + margin_x * (columns - 1)
    local height = cell_y * rows + margin_y * (rows - 1)
    super_setRect(x, y, width, height)

    return self
  end

  function self.setRows(new_rows)
    rows = new_rows
    need_update = true
    return self
  end

  function self.getRows()
    return rows
  end

  function self.setColumns(new_columns)
    columns = new_columns
    need_update = true
    return self
  end

  function self.getColumns()
    return columns
  end

  function self.setMarginX(new_margin)
    margin_x = new_margin
    need_update = true
    return self
  end

  function self.getMarginX()
    return margin_x
  end

  function self.setMarginY(new_margin)
    margin_y = new_margin
    need_update = true
    return self
  end

  function self.getMarginY()
    return margin_y
  end

  function self.setCellX(new_cell_x)
    cell_x = new_cell_x
    need_update = true
    return self
  end

  function self.getCellX()
    return cell_x
  end

  function self.setCellY(new_cell_y)
    cell_y = new_cell_y
    need_update = true
    return self
  end

  function self.getCellY()
    return cell_y
  end

  self.setRect(self.getRect().x, self.getRect().y, 0, 0)

  return self
end
