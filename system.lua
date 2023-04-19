local ecs = require "ecs_data"

--- Adds the correct entities to a system
---@param system table The system to entities to.
local function add_entities_to_system(system)
    for _, entity in ipairs(ecs.entities) do
        if ecs.entity_has_components(entity, system.components) then
            table.insert(system.entities, entity)
            system.entity_set[entity] = #system.entities
        end
    end
end

--- Transforms a component into a table of components if there's only one component
---@param components string|table The components
---@return table components The transformed components
local function get_system_components(components)
    if type(components) == "string" then
        if ecs.components[components] then
            return { components }
        end
        error("`" .. components .. "` is not a valid component")
    end
    return components
end

--- Verifies that a system's components are defined. Errors if they're not
---@param components table The components
local function verify_system_components(components)
    for _, v in ipairs(components) do
        if not ecs.components[v] then
            error("`" .. v .. "` is not a valid component")
        end
    end
end

--- Creates a system table
---@param system function The function
---@param components table The components
---@return table system The system table
local function create_system(system, components)
    local system_table = { system = system, components = components, entity_set = {}, entities = {} }
    add_entities_to_system(system_table)
    return system_table
end

--- Create a new startup system; one that runs once before repeating systems
---@param components string|table The components needed for this system to run
---@param system function The function to run on the components
local function new_startup_system(components, system)
    components = get_system_components(components)
    verify_system_components(components)
    local system_table = create_system(system, components)
    table.insert(ecs.startup_systems, system_table)
end

--- Create a new repeating system; one that runs every frame
---@param components string|table The components needed for this system to run
---@param system function The function to run on the components
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