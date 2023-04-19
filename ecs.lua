local ecs = require "ecs_data"

local function run_system(system)
    for _, entity in ipairs(system.entities) do
        system.system(entity)
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
    stop = stop,
    entity = require "entity",
    run_repeating = run_repeating,
    component = require "component",
    system = require "system",
}