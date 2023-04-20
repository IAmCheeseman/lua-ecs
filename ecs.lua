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

        -- Flushing system queues
        flush_queues(ecs.startup_systems)
        flush_queues(ecs.repeating_systems)
        
        -- Flushing global queues
        for i = #ecs.queues.add, 1, -1 do
            local entity = ecs.queues.add[i]
            ecs.entities:add(entity)
            table.remove(ecs.queues.add, i)
        end

        for i = #ecs.queues.remove, 1, -1 do
            local entity = ecs.queues.remove[i]
            ecs.entities:remove(entity)
            table.remove(ecs.queues.remove, i)
        end

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