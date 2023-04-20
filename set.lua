local function add(self, variable)
    table.insert(self.dense, variable)
    self.sparse[variable] = #self.dense
end

local function get(self, variable)
    return self.dense[self.sparse[variable]]
end

local function remove(self, variable)
    local index = self.sparse[variable]
    local new = self.dense[#self.dense]
    -- Swapping the removed element with the last element in the array
    self.dense[index] = new
    self.sparse[new] = index
    -- Removing
    table.remove(self.dense, #self.dense)
    self.sparse[variable] = nil
end

local function has(self, variable)
    return self.sparse[variable] ~= nil
end

local function iterate(self)
    return ipairs(self.dense)
end

local function new()
    return setmetatable({
        sparse = {},
        dense = {},
        add = add,
        get = get,
        remove = remove,
        has = has,
        iterate = iterate,
    }, {
        __index = get,
        __len = function(t)
            return #t.dense
        end
    })
end

return {
    new = new,
}