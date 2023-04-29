
--- Adds a variable to the sparse set
---@param self table self
---@param variable any The variable to add
local function add(self, variable)
    table.insert(self.dense, variable)
    self.sparse[variable] = #self.dense
end

--- Gets a value from the sparse set
---@param self table self
---@param variable any The variable to get
---@return any value The value
local function get(self, variable)
    return self.dense[self.sparse[variable]]
end

--- Removes a value from the sparse set
---@param self table self
---@param variable any The value to remove
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

--- Checks if the sparse set has `variable`
---@param self table self
---@param variable any The value to check for
---@return boolean has_variable If this has `variable`
local function has(self, variable)
    return self.sparse[variable] ~= nil
end

--- `ipairs()` implementation
---@param self table self
local function iterate(self)
    return ipairs(self.dense)
end

local mt = {
    __index = get,
    __len = function(t)
        return #t.dense
    end
}
--- Creates a new sparse set
---@return table sparse_set The sparse set
local function new()
    return setmetatable({
        sparse = {},
        dense = {},
        add = add,
        get = get,
        remove = remove,
        has = has,
        iterate = iterate,
    }, mt)
end

return {
    new = new,
}
