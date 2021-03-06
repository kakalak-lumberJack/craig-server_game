minetest.register_chatcommand("admin", {
	description = "Show the name of the server owner",
	func = function(name)
		local admin = minetest.setting_get("name")
		if admin then
			return true, "Admins: https://davison.io/minetest/craig-server#team"
		else
			return false, "There's no administrator named in the config file."
		end
	end,
})

minetest.register_chatcommand("mods", {
	params = "",
	description = "List mods installed on the server",
	privs = {},
	func = function(name, param)
		return true, "Mod List: https://github.com/davisonio/craig-server_game#mod-list"
	end,
})

-- Sethome command (from some old mod somewhere)
minetest.register_chatcommand("sethome", {
        params = "",
        description = "Set your home location.",
        privs = {shout=true},
        func = function(name, param)
                local player = minetest.get_player_by_name(name)
                test = player:getpos()
                local file = io.open(minetest.get_worldpath().."/home/"..player:get_player_name().."_home", "w")
                if not file then
                        minetest.chat_send_player(name, "There was an error, please contact the server owner.")
                        return
                end
                file:write(minetest.pos_to_string(test))
                file:close()
                minetest.chat_send_player(name, "Your home location is set! Type /home to teleport back here.")
        end
})

-- Home command (from some old mod somewhere)
minetest.register_chatcommand("home", {
	params = "",
	description = "Teleport to your home location.",
	privs = {shout=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local file = io.open(minetest.get_worldpath().."/home/"..player:get_player_name().."_home", "r")
		if not file then
			minetest.chat_send_player(name, "You haven't set your home! Set one using /sethome.")
			return
		end
		local line = file:read("*line")
		file:close()
		local pos = minetest.string_to_pos(string.sub(line, 1, string.find(line, ")")))
		if not pos or type(pos) ~= "table" then
			minetest.chat_send_player(name, "There was an error, please contact the server owner.")
			return
		end
		minetest.get_player_by_name(name):setpos(pos)
		minetest.chat_send_player(name, "Home sweet home.")
	end
})
