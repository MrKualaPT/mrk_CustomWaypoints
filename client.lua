-- Imports
Blip = Import 'blips'

local CreatedWayPoints = {}

AddEventHandler("vorp_core:Client:OnPlayerSpawned",function()
    -- Retrived the player waypoint list
    Core.Callback.TriggerAwait('mrk_customwaypoints:RetrieveWaypoints', function(result)
        if result then
            for i=1, in pairs(WayPoints_list) do
                -- Creating the custom waypoints
                CreateBlip(WayPoints_list[i])
            end
        end
    end)
    
end)

function CreateBlip(data)
    local blip = Blip.Blips:Create('coords', {
        Pos = (data.coords ~= nil and data.coords or GetEntityCoords(PlayerPedId())),
        Radius = 2,
        P7 = 0,
        Blip = Config.Blips.Hash,
        Scale = Config.Blips.scale,
        Options = {                            -- optional
            sprite = 1,                        --string or integer if type is entity or coords
            name = data.name,
            modifier = 'BLIP_MODIFIER_MP_COLOR_1', -- int or string
            color = 'white', -- internal color name 
        },
        OnCreate = function(self)
            print('Created', self:GetHandle())
            -- local blue, red, yellow = self:GetBlipColor({ 'blue', 'red', 'yellow' })
            -- self:AddModifier(red)

            -- Remove the code to modify and add notification????
        end
    })
end


function DeleteCustomWayPoints(Removed)
    for i=1, in pairs(CreatedWayPoints) do
        local handle = CreatedWayPoints[i]:GetHandle()
        CreatedWayPoints[i]:Remove()
        CreatedWayPoints[i] = nil
        if Removed then
            -- Trigger event to remove from DB
        end
    end
end

RegisterCommand('waypoint', function()
    local myInput = {
        type = "enableinput", -- don't touch
        inputType = "input", -- input type
        button = "Confirm", -- button name
        placeholder = "NAME OF THE WAYPOINT", -- placeholder name
        style = "block", -- don't touch
        attributes = {
            inputHeader = "CREATE A CUSTOM WAYPOINT", -- header
            type = "text", -- inputype text, number,date,textarea ETC
            pattern = "[A-Za-z]+", --  only numbers "[0-9]" | for letters only "[A-Za-z]+" 
            title = "Text Only", -- if input doesnt match show this message
            style = "border-radius: 10px; background-color: ; border:none;"-- style 
        }
    }

    local result = exports.vorp_inputs:advancedInput(myInput)
    result = tostring(result) -- convert result to a string

    if result.lenth() > 20 then
        -- Notify the player that the name of the waypoint is to long and open the input again
    end

    CreateBlip({name = result})

    -- Add a trigger to add blip do the DB
end, false)

RegisterCommand("waypointlist", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        blips = blips
    })
end)

RegisterNUICallback("renameBlip", function(data, cb)
    local id = data.id
    local newName = data.newName
    if blips[id] then
        blips[id].name = newName
    end
    cb("ok")
end)

RegisterNUICallback("setLocation", function(data, cb)
    local id = data.id
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    if blips[id] then
        blips[id].coords = coords
    end
    cb("ok")
end)

RegisterNUICallback("deleteBlip", function(data, cb)
    local id = data.id
    blips[id] = nil
    cb("ok")
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)