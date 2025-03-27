--!strict
-- Unit tests include only what can be tested without messing with simulating roblox's environment

-- stylua: ignore start
local testkit = require("./testkit")
local zucchini = require("../lib")

local make_cursor = zucchini.cursor

local TEST, CASE, CHECK, FINISH, SKIP, FOCUS = testkit.test()

function table_equals(o1: any, o2: any)
    if o1 == o2 then return true end
    local o1Type = type(o1)
    local o2Type = type(o2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    local keySet = {}

    for key1, value1 in pairs(o1) do
        local value2 = o2[key1]
        if value2 == nil or table_equals(value1 :: any, value2 :: any) == false then
            return false
        end
        keySet[key1] = true
    end

    for key2, _ in pairs(o2) do
        if not keySet[key2] then return false end
    end
    return true
end

TEST("Primitives", function()
    do CASE "boolean"
        local cursor = make_cursor()
        local serdes = zucchini.boolean :: zucchini.SerDes<...boolean>

        local bools = {false, true, true, false, true, false, false, true}

        serdes.ser(cursor, false)
        serdes.ser(cursor, true)
        serdes.ser(cursor, table.unpack(bools))

        local bools_out = table.pack(serdes.des(cursor))
        for i in bools do
            CHECK(bools[i] == bools_out[i])
        end
        CHECK(serdes.des(cursor) == true)
        CHECK(serdes.des(cursor) == false)
    end

    do CASE "uint8"
        local cursor = make_cursor()
        local serdes = zucchini.uint8

        serdes.ser(cursor, 2^8-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^8-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^8-1)
    end

    do CASE "int8"
        local cursor = make_cursor()
        local serdes = zucchini.int8

        serdes.ser(cursor, 2^7-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^7-1))

        CHECK(serdes.des(cursor) == -(2^7-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^7-1)
    end

    do CASE "uint16"
        local cursor = make_cursor()
        local serdes = zucchini.uint16

        serdes.ser(cursor, 2^16-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^16-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^16-1)
    end

    do CASE "int16"
        local cursor = make_cursor()
        local serdes = zucchini.int16

        serdes.ser(cursor, 2^15-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^15-1))

        CHECK(serdes.des(cursor) == -(2^15-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^15-1)
    end

    do CASE "uint24"
        local cursor = make_cursor()
        local serdes = zucchini.uint24

        serdes.ser(cursor, 2^24-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^24-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^24-1)
    end

    do CASE "int24"
        local cursor = make_cursor()
        local serdes = zucchini.int24

        serdes.ser(cursor, 2^23-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^23-1))

        CHECK(serdes.des(cursor) == -(2^23-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^23-1)
    end

    do CASE "uint32"
        local cursor = make_cursor()
        local serdes = zucchini.uint32

        serdes.ser(cursor, 2^32-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^32-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^32-1)
    end

    do CASE "int32"
        local cursor = make_cursor()
        local serdes = zucchini.int32

        serdes.ser(cursor, 2^31-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^31-1))

        CHECK(serdes.des(cursor) == -(2^31-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^31-1)
    end

    do CASE "f32"
        local cursor = make_cursor()
        local serdes = zucchini.f32

        local function trim(n: number, to: number): number
            local factor = 10 ^ to
            return math.floor(n * factor) / factor
        end

        serdes.ser(cursor, 3.14)
        CHECK(trim(serdes.des(cursor), 2) == 3.14) -- floating point error my beloved ❤️
    end

    do CASE "uint40"
        local cursor = make_cursor()
        local serdes = zucchini.uint40

        serdes.ser(cursor, 2^40-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^40-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^40-1)
    end

    do CASE "int40"
        local cursor = make_cursor()
        local serdes = zucchini.int40

        serdes.ser(cursor, 2^39-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^39-1))

        CHECK(serdes.des(cursor) == -(2^39-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^39-1)
    end

    do CASE "uint48"
        local cursor = make_cursor()
        local serdes = zucchini.uint48

        serdes.ser(cursor, 2^48-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^48-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^48-1)
    end

    do CASE "int48"
        local cursor = make_cursor()
        local serdes = zucchini.int48

        serdes.ser(cursor, 2^47-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^47-1))

        CHECK(serdes.des(cursor) == -(2^47-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^47-1)
    end

    do CASE "uint56"
        local cursor = make_cursor()
        local serdes = zucchini.uint56

        serdes.ser(cursor, 2^53-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^56-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^53-1)
    end

    do CASE "int56"
        local cursor = make_cursor()
        local serdes = zucchini.int56

        serdes.ser(cursor, 2^53-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^55-1))

        CHECK(serdes.des(cursor) == -(2^55-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^53-1)
    end

    do CASE "uint64"
        local cursor = make_cursor()
        local serdes = zucchini.uint64

        serdes.ser(cursor, 2^53-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)

        CHECK(serdes.des(cursor) == 2^64-1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^53-1)
    end

    do CASE "int64"
        local cursor = make_cursor()
        local serdes = zucchini.int64
        
        serdes.ser(cursor, 2^53-1)
        serdes.ser(cursor, 11)
        serdes.ser(cursor, 0)
        serdes.ser(cursor, -1)
        serdes.ser(cursor, -(2^63-1))

        CHECK(serdes.des(cursor) == -(2^63-1))
        CHECK(serdes.des(cursor) == -1)
        CHECK(serdes.des(cursor) == 0)
        CHECK(serdes.des(cursor) == 11)
        CHECK(serdes.des(cursor) == 2^53-1)
    end

    do CASE "f64"
        local cursor = make_cursor()
        local serdes = zucchini.f64

        serdes.ser(cursor, 3.14)
        serdes.ser(cursor, 2.718281828459045)

        CHECK(serdes.des(cursor) == 2.718281828459045)
        CHECK(serdes.des(cursor) == 3.14)
    end

    do CASE "string - dynamic"
        local cursor = make_cursor()
        local serdes = zucchini.string

        serdes.ser(cursor, "Hello, World!")
        CHECK(serdes.des(cursor) == "Hello, World!")
    end

    do CASE "string - static"
        local cursor = make_cursor()
        local serdes = zucchini.string { 13 }

        serdes.ser(cursor, "Hello, World!")
        CHECK(serdes.des(cursor) == "Hello, World!")

        local ok = pcall(serdes.ser, cursor, "TWENTYCHARACTERSONLY")
        CHECK(ok == false)
    end

    do CASE "buffer - dynamic"
        local cursor = make_cursor()
        local serdes = zucchini.buffer

        local buf = buffer.create(8)
        buffer.writeu32(buf, 0, 12345678)

        serdes.ser(cursor, buf)
        local result = serdes.des(cursor)
        CHECK(buffer.readu32(result, 0) == 12345678)
    end

    do CASE "buffer - static"
        local cursor = make_cursor()
        local serdes = zucchini.buffer { 4 }

        local buf = buffer.create(4)
        buffer.writeu32(buf, 0, 12345678)

        serdes.ser(cursor, buf)
        local result = serdes.des(cursor)
        CHECK(buffer.readu32(result, 0) == 12345678)

        local buf2 = buffer.create(8)
        buffer.writef64(buf2, 0, 3.14)

        serdes.ser(cursor, buf2)
        local result2 = serdes.des(cursor)
        local ok = pcall(buffer.readf64, result2, 0)
        CHECK(ok == false)
    end

    do CASE "vlq"
        local cursor = make_cursor()
        local serdes = zucchini.vlq

        serdes.ser(cursor, 128^1-1)
        serdes.ser(cursor, 128^2-1)
        serdes.ser(cursor, 128^3-1)
        serdes.ser(cursor, 128^4-1)
        serdes.ser(cursor, 128^5-1)
        serdes.ser(cursor, 128^6-1)
        serdes.ser(cursor, 128^7-1)
        serdes.ser(cursor, 128^8-1)

        CHECK(serdes.des(cursor) == 128^8-1)
        CHECK(serdes.des(cursor) == 128^7-1)
        CHECK(serdes.des(cursor) == 128^6-1)
        CHECK(serdes.des(cursor) == 128^5-1)
        CHECK(serdes.des(cursor) == 128^4-1)
        CHECK(serdes.des(cursor) == 128^3-1)
        CHECK(serdes.des(cursor) == 128^2-1)
        CHECK(serdes.des(cursor) == 128^1-1)
    end

    do CASE "opt"
        local cursor = make_cursor()
        local serdes = zucchini.opt { zucchini.uint8 }

        serdes.ser(cursor, nil)
        serdes.ser(cursor, 16)

        CHECK(serdes.des(cursor) == 16)
        CHECK(serdes.des(cursor) == nil)
    end

    do CASE "literal"
        local cursor = make_cursor()
        local serdes = zucchini.literal { "Hello, World!" }

        serdes.ser(cursor, "Hello, World!")
        CHECK(serdes.des(cursor) == "Hello, World!")
    end

    do CASE "vector - default f32"
        local cursor = make_cursor()
        local serdes = zucchini.vector

        local vec = vector.create(3.14, 4.13, 1.34)

        serdes.ser(cursor, vec)
        CHECK(serdes.des(cursor) == vec)
    end

    do CASE "vector - uint8"
        local cursor = make_cursor()
        local serdes = zucchini.vector { zucchini.uint8 }

        local vec = vector.create(1, 2^8-1, 1)

        serdes.ser(cursor, vec)
        CHECK(serdes.des(cursor) == vec)
    end
end)

TEST("Complex", function()
    do CASE "array - dynamically sized"
        local cursor = make_cursor()
        local serdes = zucchini.array { zucchini.uint8 }

        local array = { 1, 2, 3, 4, 5, 6 }

        serdes.ser(cursor, array)
        CHECK(table_equals(serdes.des(cursor), array))
    end

    do CASE "array - statically sized"
        local cursor = make_cursor()
        local serdes = zucchini.array { zucchini.uint8, 4 }

        local array = { 1, 2, 3, 4 }

        serdes.ser(cursor, array)
        CHECK(table_equals(serdes.des(cursor), array))

        local array2 = { 1, 2, 3, 4, 5, 6, 7, 8 }
        
        serdes.ser(cursor, array2)
        CHECK(table_equals(serdes.des(cursor), { 1, 2, 3, 4 }))
    end

    do CASE "map"
        local cursor = make_cursor()
        print(cursor.Buf)
        local serdes = zucchini.map { [zucchini.string] = zucchini.vector }

        local map = {
            foo = vector.create(1, 2, 3),
            bar = vector.create(4, 5, 6),
            baz = vector.create(7, 8, 9),
        }

        serdes.ser(cursor, map)
        CHECK(table_equals(serdes.des(cursor), map))
    end

    do CASE "record"
        local cursor = make_cursor()
        local serdes = zucchini.record {
            position = zucchini.vector,
            health = zucchini.uint8,
            name = zucchini.string,
            poisoned = zucchini.boolean,
            grappled = zucchini.boolean,
            concious = zucchini.boolean,
            items = zucchini.array {
                zucchini.record {
                    count = zucchini.vlq,
                    name = zucchini.string,
                },
            },
            inns = zucchini.map { [zucchini.string] = zucchini.boolean },
            equipped = zucchini.opt { zucchini.string },
        }

        local player = {
            position = vector.create(287.3855, -13486.3),
            health = 9,
            name = "Cedrick",
            poisoned = true,
            grappled = true,
            concious = false,
            items = {
                { name = "Lantern", count = 2 },
                { name = "Waterskin", count = 1 },
                { name = "Map", count = 4 },
            },
            inns = {
                ["The Copper Cauldron"] = true,
                Infirmary = true,
                ["His Recess"] = true,
            } :: { [string]: boolean }, -- Suffering from success
            equipped = nil :: any, -- Suffering from success v2
        }

        serdes.ser(cursor, player)
        CHECK(table_equals(serdes.des(cursor), player))
    end

    do CASE "unknown"
        local cursor = make_cursor()
        local serdes = zucchini.unknown

        local function junk_string(length: number)
            local str = ""
            for _ = 1, length do
                str ..= string.char(math.random(16, 32))
            end
            return str
        end

        local insert_junk = table.insert :: any
        local function make_junk(limit: number)
            local junk: { [any]: any } = {}
            for _ = 1, limit do
                local t = math.random(1, 3)
                if t == 1 then
                    insert_junk(junk, if math.random() == 0 then false else true)
                elseif t == 2 then
                    insert_junk(junk, junk_string(math.random(0, 30)))
                elseif t == 3 then
                    junk[junk_string(math.random(12, 41))] = make_junk(5)
                end
            end
            return junk :: any
        end

        --local junk = make_junk(20)
        local junk = { abc = "helo" }
        serdes.ser(cursor, junk)
        CHECK(table_equals(serdes.des(cursor), junk))
    end
end)

FINISH()
-- stylua: ignore end
