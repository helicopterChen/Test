_G.ENGINE_BASE = cc.load( "EngineBase" )
require("PullingServer.init")
local TableUtility = _G.ENGINE_BASE.TableUtility
local PullingServer = class("PullingServer", _G.ENGINE_BASE.AppBase )
local StockRequest = import( ".StockRequest" )
local Json = _G.ENGINE_BASE.Json
SYS_LOG("[start] PullingServer")
---------------------------------------------------------------------------------------------------------------------------------------------------
function PullingServer:ctor()
    self.super.ctor(self)
    self.m_tServerConfigData = {}
    self.m_tDataUpdateMap = {}
end

function PullingServer:Run()
    self:SetUpdateRate(20)
    self:LoadServerConfig()
    StockRequest.SendStockListRequest()
    self:InitConfig()
    self:CheckDataAfterLoad()
    self:DefaultRun()
end

function PullingServer:CheckDataAfterLoad()
	self:SaveDataToJson( "pull_server_conf.json", self.m_tServerConfigData )
end

function PullingServer:GetServerConfData()
	return self.m_tServerConfigData
end

function PullingServer:GetServerConfVal( sKey )
	return self.m_tServerConfigData[sKey]
end

function PullingServer:SetServerConfVal( sKey, val )
	self.m_tServerConfigData[sKey] = val
end

function PullingServer:LoadJsonData( sPath )
	local tData = {}
	local sFullPath = GET_FULL_FILE_PATH( sPath )
	local oFile = io.open( sFullPath, "r" )
	if oFile ~= nil then
		local sData = oFile:read( "*a" )
		oFile:close()
		if sData ~= nil and sData ~= "" then
			tData = Json.Decode(sData)
		end
	end
	return tData
end

function PullingServer:SaveDataToJson( sPath, tData )
	if tData == nil or type(tData) ~= "table" then
		return
	end
	local sData = Json.Encode(tData) or "{}"
	local sFullPath = GET_FULL_FILE_PATH( sPath )
	local oFile = io.open( sFullPath, "w" )
	if oFile ~= nil then
		oFile:write(sData)
		oFile:close()
	end
end

function PullingServer:LoadServerConfig()
	self.m_tServerConfigData = self:LoadJsonData( "pull_server_conf.json" ) or {}
end

function PullingServer:InitConfig()
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )
end

function PullingServer:Update( dt )

end
---------------------------------------------------------------------------------------------------------------------------------------------------
return PullingServer
