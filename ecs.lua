local ecs = require "ecs_data"

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

local function run_startup()
    for _, system in ipairs(ecs.startup_systems) do
        run_system(system)
    end
end

local function run_repeating()
    for _, system in ipairs(ecs.repeating_systems) do
        run_system(system)
    end
end

local function run_all()
    run_startup()

    if #ecs.repeating_systems == 0 then
        return
    end

    while ecs.should_run do
        run_repeating()
    end
end

local function stop()
    ecs.should_run = false
end

return {
    run_all = run_all,
    run_startup = run_startup,
    run_repeating = run_repeating,
    stop = stop,
    entity = require "entity",
    component = require "component",
    system = require "system",
}