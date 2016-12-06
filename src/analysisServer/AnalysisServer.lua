print("AnalysisServer")
_G.ENGINE_BASE = cc.load( "EngineBase" ) 
require("analysisServer.init")
local TableUtility = _G.ENGINE_BASE.TableUtility
local AnalysisServer = class("AnalysisServer", _G.ENGINE_BASE.AppBase )
local StrategyManager = import(".StrategyManager")
local CSVLoader = _G.ENGINE_BASE.CSVLoader

function AnalysisServer:ctor()
    self.super.ctor(self)
    self.m_oStrategyManager = StrategyManager:GetInstance()
end

function AnalysisServer:Run()
    self:SetUpdateRate(20)
    self:InitConfig()
    self:DefaultRun()
end

function AnalysisServer:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )
	self.m_oDataManager:LoadCsvData( 1, "select_cond.csv", "SelectCondConf", "id" )
	self.m_oStrategyManager:CreateStrategy( 10002 )
	-- local tHeaderData, tData, tAttriData, tDataType, tChHeaderData = CSVLoader.ReadCsvFile( "all_stocks.csv", 1 )
	-- local sHeaders1 = ""
	-- local sHeaders2 = "\n"
	-- for i, v in pairs(tHeaderData) do
	-- 	if tDataType[i] == "number" then
	-- 		sHeaders1 = sHeaders1 .. string.format("%s.min",v) .. "," .. string.format("%s.max",v) .. ","
	-- 		sHeaders2 = sHeaders2 .. "number,number,"
	-- 	else
	-- 		sHeaders1 = sHeaders1 .. v .. ","
	-- 		sHeaders2 = sHeaders2 .. "string,"
	-- 	end
	-- end
	-- local sSaveStr = string.sub(sHeaders1,1,-2) .. string.sub(sHeaders2,1,-2)
	-- local oFile = io.open( "D:/Test.csv", "w")
	-- if oFile ~= nil then
	-- 	oFile:write(sSaveStr)
	-- 	oFile:close()
	-- end
end

function AnalysisServer:Update( dt )
	self.m_oStrategyManager:Update(dt)
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return AnalysisServer
