--!strict
local spawn = require("./util/spawn")

spawn.start("stylua lib/")
spawn.start("selene lib/")
spawn.start("luau tests/unit.luau")
