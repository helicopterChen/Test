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
end

function AnalysisServer:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return AnalysisServer
