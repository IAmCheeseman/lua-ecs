local sparse_set = require "sparse_set"

--- Performs a deep copy on a table
---@param tab table The table to copy
---@return table copy The copied table
local function deep_copy(tab)
    local copy = {}
    for k, v in pairs(tab) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--- Checks if an entity has certain components
---@param entity table The entity to check
---@param components table The components to check
---@return boolean has_components If the components exist
local function entity_has_components(entity, components)
    for _, component in ipairs(components) do
        if not entity[component] then
            return false
        end
    end
    return true
end

local function run_on_all_systems(self, func, args)
    func(self.startup_systems, table.unpack(args))
    func(self.repeating_systems, table.unpack(args))
    func(self.shutdown_systems, table.unpack(args))
end

local ecs = {
    should_run = true,
    entities = sparse_set.new(),
    components = {},
    startup_systems = {},
    repeating_systems = {},
    shutdown_systems = {},
    queues = {
        add = {},
        remove = {},
    },
    deep_copy = deep_copy,
    entity_has_components = entity_has_components,
    run_on_all_systems = run_on_all_systems,
}

return ecs