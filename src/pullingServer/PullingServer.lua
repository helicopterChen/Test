_G.ENGINE_BASE = cc.load( "EngineBase" )
require("PullingServer.init")
local TableUtility = _G.ENGINE_BASE.TableUtility
local DataQueue = _G.ENGINE_BASE.DataQueue
local PullingServer = class("PullingServer", _G.ENGINE_BASE.AppBase )
local StockRequest = import( ".StockRequest" )
local Json = _G.ENGINE_BASE.Json
SYS_LOG("[start] PullingServer")
---------------------------------------------------------------------------------------------------------------------------------------------------
function PullingServer:ctor()
    self.super.ctor(self)
    self.m_oStockRequest = StockRequest:GetInstance()
    self.m_tServerConfigData = {}
    self.m_tDataUpdateMap = {}
    self.m_tStockRequestQueue = DataQueue:create()
end

function PullingServer:Run()
    self:SetUpdateRate(150)
    self:LoadServerConfig()
    self.m_oStockRequest:SendStockListRequest()
    self:InitConfig()
    self:SaveServerConfData()
    self:DefaultRun()
end

function PullingServer:SaveServerConfData()
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
	self.m_tDataUpdated = self.m_tServerConfigData.stock_update or {}
end

function PullingServer:InitConfig()
	SYS_LOG( "[Loading]: all_stocks.csv" )
	self.m_oDataManager:LoadCsvData( 1, "all_stocks.csv", "AllStockConf", "code" )
	local tAllStockConf = self.m_oDataManager:GetDataByName( "AllStockConf" )
	if tAllStockConf ~= nil then
		for i, v in pairs(tAllStockConf) do
			if self.m_tDataUpdated[tostring(v.code)] == nil then
				self.m_tStockRequestQueue:InQueue( tostring(v.code) )
			end
		end
	end
	SYS_LOG( "[Loading]: all_stocks.csv loaded" )
end

function PullingServer:Update( dt )
	if self.m_oStockRequest ~= nil and self.m_tStockRequestQueue ~= nil then
		local nCurLeftCount = self.m_tStockRequestQueue:Count()
		if self.m_nLastLeftCount ~= nCurLeftCount and self.m_tStockRequestQueue:Count() % 50 == 0 then
			SYS_LOG( string.format( "[Loading]: %s data request left", self.m_tStockRequestQueue:Count() ) )
			self.m_nLastLeftCount = nCurLeftCount
		end
		self.m_oStockRequest:SendStockHistoryDataRequest( self.m_tStockRequestQueue )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return PullingServer
