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