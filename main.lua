local BaseURL = "https://raw.githubusercontent.com/taxesy/gui/main/gui.lua"

local function Fetch()
    local URL = BaseURL .. "?m0pu=" .. tostring(os.time())

    local ok, body = pcall(function()
        return game:HttpGet(URL)
    end)

    if ok and type(body) == "string" and body ~= "" then
        return body
    end

    local function requestBody(requester)
        if type(requester) ~= "function" then
            return nil
        end

        local success, response = pcall(requester, {
            Url = URL,
            Method = "GET",
            Headers = {
                ["Cache-Control"] = "no-cache, no-store, must-revalidate",
                ["Pragma"] = "no-cache",
            },
        })

        if success and response and response.StatusCode == 200 and type(response.Body) == "string" and response.Body ~= "" then
            return response.Body
        end

        return nil
    end

    local bodyFromRequest = requestBody(request)
    if bodyFromRequest then
        return bodyFromRequest
    end

    local bodyFromHttpRequest = requestBody(http_request)
    if bodyFromHttpRequest then
        return bodyFromHttpRequest
    end

    if syn and type(syn.request) == "function" then
        local bodyFromSyn = requestBody(syn.request)
        if bodyFromSyn then
            return bodyFromSyn
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

local ok, library = pcall(chunk)

if not ok then
    error("m0pu: gui.lua initialization failed: " .. tostring(library))
end

if type(library) ~= "table" then
    error("m0pu: gui.lua did not return a library")
end

return library
