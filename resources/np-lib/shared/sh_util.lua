function uuid()
    math.randomseed(GetGameTimer())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function encodeAccountId(plain)
    if type(plain) == 'number' then
        return math.floor(exports["np-financials"]:EncodeId(plain))
    end
end

function decodeAccountId(encoded)
    if type(encoded) == 'number' then
        return exports["np-financials"]:DecodeId(encoded)
    end
end

function isValidDate(str)
  if not str then return false end
  local y, m, d = str:match("(%d+)/(%d+)/(%d+)")

  y, m, d = tonumber(y), tonumber(m), tonumber(d)

  if not y or y <= 1970 or y >= 2038 then
      return false
  elseif not m or m < 1 or m > 12 then
      return false
  elseif not d or d < 1 or d > 31 then
      return false
  else
      return true
  end
end

function shallowcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs(orig) do
          copy[orig_key] = orig_value
      end
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function reverse(tbl)
    for i=1, math.floor(#tbl / 2) do
        tbl[i], tbl[#tbl - i + 1] = tbl[#tbl - i + 1], tbl[i]
    end

    return tbl
end

-- Server side only
function generateUTCTimestamp()
  local now = os.time()
  local tz_offset = os.difftime(now, os.time(os.date("!*t", now)))
  local epoch = os.time(os.date("!*t"))
  local utc = epoch + tz_offset
  return math.floor(utc)
end

function stringJoin(pData, pSeparator)
  local values = ""
  for _, value in pairs(pData) do
    values = values .. ("'%s'"):format(value) .. pSeparator
  end
  return (values):sub(1, #values - 1)
end