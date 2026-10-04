-- m0pu public loader
local URL = "https://raw.githubusercontent.com/taxesy/gui/main/gui.lua"
local ok, body = pcall(function()
    return game:HttpGet(URL)
end)
if not ok or type(body) ~= "string" or body == "" then
    error("m0pu: failed to fetch gui.lua")
end
local chunk, compileError = loadstring(body)
if not chunk then
    error("m0pu: gui.lua compile failed: " .. tostring(compileError))
end
return chunk()
