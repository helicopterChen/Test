local TimeUtility = _G.ENGINE_BASE.TimeUtility
local TableUtility = _G.ENGINE_BASE.TableUtility
local ltn12 = require("ltn12")
local http = require "socket.http"
local StockRequest = {}
---------------------------------------------------------------------------------------------------------------------------------------------------
function StockRequest.SendStockListRequest()
	SYS_LOG( "[Loading]: Sending stockList request." )
	local nStockListUpdateTime = GAME_APP:GetServerConfVal( "stock_list_update_time" ) or 0
	local tUpdateTimeData = TimeUtility.GetDateTimeEx( nStockListUpdateTime )
	local tNowTimeData, nNowTimeVal = TimeUtility.GetDateTimeEx()
	local bNeedUpdate = false
	if tUpdateTimeData ~= nil then
		if nNowTimeVal > nStockListUpdateTime then
			if tNowTimeData.Year > tUpdateTimeData.Year or 
			   tNowTimeData.Month > tUpdateTimeData.Month or 
			   tNowTimeData.Day > tUpdateTimeData.Day then
			   bNeedUpdate = true
			end
		end
	end
	if bNeedUpdate ~= true then
	   SYS_LOG( "[Loading]: No needs of update File: all_stocks.csv" )
	   return
	end
	local tDataTables = {}
	local tHeaders =  
	{
	  url = "http://218.244.146.57/static/all.csv",
	  sink = ltn12.sink.table(tDataTables)
	}
	local r, c = http.request( tHeaders )
	local sOriginHeader = "code,name,industry,area,pe,outstanding,totals,totalAssets,liquidAssets,fixedAssets,reserved,reservedPerShare,esp,bvps,pb,timeToMarket,undp,perundp,rev,profit,gpr,npr,holders"
	local sHeader = 
[[code,name,industry,area,pe,outstanding,totals,totalAssets,liquidAssets,fixedAssets,reserved,reservedPerShare,esp,bvps,pb,timeToMarket,undp,perundp,rev,profit,gpr,npr,holders
string,string,string,string,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number]]
	local sData = table.concat(tDataTables)
	sData = sHeader .. string.gsub( sData, sOriginHeader, "" )
	sData = string.gsub( sData, "\n\n", "\n" )
	sData = string.gsub( sData, "\r\n\r\n", "\r\n" )
	if sData ~= nil and sData ~= "" then
		local oFile = io.open( GET_FULL_FILE_PATH( "all_stocks.csv" ), "w" )
		if oFile ~= nil then
			oFile:write(sData)
			oFile:close()
			SYS_LOG( "[Loading]: Save Data To File: all_stocks.csv" )
			GAME_APP:SetServerConfVal( "stock_list_update_time", os.time())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return StockRequest