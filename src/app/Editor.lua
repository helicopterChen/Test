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

	local dlg = iup.dialog{oTree ; title = "TableTree result", size = "200x200", menu = menu }
	dlg:showxy(iup.CENTER,iup.CENTER)

	oTree.m_sSelectName = ""
	oTree.name = "Test"
	function oTree:selection_cb(id,iselect)
		if iselect == 1 then
			oTree.m_sSelectName = oTree.name
		end
	end
	function oTree:executeleaf_cb()
		local sName = oTree.m_sSelectName
		if sName ~= nil then
			local tToken = string.split( sName, '(' )
			if tToken ~= nil and #tToken == 2 then
				local sCode = tToken[1]
				local sName = string.sub( tToken[2], 1, -2 )
				if sCode ~= nil and sName ~= nil then
					local tTables = {}
					local sUrl = string.format( "http://api.finance.ifeng.com/akdaily/?code=%s&type=last", _code_to_symbol(sCode) )
					local r, c = http.request {
						url = sUrl,
						sink = ltn12.sink.table(tTables)
					}
					local s = table.concat(tTables)
					local sPath = GET_FULL_FILE_PATH( string.format("/stocks_data/%s.json", sCode ) )
					local oFile = io.open( sPath, "w" )
					oFile:write(s)
					oFile:close()
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
		oTree.addleaf = string.format( "%s(%s)", v.code, UTF8_TO_ASCII(v.name) )
	end
	-- local nCount = 0
	-- for i, v in pairs(tAllStockConf) do
	-- 	RequestStocksData( _code_to_symbol(v.code) )
	-- 	nCount = nCount + 1
	-- 	if nCount % 3 == 0 then
	-- 		task.sleep( 750 )
	-- 	end
	-- end
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

local sMyscript = [[=
	local http = require "socket.http"
	local ltn12 = require("ltn12")
	local sCode = arg[1]
	print(sCode)
	local tTables = {}
	local sUrl = string.format( "http://api.finance.ifeng.com/akdaily/?code=%s&type=last", sCode )
	local r, c = http.request {
		url = sUrl,
		sink = ltn12.sink.table(tTables)
	}
	local s = table.concat(tTables)
	local sPath = string.format("E:/Test/res/stocks_data/%s.json", sCode )
	local oFile = io.open( sPath, "w" )
	oFile:write(s)
	oFile:close()
]]

function RequestStocksData( sCode )
	task.create( sMyscript, { tostring(sCode) } ) 
end

return Editor