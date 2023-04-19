local ecs = require "ecs_data"

--- Stops running the ecs
local function stop()
    ecs.should_run = false
end

local function run_system(system)
    for _, entity in ipairs(system.entities) do
        system.system(entity)
    end
end

--- Runs the startup systems
local function run_startup()
    for _, system in ipairs(ecs.startup_systems) do
        run_system(system)
    end
end

--- Runs the repeating systems
local function run_repeating()
    for _, system in ipairs(ecs.repeating_systems) do
        run_system(system)
    end
end

--- Runs every system
local function run_all()
    run_startup()

    if #ecs.repeating_systems == 0 then
        return
    end

    while ecs.should_run do
        run_repeating()
        if #ecs.entities == 0 then
            stop()
        end
    end
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