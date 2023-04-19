local ecs = require "ecs"

ecs.new_component("transform", {
    x = 0,
    y = 0,
    rotation = 0,
    scale_x = 1,
    scale_y = 1,
})

ecs.new_component("health", {
    current = 100,
    max = 100,
})

ecs.new_startup_system({ "transform", "health" }, function(ent)
    local transform = ent.transform
    local health = ent.health

    transform.x = 100
    transform.y = 100

    health.max = 50
    health.current = 50
end)

ecs.new_repeating_system("transform", function(ent)
    ent.transform.x = ent.transform.x + 2
end)

ecs.new_repeating_system("health", function(ent)
    local health = ent.health

    health.current = health.current - 1
    if health.current <= 0 then
        ecs.stop()
    end
end)

ecs.new_repeating_system({ "transform", "health" }, function(ent)
    print("x:      " .. ent.transform.x)
    print("hp:     " .. ent.health.current)
    print("hp max: " .. ent.health.max)
end)

ecs.new_entity({ "transform", "health" })

ecs.run()