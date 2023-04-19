local ecs = require "ecs"

ecs.new_component("transform", {
    position = { x = 0, y = 0 },
    scale = { x = 0, y = 0 },
    rotation = 0,
})

ecs.new_component("player_tag", {})

ecs.new_entity_type("player", { "player_tag", "transform" })
ecs.new_entity("player")

ecs.new_startup_system("transform", function(ent)
    ent.transform.position.x = math.random(100)
    print(ent.transform.position.x)
end)

ecs.new_repeating_system("transform", function(ent)
    ent.transform.rotation = ent.transform.rotation + 1
    if ent.transform.rotation > 360 then
        ent.transform.rotation = 0
    end
end)

ecs.new_repeating_system("player", function(ent)
    ent.transform.position.x = ent.transform.position.x + 1
    ent.transform.position.y = ent.transform.position.y + 1
    print(ent.transform.position.x, ent.transform.position.y, ent.transform.rotation)
end)

ecs.run()