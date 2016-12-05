print("DataServer")
_G.ENGINE_BASE = cc.load( "EngineBase" )
require("dataServer.init")
local TableUtility = _G.ENGINE_BASE.TableUtility
local DataServer = class("DataServer", _G.ENGINE_BASE.AppBase )
local luaSqlite3 = require "luasql.sqlite3"
require "task"
function DataServer:ctor()
    self.super.ctor(self)
end

function DataServer:Run()
    self:SetUpdateRate(20)
    self:InitConfig()
    self:DefaultRun()
end

function DataServer:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )

	local ENV = assert(luasql.sqlite3())
	local tAllStockConf = self.m_oDataManager:GetDataByName( "AllStockConf" )
	local tBranchExecute = {}
	local conn = ENV:connect( GET_FULL_FILE_PATH("swc.db") )
	conn:execute( "DELETE FROM stocks;" )
	conn:close()  
	for i, v in pairs( tAllStockConf ) do
		local sAttris = ""
		local sValues = ""
		for attriName, val in pairs(v) do
			sAttris = sAttris .. string.format( "'%s',", attriName )
			sValues = sValues .. string.format( "'%s',", val )
		end
		table.insert( tBranchExecute,string.format("INSERT INTO stocks(%s) VALUES(%s);", string.sub(sAttris,1,-2), string.sub(sValues,1,-2) ) )
		if #tBranchExecute >= 50 then
			local conn = ENV:connect( GET_FULL_FILE_PATH("swc.db") )
			for idx, val in ipairs(tBranchExecute) do
				conn:execute( val );
			end
			tBranchExecute = {}
			task.sleep(30)
			conn:close()  
		end
	end
	local conn = ENV:connect( GET_FULL_FILE_PATH("swc.db") )
	for idx, val in ipairs(tBranchExecute) do
		conn:execute( val );
	end
	tBranchExecute = {}
	task.sleep(30)
	conn:close()  
	print( "finish--insert" )
	-- local res = assert(conn:execute( [[SELECT * FROM people;]] ) )
	-- function rows ( cursor )
	-- 	return function ()
	-- 	    return cursor:fetch()
	-- 	end
	-- end

	-- for name, email, test in rows( res ) do
	--     print(string.format("%s %s %s",name,email,test))
	-- end
	ENV:close()  

end

function DataServer:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return DataServer
