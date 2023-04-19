local ecs = {
    should_run = true,
    entities = {},
    components = {},
    startup_systems = {},
    repeating_systems = {},
}

local function deep_copy(tab)
    local copy = {}
    for k, v in pairs(tab) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local function entity_has_components(entity, components)
    local count = 0
    for _, component in ipairs(components) do
        for entity_component, _ in pairs(entity) do
            if entity_component == component then
                count = count + 1
            end
        end
    end
    return count == #components
end

local function run_system(system)
    for _, entity in pairs(ecs.entities) do
        if entity_has_components(entity, system.components) then
            system.system(entity)
        end
    end
end

local function run()
    for _, system in ipairs(ecs.startup_systems) do
        run_system(system)
    end

    if #ecs.repeating_systems == 0 then
        return
    end

    while ecs.should_run do
        for _, system in ipairs(ecs.repeating_systems) do
            run_system(system)
        end
    end
end

local function stop()
    ecs.should_run = false
end

local function new_entity(components)
    local entity = {}

    for _, v in ipairs(components) do
        local component = ecs.components[v]
        entity[v] = deep_copy(component)
    end

    table.insert(ecs.entities, entity)
end

local function new_component(name, component)
    ecs.components[name] = component
end

local function new_startup_system(components, system)
    if type(components) == "string" then
        components = { components }
    end
    table.insert(ecs.startup_systems, { system = system, components = components })
end

local function new_repeating_system(components, system)
    if type(components) == "string" then
        components = { components }
    end
    table.insert(ecs.repeating_systems, { system = system, components = components })
end

return {
    run = run,
    stop = stop,
    new_entity = new_entity,
    new_component = new_component,
    new_startup_system = new_startup_system,
    new_repeating_system = new_repeating_system,
}