--!strict
local fs = require("@lune/fs")

local function swap()
    local linker_script = fs.readFile("roblox_packages/squash.luau")

    for _, object in fs.readDir("roblox_packages/.pesde") do
        if
            fs.metadata(`roblox_packages/.pesde/{object}`).kind == "dir"
            and string.find(object, "data%-oriented%-house_squash")
        then
            local by_lines = string.split(linker_script, "\n")
            by_lines[1] = `local module = require("./.pesde/{object}/squash")`
            local assembled = table.concat(by_lines, "\n")
            fs.writeFile("roblox_packages/squash.luau", assembled)
            break
        end
    end
end

return swap
