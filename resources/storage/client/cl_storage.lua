local stringType = type("")
local intType = math.type(1)
local floatType = math.type(1.0)
local vector2Type = type(vector2(11.11,11.11))
local vector3Type = type(vector3(11.11,11.11,11.11))
local vector4Type = type(vector4(11.11,11.11,11.11,11.11))
local tableT = {}
local tableType = type(tableT)

function getStorage(storageType,key)

    local typeUsed = type(storageType)
    local ignoreString = false
    if storageType == "vector2" or storageType == "vector3" or storageType == "vector4" or storageType == "table" then ignoreString = true end

    if typeUsed == "number" then
        -- Interger
        if math.type(storageType) == intType then
            return GetResourceKvpInt(key)

        -- Float
        elseif math.type(storageType) == floatType then
            return GetResourceKvpFloat(key)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x1")
        end
    else
        -- String
        if typeUsed == stringType and not ignoreString then
            return GetResourceKvpString(key)

        -- Vector 2
        elseif typeUsed == vector2Type or storageType == "vector2" then
            local vec2 = vector2(
                GetResourceKvpFloat("Vec2_["..key.."]_X"),
                GetResourceKvpFloat("Vec2_["..key.."]_Y")
            )
            return vec2

        -- Vector 3 
        elseif typeUsed == vector3Type or storageType == "vector3" then
            local vec3 = vector3(
                GetResourceKvpFloat("Vec3_["..key.."]_X"),
                GetResourceKvpFloat("Vec3_["..key.."]_Y"),
                GetResourceKvpFloat("Vec3_["..key.."]_Z")
            )
            return 

        -- Vector 4 
        elseif typeUsed == vector4Type or storageType == "vector4" then
            local vec4 = vector4(
                GetResourceKvpFloat("Vec4_["..key.."]_X"),
                GetResourceKvpFloat("Vec4_["..key.."]_Y"),
                GetResourceKvpFloat("Vec4_["..key.."]_Z"),
                GetResourceKvpFloat("Vec4_["..key.."]_W")
            )
            return vec4

        -- Tables
        elseif typeUsed == tableType or storageType == "table" then
            local result = json.decode(GetResourceKvpString("Json_"..key))
            return result


        else
            print("[Storage] - [Error] - [Failed to find data type] - x2")
        end
    end

end


function set(value,key)

    local typeUsed = type(value)
    local ignoreString = false

    if typeUsed == "number" then
        -- Interger
        if math.type(value) == intType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpInt(key,value)

        -- Float
        elseif math.type(value) == floatType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat(key, value)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x3")
        end
    else
        -- String
        if typeUsed == stringType then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvp(key, value)

        -- Vector 2
        elseif typeUsed == vector2Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec2_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec2_["..key.."]_Y", value.y)

        -- Vector 3
        elseif typeUsed == vector3Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec3_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec3_["..key.."]_Y", value.y)
            SetResourceKvpFloat("Vec3_["..key.."]_Z", value.z)

        -- Vector 4
        elseif typeUsed == vector4Type then
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvpFloat("Vec4_["..key.."]_X", value.x)
            SetResourceKvpFloat("Vec4_["..key.."]_Y", value.y)
            SetResourceKvpFloat("Vec4_["..key.."]_Z", value.z)
            SetResourceKvpFloat("Vec4_["..key.."]_W", value.w)

        -- Table
        elseif typeUsed == tableType then
            local jsonValue = json.encode(value)
            SetResourceKvpInt("IsSet_"..key,1)
            SetResourceKvp("Json_"..key, jsonValue)

        else
            print("[Storage] - [Error] - [Failed to find data type] - x4")
        end
    end

end


function remove(key)
    DeleteResourceKvp(key)
end

function tryGet(storageType,key)

    if getStorage(1,"IsSet_"..key) ~= 0 then
        return getStorage(storageType,key)
    end

    return false
end
