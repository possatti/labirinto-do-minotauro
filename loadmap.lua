-- Load the map to a matrix (map[row][col])
function loadmap(file_path)
  print(file_path)
  rows = {}
  for line in io.lines(file_path) do
    cols = {}
    line:gsub(".", function(c) table.insert(cols, c) end)
    rows[#rows + 1] = cols
  end
  return rows
end

-- Find a certain character in the map.
function findchar(map, char)
  for r,row in ipairs(map) do
    for c,char in ipairs(row) do
      if char == char then
        return r, c
      end
    end
  end
end

-- Find where the player starts.
function findstart(map)
  for r,row in ipairs(map) do
    for c,char in ipairs(row) do
      if char == 'S' then
        return r, c
      end
    end
  end
end
-- map = loadmap('maps/20x20-slim.txt')
-- print(map[2][2])

