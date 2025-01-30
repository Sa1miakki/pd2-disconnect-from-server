_G.DFS = DFS or {}

function DFS:disconnect()
    local peer = managers.network._session:peer(1)
	if peer then
		if not Network:is_server() then
		    managers.network._session:on_peer_kicked(peer, 1, 1)
		    managers.network._session:send_to_peers("kick_peer", 1, 2)
        else
	      --Nothing
	    end
	end
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_DFS", function(loc)
    loc:add_localized_strings({
        ["dfs_title"] = "Disconnect from server"
    })
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_DFS", function(menu_manager, nodes)
    MenuCallbackHandler["dfs_confirm"] = function()
        QuickMenu:new(
            managers.localization:text("dialog_warning_title"),
            managers.localization:text("dialog_are_you_sure_you_want_to_leave_game"),
            {
                {
                    text = managers.localization:text("dialog_yes"),
                    callback = callback(DFS, DFS, "disconnect")
                },
                {
                    text = managers.localization:text("dialog_no"),
                    is_cancel_button = true
                }
            },
            true
        )
    end
	
    local menu = nodes.pause or nodes.lobby

    if menu and not Network:is_server() then
        local item = menu:item("dfs_menu_id")
		local data_node = {type = "CoreMenuItem.Item"}
		local param = {
			name = "dfs_title", 
            text_id = "dfs_title",
            callback = "dfs_confirm"
		}
        if not item then
            item = menu:create_item(data_node, param)
            menu:add_item(item)
        end
        
		item:set_enabled(true)
  
    end
end)
