--[[
	RenWorld
	Renames a world and optionally the world filename too. This is for the console user only.
	
	Known Issues:
	  - No checks are done yet for invalid characters or name length. So be careful of that.
]]

import ('tdsm.api')
import ('tdsm.api.Misc')
import ('tdsm.api.Plugin') --HookResult
import ('tdsm.api.Command') --AccessLevel
import ('Terraria')

RenWorld = {}
RenWorld.__index = RenWorld

function RenWorld.create()
	local plg = {}
	setmetatable(plg, RenWorld)

	--Set the details (TDSM requires this)
	plg.TDSMBuild = 2
	plg.Version = "1"
	plg.Author = "D1G1T4L3CH0"
	plg.Name = "RenWorld"
	plg.Description = "Renames a world."
	
	return plg
end

function RenWorld:Initialized()
    AddCommand("renworld")
        :WithAccessLevel(AccessLevel.CONSOLE)
        :WithDescription("Renames a world.")
        :WithHelpText("Usage:    renworld <NewName> [-filename]")
        :WithPermissionNode("RenWorld.command")
        :LuaCall(export.RenameWorld)
end

function RenWorld:Enabled()
end

function RenWorld:Disabled()
end

function RenWorld:WorldLoaded()
end

function RenWorld:RenameWorld( sender, args )
	local NewName = args[0]
	if NewName then -- Was there an argument provided?
		local OldName = Main.worldName -- Remember the old name.
		Main.worldName = NewName -- Set the name.
		Tools.WriteLine("World Name: " .. OldName .. " => " .. NewName) -- Tell user old name and new name for confirmation.

		if args[1] == "-filename" then -- Does he user want to also rename the file?
			Main.worldPathName = Globals.WorldPath .. "\\" .. NewName .. ".wld" -- Set the new path and filename. It's absolute (normally this is relative), but it doesn't matter.
			Tools.WriteLine("Renamed world file too.") -- Inform the console user that the filename was also renamed.
		end
		Tools.WriteLine("Please save the world for the changes to become permanent.") -- All done. Tell the user to save.
	end
end

export = RenWorld.create() --Ensure this exists, as TDSM needs this to find your plugin