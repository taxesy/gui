local SOURCE_URL = "https://raw.githubusercontent.com/taxesy/gui/main/gui.lua"

local function fetch(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(body) == "string" and body ~= "" then
        return body
    end

    local requester
    if type(request) == "function" then
        requester = request
    elseif type(http_request) == "function" then
        requester = http_request
    elseif type(syn) == "table" and type(syn.request) == "function" then
        requester = syn.request
    end

    if requester then
        local sent, response = pcall(requester, {
            Url = url,
            Method = "GET",
        })

        if sent and type(response) == "table" then
            local status = response.StatusCode or response.Status
            local responseBody = response.Body
            if (status == nil or status == 200) and type(responseBody) == "string" and responseBody ~= "" then
                return responseBody
            end
        end
    end

    error("slate: failed to fetch Taxesy GUI")
end

local source = fetch(SOURCE_URL)
local chunk, compileError = loadstring(source, "taxesy/gui.lua")
if not chunk then
    error("slate: Taxesy GUI compile failed: " .. tostring(compileError))
end

local ok, library = pcall(chunk)
if not ok or type(library) ~= "table" then
    error("slate: Taxesy GUI did not return a library")
end

local createWindow = library.CreateWindow

library.SetLanguage = function()
    return false
end

library.GetLanguage = function()
    return "EN"
end

function library:CreateWindow(options)
    options = options or {}
    options.Language = "EN"

    local window = createWindow(self, options)

    pcall(function()
        local pill = window.LangPill
        if pill then
            if type(window.TopButtons) == "table" then
                for index = #window.TopButtons, 1, -1 do
                    if window.TopButtons[index] == pill then
                        table.remove(window.TopButtons, index)
                        break
                    end
                end
            end

            pill:Destroy()
            window.LangPill = nil
        end
    end)

    pcall(function()
        local option = self.Options and self.Options.m0puLanguage
        if option and type(option.SetVisible) == "function" then
            option:SetVisible(false)
        end
    end)

    return window
end

library.Source = SOURCE_URL
return library
