local ecs = require "ecs_data"

--- Creates a new component
---@param name string The name of the component
---@param component table The data of a component
local function new(name, component)
    ecs.components[name] = component
end

return {
    new = new,
}