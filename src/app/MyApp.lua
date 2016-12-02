_G.ENGINE_BASE = cc.load( "EngineBase" )
require("app.init")

local MyApp = class("MyApp", _G.ENGINE_BASE.AppBase )

function MyApp:ctor()
    self.super.ctor(self)
end

function MyApp:Run()
    self:SetUpdateRate(20)
    self:DefaultRun()
end

function MyApp:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return MyApp
