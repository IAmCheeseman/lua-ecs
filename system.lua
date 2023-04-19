local ecs = require "ecs_data"

local function add_entities_to_system(system)
    for _, entity in ipairs(ecs.entities) do
        if ecs.entity_has_components(entity, system.components) then
            table.insert(system.entities, entity)
            system.entity_set[entity] = #system.entities
        end
    end
end

local function get_system_components(components)
    if type(components) == "string" then
        if ecs.components[components] then
            return { components }
        end
        error("`" .. components .. "` is not a valid component")
    end
    return components
end

local function verify_system_components(components)
    for _, v in ipairs(components) do
        if not ecs.components[v] then
            error("`" .. v .. "` is not a valid component")
        end
    end
end

local function create_system(system, components)
    local system_table = { system = system, components = components, entity_set = {}, entities = {} }
    add_entities_to_system(system_table)
    return system_table
end

local function new_startup_system(components, system)
    components = get_system_components(components)
    verify_system_components(components)
    local system_table = create_system(system, components)
    table.insert(ecs.startup_systems, system_table)
end

local function new_repeating_system(components, system)
    components = get_system_components(components)
    verify_system_components(components)
    local system_table = create_system(system, components)
    table.insert(ecs.repeating_systems, system_table)
end

return {
    startup = new_startup_system,
    repeating = new_repeating_system,
}