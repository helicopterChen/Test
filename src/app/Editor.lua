require "iuplua"
require "iupluacontrols"
require "task"

local luaSqlite3 = require "luasql.sqlite3"

http = require "socket.http"
local ltn12 = require("ltn12")

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
	local oTree = iup.tree{}

	local ml = iup.multiline{expand="YES", value="", border="YES", size="400x100"}
	local mat= iup.matrix{numlin=0, numcol=6, scrollbar="YES", widthdef=45}
	mat.resizematrix = "YES"
	mat.SORTSIGNn = "DOWN"

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


	local dlg = iup.dialog{ iup.hbox{ oTree, iup.frame{ mat, size="400x100"} }; title = "TableTree result", size = "600x200", menu = menu }
	dlg:showxy(iup.CENTER,iup.CENTER)

	oTree.m_sSelectName = ""
	oTree.name = "Test"
	function oTree:selection_cb(id,iselect)
		if iselect == 1 then
			oTree.m_sSelectName = oTree.name
		end
	end
	mat:setcell(0,0,"")
	mat:setcell(0,1,"date")
	mat:setcell(0,2,"open")
	mat:setcell(0,3,"close")
	mat:setcell(0,4,"volume")
	mat:setcell(0,5,"range")
	mat:setcell(0,6,"change")

	function oTree:executeleaf_cb()
		local sName = oTree.m_sSelectName
		if sName ~= nil then
			local tToken = string.split( sName, '(' )
			if tToken ~= nil and #tToken == 2 then
				local sCode = tToken[1]
				local sName = string.sub( tToken[2], 1, -2 )
				if sCode ~= nil and sName ~= nil then
					GAME_APP:LoadStockHistoryData( sCode )
					local tStockData = GAME_APP:GetStockHistoryData(sCode)
					if tStockData ~= nil then
						mat.NUMLIN = #tStockData + 1
						local nSize = #tStockData + 1
						for i, v in pairs(tStockData) do
							mat:setcell( nSize-i,1,v[1])
							mat:setcell( nSize-i,2,v[2])
							mat:setcell( nSize-i,3,v[4])
							mat:setcell( nSize-i,4,v[6])
							mat:setcell( nSize-i,5,string.format("%s%%",v[8]) )
							mat:setcell( nSize-i,6,v[7])
						end
					end
					iup.Update(mat)
				end
			end
		end
	end
	local tNodeData = {}
	local tAllStockConf = GAME_APP.m_oDataManager:GetDataByName( "AllStockConf" )
	for i, v in pairs(tAllStockConf) do
		table.insert( tNodeData, v )
	end	
	table.sort( tNodeData, function(a,b) return tonumber(a.code) > tonumber(b.code) end )
	for i, v in pairs(tNodeData) do
		oTree.addleaf = string.format( "%s(%s)", v.code, v.name )
	end
end

function _code_to_symbol( sCode )
	local sFirst = string.sub( sCode, 1, 1 )
	local sRet = ""
	if sFirst == '5' or sFirst == '6' or sFirst == '9' then
		sRet = string.format( 'sh%s', sCode )
	else
		sRet = string.format( 'sz%s', sCode )
	end
	return sRet
end

return Editor