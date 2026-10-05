local SourceURL = "https://raw.githubusercontent.com/taxesy/gui/main/gui.lua"
local function Fetch()
    local URL = SourceURL .. "?v=" .. tostring(os.time())
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
    local responseBody = requestBody(request)
    if responseBody then
        return responseBody
    end
    responseBody = requestBody(http_request)
    if responseBody then
        return responseBody
    end
    if syn and type(syn.request) == "function" then
        responseBody = requestBody(syn.request)
        if responseBody then
            return responseBody
        end
    end
    return nil
end
local body = Fetch()
if not body then
    error("failed to fetch interface source")
end
local chunk, compileError = loadstring(body, "gui.lua")
if not chunk then
    error("interface compile failed: " .. tostring(compileError))
end
local ok, library = pcall(chunk)
if not ok then
    error("interface initialization failed: " .. tostring(library))
end
if type(library) ~= "table" then
    error("interface source did not return a library")
end
return library
