local ecs = require "ecs_data"

local function new(components)
    local entity = {}

    for _, v in ipairs(components) do
        local component = ecs.components[v]
        if not component then
            error("`" .. v .. "` is not a valid component")
        end
        entity[v] = ecs.deep_copy(component)
    end

    table.insert(ecs.entities, entity)
end

return {
    new = new,
}