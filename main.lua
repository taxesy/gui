local URL = "https://raw.githubusercontent.com/taxesy/gui/bee0a13bde63808b2ba949cc1aec19f432c98c01/gui.lua"

local function Fetch()
    local ok, body = pcall(function()
        return game:HttpGet(URL)
    end)

    if ok and type(body) == "string" and body ~= "" then
        return body
    end

    if type(request) == "function" then
        local success, response = pcall(request, {
            Url = URL,
            Method = "GET",
        })

        if success and response and response.StatusCode == 200 and type(response.Body) == "string" and response.Body ~= "" then
            return response.Body
        end
    end

    if type(http_request) == "function" then
        local success, response = pcall(http_request, {
            Url = URL,
            Method = "GET",
        })

        if success and response and response.StatusCode == 200 and type(response.Body) == "string" and response.Body ~= "" then
            return response.Body
        end
    end

    if syn and type(syn.request) == "function" then
        local success, response = pcall(syn.request, {
            Url = URL,
            Method = "GET",
        })

        if success and response and response.StatusCode == 200 and type(response.Body) == "string" and response.Body ~= "" then
            return response.Body
        end
    end

    return nil
end

local body = Fetch()

if not body then
    error("m0pu: failed to fetch gui.lua")
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
