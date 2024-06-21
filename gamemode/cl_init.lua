hook.Run("DarkRPStartedLoading")

GM.Name = "DarkRP"
GM.Version = "2.7.0"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

local function LoadModules()
    local root = GM.FolderName .. "/gamemode/modules/"
    local _, folders = file.Find(root .. "*", "LUA")

    for _, folder in SortedPairs(folders, true) do
        for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
            if File == "sh_interface.lua" then continue end
            include(root .. folder .. "/" .. File)
        end

        for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
            if File == "cl_interface.lua" then continue end
            include(root .. folder .. "/" .. File)
        end
    end
end

GM.Config = {}

include("config/settings.lua")

include("libraries/fn.lua")
include("libraries/sh_cami.lua")
include("libraries/simplerr.lua")
include("libraries/tablecheck.lua")
include("libraries/disjointset.lua")

include("libraries/interfaceloader.lua")
include("libraries/modificationloader.lua")

hook.Call("DarkRPPreLoadModules", GM)

LoadModules()

DarkRP.DARKRP_LOADING = true
include("config/entities.lua")
include("config/jobs.lua")
DarkRP.DARKRP_LOADING = nil

DarkRP.finish()

hook.Call("DarkRPFinishedLoading", GM)
