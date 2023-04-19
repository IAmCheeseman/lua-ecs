local ecs = require "ecs_data"

local function new(name, component)
    ecs.components[name] = component
end

return {
    new = new,
}