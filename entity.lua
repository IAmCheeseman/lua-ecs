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
    ecs:run_on_all_systems(remove_entity_from_systems, { entity })

    table.insert(ecs.queues.remove, entity)
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
    ecs:run_on_all_systems(add_entity_to_system, { entity })
end

--- Creates a new entity
---@param components table The components
local function new(components)
    local entity = {}

    for k, v in pairs(components) do
        local overrides = true
        local name = k
        if type(k) == "number" then
            overrides = false
            name = v
        end

        local component = ecs.components[name]
        if not component then
            error("`" .. name .. "` is not a valid component")
        end
        entity[name] = ecs.deep_copy(component)

        if overrides then
            for property, override in pairs(v) do
                entity[name][property] = override
            end
        end
    end
    entity.remove = remove_entity

    add_entity_to_systems(entity)
    table.insert(ecs.queues.add, entity)
    return entity
end

return {
    new = new,
}