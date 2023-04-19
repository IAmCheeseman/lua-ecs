local function deep_copy(tab)
    local copy = {}
    for k, v in pairs(tab) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

local ecs = {
    should_run = true,
    entities = {},
    components = {},
    startup_systems = {},
    repeating_systems = {},
    deep_copy = deep_copy,
}

return ecs