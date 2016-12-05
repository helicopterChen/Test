require "iuplua"
require "iupluacontrols"
local luaSqlite3 = require "luasql.sqlite3"

-- local ENV = assert(luasql.sqlite3())
-- local conn = ENV:connect( GET_FULL_FILE_PATH("swc.db") )
-- local res = assert(conn:execute( [[SELECT * FROM people;]] ) )
local Editor = class("Editor" )

-- function rows ( cursor )
-- 	return function ()
-- 	    return cursor:fetch()
-- 	end
-- end

-- for name, email, test in rows( res ) do
--     print(string.format("%s %s %s",name,email,test))
-- end

-- res:close()  

-- conn:close()  

-- ENV:close()  
function Editor:ctor()
end

function Editor:Init()	
end

function Editor:Run()
	local tree = iup.tree{}


	item_exit = iup.item {title = "Exit", key = "K_x"}

	function item_exit:action()
	  	os.exit()
	end

	-- Creates two menus
	menu_file = iup.menu {item_exit}

	-- Creates two submenus
	submenu_file = iup.submenu {menu_file; title = "File"}

	-- Creates main menu with two submenus
	menu = iup.menu {submenu_file}

	local dlg = iup.dialog{tree ; title = "TableTree result", size = "200x200", menu = menu }
	dlg:showxy(iup.CENTER,iup.CENTER)

	local tListData = 
	{
		branchname = "stocks"
	}
	local tAllStockConf = GAME_APP.m_oDataManager:GetDataByName( "AllStockConf" )
	for i, v in pairs(tAllStockConf) do
		table.insert(tListData, string.format( "%s(%s)", v.code,v.name) )
	end
	iup.TreeAddNodes(tree, tListData)	
end

return Editor