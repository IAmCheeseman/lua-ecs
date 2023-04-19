local ecs = require "ecs"

ecs.new_component("transform", {
    position = { x = 0, y = 0 },
    scale = { x = 0, y = 0 },
    rotation = 0,
})

ecs.new_startup_system("transform", function(ent)
    ent.transform.position.x = math.random(100)
    print(ent.transform.position.x)
end)

ecs.new_repeating_system("transform", function(ent)
    print(ent.transform.position.x)
end)

ecs.new_entity({ "transform" })
ecs.new_entity({ "transform" })

ecs.run()