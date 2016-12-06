print("AnalysisServer")
_G.ENGINE_BASE = cc.load( "EngineBase" ) 
require("analysisServer.init")
local TableUtility = _G.ENGINE_BASE.TableUtility
local AnalysisServer = class("AnalysisServer", _G.ENGINE_BASE.AppBase )

function AnalysisServer:ctor()
    self.super.ctor(self)
end

function AnalysisServer:Run()
    self:SetUpdateRate(20)
    self:InitConfig()
    self:DefaultRun()
end

function AnalysisServer:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )
	local tAllStockConf = self.m_oDataManager:GetDataByName( "AllStockConf" )
	if tAllStockConf ~= nil then
		local tSelection = {}
		for i, v in pairs(tAllStockConf) do
			if v.pb < 1.3 and v.pb > 0 and v.profit > 0.1 and v.rev > 0.1 and v.outstanding < 10 then
				table.insert(tSelection, v)
			end
		end
		for i, v in ipairs(tSelection) do
			print( v.code, UTF8_TO_ASCII(v.name), v.pb, v.outstanding, v.rev, v.profit )
		end
	end
end

function AnalysisServer:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return AnalysisServer
