require(FAMILY.."nodes.node")

function Grid(rows, columns, cell_x, cell_y, margin_x, margin_y)
  local self = Node()

  local rows = rows or 0
  local columns = columns or 0

  local cell_x = cell_x or 0
  local cell_y = cell_y or 0

  local margin_x = margin_x or 0
  local margin_y = margin_y or 0

  local super_load = self.load
  function self.load(data)
    super_load(data)

    local grid_data = data.grid
    if grid_data ~= nil then
      rows = grid_data.rows or rows
      columns = grid_data.columns or columns

      cell_x = grid_data.cell_x or cell_x
      cell_y = grid_data.cell_y or cell_y

      margin_x = grid_data.margin_x or margin_x
      margin_y = grid_data.margin_y or margin_y
    end

    return self
  end

  function self.updateFromIndex(index)
    local index = index or 1

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

  function self.onUpdate(dt)
    self.setRect(self.getRect().x, self.getRect().y, 0, 0)
    self.updateFromIndex()
    self.updateTransform()
  end

  function self.onChildAdd(index)
    self.setDirty()
  end

  function self.onChildRemove(index)
    self.setDirty()
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
    self.setDirty()
    return self
  end

  function self.getRows()
    return rows
  end

  function self.setColumns(new_columns)
    columns = new_columns
    self.setDirty()
    return self
  end

  function self.getColumns()
    return columns
  end

  function self.setMarginX(new_margin)
    margin_x = new_margin
    self.setDirty()
    return self
  end

  function self.getMarginX()
    return margin_x
  end

  function self.setMarginY(new_margin)
    margin_y = new_margin
    self.setDirty()
    return self
  end

  function self.getMarginY()
    return margin_y
  end

  function self.setCellX(new_cell_x)
    cell_x = new_cell_x
    self.setDirty()
    return self
  end

  function self.getCellX()
    return cell_x
  end

  function self.setCellY(new_cell_y)
    cell_y = new_cell_y
    self.setDirty()
    return self
  end

  function self.getCellY()
    return cell_y
  end

  self.setRect(self.getRect().x, self.getRect().y, 0, 0)

  return self
end

NodeTypes.Grid = Grid
