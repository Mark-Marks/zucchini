--!strict
--!native
--!optimize 2
local squash = require("@self/squash")

export type Cursor = squash.Cursor
export type SerDes<T...> = squash.SerDes<T...>

local id_to_type: { [number]: string } = {
    [1] = "boolean",
    [2] = "uint",
    [3] = "int",
    [4] = "number",
    [5] = "string",
    [6] = "buffer",
    [7] = "vlq",
    [8] = "opt",
    [9] = "array",
    [10] = "tuple",
    [11] = "record",
    [12] = "map",
    [13] = "table",
    [14] = "Axes",
    [15] = "BrickColor",
    [16] = "EnumItem",
    [17] = "CatalogueSearchParams",
    [18] = "CFrame",
    [19] = "Color3",
    [20] = "ColorSequenceKeypoint",
    [21] = "ColorSequence",
    [22] = "DateTime",
    [23] = "Faces",
    [24] = "FloatCurveKey",
    [25] = "Font",
    [26] = "NumberRange",
    [27] = "NumberSequenceKeypoint",
    [28] = "NumberSequence",
    [29] = "OverlapParams",
    [30] = "RaycastParams",
    [31] = "Vector3",
    [32] = "PathWaypoint",
    [33] = "PhysicalProperties",
    [34] = "Ray",
    [35] = "RaycastResult",
    [36] = "Vector2",
    [37] = "Rect",
    [38] = "Region3",
    [39] = "Region3int16",
    [40] = "RotationCurveKey",
    [41] = "TweenInfo",
    [42] = "UDim",
    [43] = "UDim2",
    [44] = "Vector2int16",
    [45] = "Vector3int16",
    [46] = "nil",
    [47] = "literal",
    [48] = "vector",
    [49] = "EOF", -- End Of File
} :: any

local type_to_id: { [string]: number } = {
    boolean = 1,
    uint = 2,
    int = 3,
    number = 4,
    string = 5,
    buffer = 6,
    vlq = 7,
    opt = 8,
    array = 9,
    tuple = 10,
    record = 11,
    map = 12,
    table = 13,
    Axes = 14,
    BrickColor = 15,
    EnumItem = 16,
    CatalogueSearchParams = 17,
    CFrame = 18,
    Color3 = 19,
    ColorSequenceKeypoint = 20,
    ColorSequence = 21,
    DateTime = 22,
    Faces = 23,
    FloatCurveKey = 24,
    Font = 25,
    NumberRange = 26,
    NumberSequenceKeypoint = 27,
    NumberSequence = 28,
    OverlapParams = 29,
    RaycastParams = 30,
    Vector3 = 31,
    PathWaypoint = 32,
    PhysicalProperties = 33,
    Ray = 34,
    RaycastResult = 35,
    Vector2 = 36,
    Rect = 37,
    Region3 = 38,
    Region3int16 = 39,
    RotationCurveKey = 40,
    TweenInfo = 41,
    UDim = 42,
    UDim2 = 43,
    Vector2int16 = 44,
    Vector3int16 = 45,
    ["nil"] = 46,
    literal = 47,
    vector = 48,
    EOF = 49, -- End Of File
} :: any

local private_serdes: { [string]: () -> SerDes<any> }

local function sum<T>(x: T): number
    local n = 0
    for _ in x :: any do
        n += 1
    end
    return n
end

local _vlq_serdes = squash.vlq()
local pushvlq = _vlq_serdes.ser
local popvlq = _vlq_serdes.des

local nil_serdes: SerDes<nil> = {
    ser = function() end,
    des = function(): nil
        return nil
    end,
}

local function vector_serdes(ntype: SerDes<number>): SerDes<vector>
    local npush = ntype.ser
    local npop = ntype.des

    return {
        ser = function(cursor: squash.Cursor, value: vector)
            npush(cursor, value.z)
            npush(cursor, value.y)
            npush(cursor, value.x)
        end,
        des = function(cursor: squash.Cursor): vector
            return vector.create(npop(cursor), npop(cursor), npop(cursor))
        end,
    }
end

--- zucchini.array { zucchini.data_type, length? }
local array_serdes: (<T>(type: { SerDes<T> }) -> SerDes<{ T }>) & (<T>(type: { SerDes<T> | number }) -> SerDes<{ T }>) & (<T, DV>(type: { Defaulted<T, DV> }) -> SerDes<{ Reveal<T> }>) & (<T, DV>(type: { Defaulted<T, DV> | number }) -> SerDes<{ Reveal<T> }>) = function(
    mtype
)
    return squash.array(mtype[1], mtype[2])
end :: any

--- zucchini.map { [zucchini.key_type] = zucchini.value_type }
local map_serdes: (<K, V>(type: { [SerDes<K>]: SerDes<V> }) -> SerDes<{ [K]: V }>) & (<K, DK, V>(type: { [Defaulted<K, DK>]: SerDes<V> }) -> SerDes<{ [Reveal<K>]: V }>) & (<K, V, DV>(type: { [SerDes<K>]: Defaulted<V, DV> }) -> SerDes<{ [K]: Reveal<V> }>) & (<K, DK, V, DV>(type: { [Defaulted<K, DK>]: Defaulted<V, DV> }) -> SerDes<{ [Reveal<K>]: Reveal<V> }>) = function<
    K,
    V
>(
    type: {
        [SerDes<K>]: SerDes<V>,
    }
): SerDes<{ [K]: V }>
    local actual_ktype, actual_vtype = next(type)
    return squash.map(actual_ktype :: any, actual_vtype)
end :: any

--- zucchini.literal { value }
local function literal_serdes<T>(type: { T }): SerDes<any>
    return squash.literal(type[1])
end

--- zucchini.opt { zucchini.data_type }
local opt_serdes: (<T>(type: { SerDes<T> }) -> SerDes<T?>) & (<T, DV>(type: { Defaulted<T, DV> }) -> SerDes<Reveal<T>?>) = function<
    T
>(
    type: {
        SerDes<
            T
        >
    }
): SerDes<
    T?
>
    return squash.opt(type[1])
end :: any

local function record_serdes<T>(schema: T): SerDes<Reveal<T>>
    return squash.record(schema)
end

local _u8_serdes = squash.uint(1)
local pushu8 = _u8_serdes.ser
local popu8 = _u8_serdes.des

-- Squash treats cursors like a stack.
-- This means that data has to be written backwards so it can be read normally;
-- instead of doing | type | | data | we have to do | data | | type |.

local function unknown_serialize(cursor: Cursor, value: unknown)
    local data_type = typeof(value)
    if data_type ~= "table" then
        private_serdes[data_type]().ser(cursor, value)
        pushu8(cursor, type_to_id[data_type])
        return
    end

    for k, v in value :: { [unknown]: unknown } do
        unknown_serialize(cursor, v)
        unknown_serialize(cursor, k)
    end
    pushvlq(cursor, sum(value))
    pushu8(cursor, type_to_id["table"])
end

local function unknown_deserialize(cursor: Cursor): unknown
    local data_type: string? = id_to_type[popu8(cursor)]
    if data_type == nil then
        return nil
    end
    if data_type ~= "table" then
        return private_serdes[data_type]().des(cursor)
    end

    local n = popvlq(cursor)

    local reconstructed = {}

    for _ = 1, n do
        local k = unknown_deserialize(cursor)
        local v = unknown_deserialize(cursor)
        reconstructed[k] = v
    end

    return reconstructed
end

local unknown_serdes = {
    ser = unknown_serialize,
    des = unknown_deserialize,
}

type function GetSerDesType(t: type)
    if t.tag ~= "table" then
        return types.never
    end

    local des_fn = t:readproperty(types.singleton("des"))
    if not des_fn or not des_fn:is("function") then
        return types.never
    end

    local ret = des_fn:returns().head
    if not ret or not ret[1] then
        return types.never
    end

    return ret[1]
end

export type function Reveal(t: type)
    if t.tag ~= "table" then
        return t
    end

    local mt = t:metatable()
    if mt then
        local index_singleton = types.singleton("__index")
        for key, v in mt:properties() do
            if key == index_singleton then
                t = v.read or v.write :: any
            end
        end
    end

    local tbl_props = t:properties()

    local phantom_data = GetSerDesType(t)
    if phantom_data ~= types.never then
        return Reveal(phantom_data)
    end

    local indexer = t:indexer()
    if indexer then
        local new = types.newtable()
        new:setindexer(Reveal(indexer.index), Reveal(indexer.readresult or indexer.writeresult))
        return new :: any
    end

    local new = types.newtable()
    for key, v in tbl_props do
        local value = v.read or v.write
        new:setproperty(key, Reveal(value))
    end
    return new :: any
end

local reveal: (<T>(serdes: T) -> Reveal<T>) & (<T>(serdes: { T }) -> Reveal<T>) = function(serdes)
    if serdes["ser"] ~= nil then
        return serdes[1]
    end
    return serdes
end :: any

local uint8, int8 = squash.uint(1), squash.int(1)
local uint16, int16 = squash.uint(2), squash.int(2)
local uint24, int24 = squash.uint(3), squash.int(3)
local uint32, int32, f32 = squash.uint(4), squash.int(4), squash.number(4)
local uint40, int40 = squash.uint(5), squash.int(5)
local uint48, int48 = squash.uint(6), squash.int(6)
local uint56, int56 = squash.uint(7), squash.int(7)
local uint64, int64, f64 = squash.uint(8), squash.int(8), squash.number(8)

private_serdes = (
    {
        boolean = squash.boolean,
        uint = squash.uint,
        int = squash.int,
        number = function(bytes: number?): SerDes<number>
            if not bytes then
                return f32
            end
            return squash.number(bytes)
        end,
        string = squash.string,
        buffer = squash.buffer,
        vlq = squash.vlq,
        opt = squash.opt,
        array = squash.array,
        tuple = squash.tuple,
        record = squash.record,
        map = squash.map,
        table = squash.table,
        Axes = squash.Axes,
        BrickColor = squash.BrickColor,
        EnumItem = squash.EnumItem,
        CatalogSearchParams = squash.CatalogSearchParams,
        CFrame = function(number_serdes: SerDes<number>?): SerDes<CFrame>
            return squash.CFrame(number_serdes or f32)
        end,
        Color3 = squash.Color3,
        ColorSequenceKeypoint = squash.ColorSequenceKeypoint,
        ColorSequence = squash.ColorSequence,
        DateTime = squash.DateTime,
        Faces = squash.Faces,
        FloatCurveKey = squash.FloatCurveKey,
        Font = squash.Font,
        NumberRange = function(number_serdes: SerDes<number>?): SerDes<NumberRange>
            return squash.NumberRange(number_serdes or f32)
        end,
        NumberSequenceKeypoint = function(number_serdes: SerDes<number>?): SerDes<NumberSequenceKeypoint>
            return squash.NumberSequenceKeypoint(number_serdes or f32)
        end,
        NumberSequence = function(number_serdes: SerDes<number>?): SerDes<NumberSequence>
            return squash.NumberSequence(number_serdes or f32)
        end,
        OverlapParams = squash.OverlapParams,
        RaycastParams = squash.RaycastParams,
        Vector3 = function(number_serdes: SerDes<number>?): SerDes<Vector3>
            return squash.Vector3(number_serdes or f32)
        end,
        vector = function(number_serdes: SerDes<number>?): SerDes<vector>
            return vector_serdes(number_serdes or f32)
        end,
        PathWaypoint = function(number_serdes: SerDes<number>?): SerDes<PathWaypoint>
            return squash.PathWaypoint(number_serdes or f32)
        end,
        PhysicalProperties = squash.PhysicalProperties,
        Ray = function(number_serdes: SerDes<number>?): SerDes<Ray>
            return squash.Ray(number_serdes or f32)
        end,
        RaycastResult = function(number_serdes: SerDes<number>?): SerDes<squash.SquashRaycastResult>
            return squash.RaycastResult(number_serdes or f32) :: any
        end,
        Vector2 = function(number_serdes: SerDes<number>?): SerDes<Vector2>
            return squash.Vector2(number_serdes or f32)
        end,
        Rect = function(number_serdes: SerDes<number>?): SerDes<Rect>
            return squash.Rect(number_serdes or f32)
        end,
        Region3 = function(number_serdes: SerDes<number>?): SerDes<Region3>
            return squash.Region3(number_serdes or f32)
        end,
        Region3int16 = squash.Region3int16,
        RotationCurveKey = function(number_serdes: SerDes<number>?): SerDes<RotationCurveKey>
            return squash.RotationCurveKey(number_serdes or f32)
        end,
        TweenInfo = squash.TweenInfo,
        UDim = function(number_serdes: SerDes<number>?): SerDes<UDim>
            return squash.UDim(number_serdes or f32)
        end,
        UDim2 = function(number_serdes: SerDes<number>?): SerDes<UDim2>
            return squash.UDim2(number_serdes or f32)
        end,
        Vector2int16 = squash.Vector2int16,
        Vector3int16 = squash.Vector3int16,
        unknown = function(): SerDes<unknown>
            return unknown_serdes
        end,
        ["nil"] = function(): SerDes<nil>
            return nil_serdes
        end,
        literal = squash.literal,
        base_conversion = {
            alphabet = squash.string.alphabet,
            convert = squash.string.convert,
            binary = squash.string.binary,
            octal = squash.string.octal,
            decimal = squash.string.decimal,
            duodecimal = squash.string.duodecimal,
            hexadecimal = squash.string.hexadecimal,
            utf8 = squash.string.utf8,
            lower = squash.string.lower,
            upper = squash.string.upper,
            letters = squash.string.letters,
            punctuation = squash.string.punctuation,
            english = squash.string.english,
            filepath = squash.string.filepath,
            datastore = squash.string.datastore,
        },
    } :: any
) :: { [string]: () -> SerDes<any> }

local function extend_internal<T>(serdes: SerDes<T>, name: string)
    private_serdes[name] = serdes
    local next_entry = #id_to_type + 1
    id_to_type[next_entry] = name
    type_to_id[name] = next_entry
end

export type Defaulted<T, U> = typeof(setmetatable(
    ({} :: any) :: T,
    {} :: { __call: (self: any, x: { U }?) -> T, __index: T }
))
local function wrap_with_default<T, U>(ty: (U) -> T, default: U): Defaulted<T, U>
    local with_default = ty(default)

    local mt = {
        __call = function(_, x: { U }?): T
            if x then
                return ty(x[1])
            end
            return with_default
        end,
        __index = with_default,
    }

    return setmetatable(with_default, mt)
end

-- stylua: ignore
local zucchini = {
    boolean = squash.boolean() :: SerDes<boolean>,
    uint8 = uint8, int8 = int8,
    uint16 = uint16, int16 = int16,
    uint24 = uint24, int24 = int24,
    uint32 = uint32, int32 = int32, f32 = f32,
    uint40 = uint40, int40 = int40,
    uint48 = uint48, int48 = int48,
    uint56 = uint56, int56 = int56,
    uint64 = uint64, int64 = int64, f64 = f64,
    string = (wrap_with_default(squash.string :: any, nil) :: any) :: Defaulted<SerDes<string>, number>,
    buffer = (wrap_with_default(squash.buffer :: any, nil) :: any) :: Defaulted<SerDes<buffer>, number>,
    vlq = squash.vlq(),
    opt = opt_serdes,
    array = array_serdes,
    tuple = squash.tuple,
    record = record_serdes,
    map = map_serdes,
    Axes = squash.Axes(),
    BrickColor = squash.BrickColor(),
    EnumItem = squash.EnumItem,
    CatalogueSearchParams = squash.CatalogSearchParams(),
    CFrame = wrap_with_default(squash.CFrame, f32),
    Color3 = squash.Color3(),
    ColorSequenceKeypoint = squash.ColorSequenceKeypoint(),
    ColorSequence = squash.ColorSequence(),
    DateTime = squash.DateTime(),
    Faces = squash.Faces(),
    FloatCurveKey = squash.FloatCurveKey(),
    Font = squash.Font(),
    NumberRange = wrap_with_default(squash.NumberRange, f32),
    NumberSequenceKeypoint = wrap_with_default(squash.NumberSequenceKeypoint, f32),
    NumberSequence = wrap_with_default(squash.NumberSequence, f32),
    OverlapParams = squash.OverlapParams(),
    RaycastParams = squash.RaycastParams(),
    Vector3 = wrap_with_default(squash.Vector3, f32),
    PathWaypoint = wrap_with_default(squash.PathWaypoint, f32),
    PhysicalProperties = squash.PhysicalProperties,
    Ray = wrap_with_default(squash.Ray, f32),
    RaycastResult = wrap_with_default(squash.RaycastResult :: any, f32),
    Vector2 = wrap_with_default(squash.Vector2, f32),
    Rect = wrap_with_default(squash.Rect, f32),
    Region3 = wrap_with_default(squash.Region3, f32),
    Region3int16 = squash.Region3int16(),
    RotationCurveKey = wrap_with_default(squash.RotationCurveKey, f32),
    TweenInfo = squash.TweenInfo(),
    UDim = wrap_with_default(squash.UDim, f32),
    UDim2 = wrap_with_default(squash.UDim2, f32),
    Vector2int16 = squash.Vector2int16(),
    Vector3int16 = squash.Vector3int16(),
    unknown = unknown_serdes,
    ["nil"] = nil_serdes,
    literal = literal_serdes,
    vector = wrap_with_default(vector_serdes, f32),
    base_conversion = {
        alphabet = squash.string.alphabet,
        convert = squash.string.convert,
        binary = squash.string.binary,
        octal = squash.string.octal,
        decimal = squash.string.decimal,
        duodecimal = squash.string.duodecimal,
        hexadecimal = squash.string.hexadecimal,
        utf8 = squash.string.utf8,
        lower = squash.string.lower,
        upper = squash.string.upper,
        letters = squash.string.letters,
        punctuation = squash.string.punctuation,
        english = squash.string.english,
        filepath = squash.string.filepath,
        datastore = squash.string.datastore,
    },

    id_to_type_map = id_to_type,
    type_to_id_map = type_to_id,
    cursor = squash.cursor,
    cursor_from_buffer = squash.frombuffer,
    reveal = reveal,
    extend_internal = extend_internal,
}

return zucchini
