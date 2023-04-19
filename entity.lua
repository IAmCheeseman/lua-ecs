local ecs = require "ecs_data"

--- Removes an entity from systems
---@param systems table Either `ecs.startup_systems` or `ecs.repeating_systems`
---@param entity table The entity
local function remove_entity_from_systems(systems, entity)
    for _, system in ipairs(systems) do
        local index = system.entity_set[entity]
        if index then
            local new_entity = system.entities[#system.entities]
            -- Swapping
            system.entities[index] = new_entity
            system.entity_set[new_entity] = index
            -- Removing
            table.remove(system.entities, #system.entities)
            system.entity_set[entity] = nil
        end
    end
end

--- Removes the entity
---@param entity table The entity
local function remove_entity(entity)
    remove_entity_from_systems(ecs.startup_systems, entity)
    remove_entity_from_systems(ecs.repeating_systems, entity)

    local index = ecs.entity_set[entity]
    local new_entity = ecs.entities[#ecs.entities]
    -- Swapping
    ecs.entities[index] = new_entity
    ecs.entity_set[new_entity] = index
    -- Removing
    table.remove(ecs.entities, #ecs.entities)
    ecs.entity_set[entity] = nil
end

--- Add an entity to a system
---@param systems table `ecs.startup_systems` or `ecs.repeating_systems`
---@param entity table The entity
local function add_entity_to_system(systems, entity)
    for _, system in ipairs(systems) do
        if ecs.entity_has_components(entity, system.components) then
            table.insert(system.entities, entity)
            system.entity_set[entity] = #system.entities
        end
    end
end

--- Adds the entity to systems
---@param entity table The entity
local function add_entity_to_systems(entity)
    add_entity_to_system(ecs.startup_systems, entity)
    add_entity_to_system(ecs.repeating_systems, entity)
end

--- Creates a new entity
---@param components table The components
local function new(components)
    local entity = {
        remove = remove_entity,
    }

    for _, v in ipairs(components) do
        local component = ecs.components[v]
        if not component then
            error("`" .. v .. "` is not a valid component")
        end
        entity[v] = ecs.deep_copy(component)
    end

    add_entity_to_systems(entity)
    table.insert(ecs.entities, entity)
    ecs.entity_set[entity] = #ecs.entities
end

return {
    new = new,
}