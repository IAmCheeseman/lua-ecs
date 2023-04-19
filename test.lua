local ecs = require "ecs"

ecs.new_component("transform", {
    position = { x = 0, y = 0 },
    scale = { x = 0, y = 0 },
    rotation = 0,
})

ecs.new_component("player", {})

ecs.new_startup_system("transform", function(ent)
    ent.transform.position.x = math.random(100)
    print(ent.transform.position.x)
end)

ecs.new_repeating_system({ "player", "transform" }, function(ent)
    ent.transform.position.x = ent.transform.position.x + 1
    ent.transform.position.y = ent.transform.position.y + 1
    print(ent.transform.position.x, ent.transform.position.y)
end)

ecs.new_entity_type("player", { "player", "transform" })
ecs.new_entity("player")

ecs.run()