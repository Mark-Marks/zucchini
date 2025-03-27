local zucchini = require("../lib")

local str = zucchini.string { 20 }
local c = zucchini.cursor()
str.ser(c, "less")
local s = str.des(c)
local null_byte = string.char(0)
print(#string.split(s, null_byte)[1])
