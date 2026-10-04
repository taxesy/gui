local URLs = {
    "https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/main/ui_v2.lua",
    "https://raw.githubusercontent.com/taxesy/gui/main/gui.lua",
}

local function Fetch(URL)
    local ok, body = pcall(function()
        return game:HttpGet(URL)
    end)

    if ok and type(body) == "string" and body ~= "" then
        return body
    end

    if request then
        local success, response = pcall(request, {
            Url = URL,
            Method = "GET",
        })

        if success and response and response.StatusCode == 200 and type(response.Body) == "string" and response.Body ~= "" then
            return response.Body
        end
    end

    return nil
end

local body
for _, URL in ipairs(URLs) do
    body = Fetch(URL)
    if body then
        break
    end
end

if not body then
    error("m0pu: failed to fetch gui source")
end

local chunk, compileError = loadstring(body, "m0pu/gui.lua")
if not chunk then
    error("m0pu: gui.lua compile failed: " .. tostring(compileError))
end

local library = chunk()
if type(library) ~= "table" then
    error("m0pu: gui.lua did not return a library")
end

return library
