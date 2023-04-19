local ecs = require "ecs_data"


local function add_entity_to_system(systems, entity)
    for _, system in ipairs(systems) do
        if ecs.entity_has_components(entity, system.components) then
            table.insert(system.entities, entity)
        end
    end
end

local function add_entity_to_systems(entity)
    add_entity_to_system(ecs.startup_systems, entity)
    add_entity_to_system(ecs.repeating_systems, entity)
end

local function new(components)
    local entity = {}

    for _, v in ipairs(components) do
        local component = ecs.components[v]
        if not component then
            error("`" .. v .. "` is not a valid component")
        end
        entity[v] = ecs.deep_copy(component)
    end

    add_entity_to_systems(entity)
    table.insert(ecs.entities, entity)
end

return {
    new = new,
}