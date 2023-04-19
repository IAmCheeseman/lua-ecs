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

local ecs = {
    should_run = true,
    entity_set = {},
    entities = {},
    components = {},
    startup_systems = {},
    repeating_systems = {},
    deep_copy = deep_copy,
    entity_has_components = entity_has_components,
}

return ecs