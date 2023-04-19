local ecs = require "ecs"

ecs.component.new("transform", {
    position = { x = 0, y = 0 },
    scale = { x = 0, y = 0 },
    rotation = 0,
})

ecs.component.new("player_tag", {})

local player = { "player_tag", "transform" }
ecs.entity.new(player)
ecs.entity.new(player)

ecs.system.startup("transform", function(ent)
    ent.transform.position.x = math.random(100)
    print(ent.transform.position.x)
end)

ecs.system.repeating("transform", function(ent)
    ent.transform.rotation = ent.transform.rotation + 1
    if ent.transform.rotation > 360 then
        ent.transform.rotation = 0
    end
end)

ecs.system.repeating(player, function(ent)
    ent.transform.position.x = ent.transform.position.x + 1
    ent.transform.position.y = ent.transform.position.y + 1
    print(ent.transform.position.x, ent.transform.position.y, ent.transform.rotation)
end)

ecs.run_all()