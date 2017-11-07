require("logic.util")

local apis = {}
table.insert(apis, require("logic.apis.onboard_computer_api"))
table.insert(apis, require("logic.apis.onboard_military_computer_api"))

local function raise_event(event_name, event_data)
    local responses = {}
    for interface_name, interface_functions in pairs(remote.interfaces) do
        if interface_functions[event_name] then
            responses[interface_name] = remote.call(interface_name, event_name, event_data)
        end
    end
    return responses
end

local function loadAPIs()
    for i, api in pairs(apis) do
        raise_event("addComputerAPI", api)
    end
end

local function OnInit()
    loadAPIs()
end

local function OnLoad()
    loadAPIs()
end

script.on_init(OnInit)
script.on_load(OnLoad)
