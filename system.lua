local ecs = require "ecs_data"

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

local function new_startup_system(components, system)
    components = get_system_components(components)
    verify_system_components(components)
    table.insert(ecs.startup_systems, { system = system, components = components })
end

local function new_repeating_system(components, system)
    components = get_system_components(components)
    verify_system_components(components)
    table.insert(ecs.repeating_systems, { system = system, components = components })
end

return {
    startup = new_startup_system,
    repeating = new_repeating_system,
}