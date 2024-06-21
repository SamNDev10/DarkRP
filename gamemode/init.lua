hook.Run("DarkRPStartedLoading")

GM.Name = "DarkRP"
GM.Version = "2.7.0"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

AddCSLuaFile("libraries/fn.lua")
AddCSLuaFile("libraries/sh_cami.lua")
AddCSLuaFile("libraries/simplerr.lua")
AddCSLuaFile("libraries/tablecheck.lua")
AddCSLuaFile("libraries/disjointset.lua")

AddCSLuaFile("libraries/interfaceloader.lua")
AddCSLuaFile("libraries/modificationloader.lua")

AddCSLuaFile("config/settings.lua")
AddCSLuaFile("config/entities.lua")
AddCSLuaFile("config/jobs.lua")

AddCSLuaFile("cl_init.lua")

GM.Config = GM.Config or {}

include("config/settings.lua")
include("config/_MySQL.lua")

include("libraries/fn.lua")
include("libraries/sh_cami.lua")
include("libraries/simplerr.lua")
include("libraries/tablecheck.lua")
include("libraries/disjointset.lua")

include("libraries/interfaceloader.lua")
include("libraries/modificationloader.lua")

include("libraries/mysqlite/mysqlite.lua")

hook.Call("DarkRPPreLoadModules", GM)

local fol = GM.FolderName .. "/gamemode/modules/"
local files, folders = file.Find(fol .. "*", "LUA")
local SortedPairs = SortedPairs

for _, v in ipairs(files) do
    if string.GetExtensionFromFilename(v) ~= "lua" then continue end
    include(fol .. v)
end

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
        if File == "sh_interface.lua" then continue end
        AddCSLuaFile(fol .. folder .. "/" .. File)
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
        if File == "sv_interface.lua" then continue end
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
        if File == "cl_interface.lua" then continue end
        AddCSLuaFile(fol .. folder .. "/" .. File)
    end
end

DarkRP.DARKRP_LOADING = true
include("config/entities.lua")
include("config/jobs.lua")
DarkRP.DARKRP_LOADING = nil

DarkRP.finish()

hook.Call("DarkRPFinishedLoading", GM)
MySQLite.initialize()
