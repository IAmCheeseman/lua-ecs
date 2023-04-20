local ecs = require "ecs_data"

--- Removes an entity from systems
---@param systems table Either `ecs.startup_systems` or `ecs.repeating_systems`
---@param entity table The entity
local function remove_entity_from_systems(systems, entity)
    for _, system in ipairs(systems) do
        if system.entities:has(entity) then
            table.insert(system.queues.remove, entity)
        end
    end
end

--- Removes the entity
---@param entity table The entity
local function remove_entity(entity)
    remove_entity_from_systems(ecs.startup_systems, entity)
    remove_entity_from_systems(ecs.repeating_systems, entity)

    ecs.entities:remove(entity)
end


--- Add an entity to a system
---@param systems table `ecs.startup_systems` or `ecs.repeating_systems`
---@param entity table The entity
local function add_entity_to_system(systems, entity)
    for _, system in ipairs(systems) do
        if ecs.entity_has_components(entity, system.components) then
            table.insert(system.queues.add, entity)
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
    local entity = {}

    for _, v in ipairs(components) do
        local component = ecs.components[v]
        if not component then
            error("`" .. v .. "` is not a valid component")
        end
        entity[v] = ecs.deep_copy(component)
    end
    entity.remove = remove_entity

    add_entity_to_systems(entity)
    ecs.entities:add(entity)
    return entity
end

return {
    new = new,
}