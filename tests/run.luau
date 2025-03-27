--!strict
local process = require("@lune/process")
process.spawn("pesde", { "install" }, { stdio = "forward" })
require("./swap_linker")()

process.spawn("luau", { "tests/unit.luau" }, { stdio = "forward" })
