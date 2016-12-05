_G.ENGINE_BASE = cc.load( "EngineBase" )
require("app.init")
local Editor = import(".Editor")
local TableUtility = _G.ENGINE_BASE.TableUtility
local MyApp = class("MyApp", _G.ENGINE_BASE.AppBase )

function MyApp:ctor()
    self.super.ctor(self)
end

function MyApp:Run()
    self:SetUpdateRate(20)
    self:InitConfig()
    Editor:new():Run()
    self:DefaultRun()
end

function MyApp:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )
end

function MyApp:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return MyApp
