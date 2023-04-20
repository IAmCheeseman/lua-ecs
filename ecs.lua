local ecs = require "ecs_data"
local sys = require "system"

local flush_queues = sys.flush_queues
-- hack to remove access in the api
sys.flush_queues = nil

--- Stops running the ecs
local function stop()
    ecs.should_run = false
end

local function run_system(system)
    for _, entity in system.entities:iterate() do
        system.system(entity)
    end
end

--- Runs every system
local function run()
    flush_queues(ecs.startup_systems)

    if #ecs.repeating_systems == 0 then
        return
    end

    while ecs.should_run do
        for _, system in ipairs(ecs.repeating_systems) do
            run_system(system)
        end
        flush_queues(ecs.startup_systems)
        flush_queues(ecs.repeating_systems)
        if #ecs.entities == 0 then
            stop()
        end
    end
end

return {
    run = run,
    stop = stop,
    entity = require "entity",
    component = require "component",
    system = sys,
}