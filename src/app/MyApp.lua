print("MyApp")
_G.ENGINE_BASE = cc.load( "EngineBase" )
require("app.init")
local Editor = import(".Editor")
local TableUtility = _G.ENGINE_BASE.TableUtility
local MyApp = class("MyApp", _G.ENGINE_BASE.AppBase )
local Json = _G.ENGINE_BASE.Json

function MyApp:ctor()
    self.super.ctor(self)
    self.m_tHistoryData = {}
end

function MyApp:Run()
    self:SetUpdateRate(20)
    self:InitConfig()
    Editor:new():Run()
    self:DefaultRun()
end

function MyApp:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )

	local tAllAttris = {}
	local tAllStockConf = self.m_oDataManager:GetDataByName( "AllStockConf" )
	if tAllStockConf ~= nil then
		for i, v in pairs(tAllStockConf) do
			for attri, val in pairs(v) do
				if attri == "pb" then
					if type(val) == "number" then
						if tAllAttris[attri] == nil then
							tAllAttris[attri] = {}
						end
						local tAttriStastics = tAllAttris[attri]
						if tAttriStastics ~= nil then
							val = val * 100
							if val > 0 and val < 1000 then
								if tAttriStastics[val] == nil then
									tAttriStastics[val] = 1
								else
									tAttriStastics[val] = tAttriStastics[val] + 1
								end
							end
						end
					end
				end
			end
		end
		self.m_tPE = tAllAttris.pb
		local oFile = io.open( GET_FULL_FILE_PATH( "stastics.txt" ), "w" )
		oFile:write(TableUtility.GetDataString(self.m_tPE) )
		oFile:close()
	end
end

function MyApp:GetStockHistoryData( sCode )
	return self.m_tHistoryData[sCode]
end

function MyApp:SetStockHistoryData( sCode, tData )
	self.m_tHistoryData[sCode] = tData
end

function MyApp:LoadStockHistoryData( sCode )
	if self.m_tHistoryData[sCode] ~= nil then
		return
	end
	local oFile = io.open( GET_FULL_FILE_PATH(string.format("stocks_data/%s.json", sCode )), "r" )
	if oFile ~= nil then
		local sData = oFile:read( "*a" )
		if sData ~= nil then
			local tData = Json.Decode( sData )
			if tData ~= nil then
				self:SetStockHistoryData( sCode, tData.record )
			end
		end
		oFile:close()
	end
end

function MyApp:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return MyApp
