--为了保证之后游戏运行流畅,UIjson文件的解析一般都放到loading的时候进行预加载
local CDataManager = class("CDataManager")
local CSVLoader = import( "..Utility.CSVLoader" )
local TableUtility = import("..Utility.TableUtility")
local JsonParser = import("..Utility.JsonParser")

function CDataManager:ctor()
	self.m_tNameDataMap = {}
	self.m_tNameCsvDataMap = {}
	self.m_tJsonFileDataMap = {}
end

function CDataManager:GetInstance()
	if _G.__DataManagerInstance == nil then
		_G.__DataManagerInstance = CDataManager:create()
	end
	return _G.__DataManagerInstance
end

function CDataManager:SetGameApp( oGameApp )
	self.m_oGameApp = oGameApp
end

function CDataManager:GetGameApp()
	return self.m_oGameApp
end

function CDataManager:LoadCsvData( nDataBegin, sFileName, sDataName, sKeyAttri, pCallback )
	nDataBegin = nDataBegin or 1
	--json文件数据和csv文件数据共用一个map,但是需要保证他们不重名
	if self.m_tNameDataMap[sDataName] ~= nil then
		assert( false )
	end
	local tHeaderData, tData, tAttriData, tDataType, tChHeaderData = CSVLoader.ReadCsvFile( sFileName, nDataBegin )
	if sKeyAttri == nil or sKeyAttri == "" then
		self.m_tNameDataMap[ sDataName ] = tData
		self.m_tNameCsvDataMap[ sDataName ] = { tHeaderData, tData, tAttriData, tDataType, tChHeaderData }
		return tData
	end
	local tCsvData = {}
	for i, v in ipairs( tAttriData ) do
		if v[sKeyAttri] ~= nil then
			local nKeyVal = tonumber(v[sKeyAttri])
			if nKeyVal ~= nil then
				tCsvData[nKeyVal] = v
			else
				tCsvData[v[sKeyAttri]] = v
			end
		end
	end
	self.m_tNameDataMap[ sDataName ] = tCsvData
	self.m_tNameCsvDataMap[ sDataName ] = { tHeaderData, tData, tAttriData, tDataType, tChHeaderData }
	--_G.CC_LOG( string.format( string.format( "Load CSV OK: [%s-<%s>] %s", sDataName, sKeyAttri, sFileName ) ) )
	if pCallback ~= nil then
		pCallback( self, sDataName, tCsvData )
	end
	return tCsvData
end

function CDataManager:GetDataByName( sDataName )
	return self.m_tNameDataMap[ sDataName ]
end

function CDataManager:GetDataByNameAndId( sDataName, nId )
	local tConfData = self:GetDataByName( sDataName )
	if tConfData ~= nil then
		return tConfData[nId]
	end
end

function CDataManager:GetCsvFileData( sDataName )
	if self.m_tNameCsvDataMap[ sDataName ] ~= nil then
		return self.m_tNameCsvDataMap[ sDataName ]
	end
end

function CDataManager:SetDataByName( sDataName, tData )
	--配置文件只能设置一次,如果多次设置则
	assert( self.m_tNameDataMap[sDataName] == nil )
	self.m_tNameDataMap[sDataName] = tData
end

function CDataManager:ClearDataByName( sDataName )
	self.m_tNameDataMap[sDataName] = nil
end

function CDataManager:LoadJsonData( sFileName, sDataName, bNeedConvert, bIsArray )
	--json文件数据和csv文件数据共用一个map,但是需要保证他们不重名
	if self.m_tNameDataMap[sDataName] ~= nil then
		assert( false )
	end
	local tJsonData = nil
	if bNeedConvert ~= true then
		tJsonData = self:GetJsonFileData( sFileName )
		assert( tJsonData ~= nil )
	else
		JsonParser.setVECTOR_SEP( "|" )
		tJsonData = {}
		JsonParser.parseFileEx( tJsonData, sFileName, false, bIsArray )
	end
	self.m_tNameDataMap[ sDataName ] = tJsonData
	return tJsonData
end

function CDataManager:GetJsonFileData( sFileName )
	if self.m_tJsonFileDataMap[ sFileName ] ~= nil then
		return self.m_tJsonFileDataMap[ sFileName ]
	end
	local sFileStr = GET_FULL_FILE_PATH( sFileName )
	assert( sFileStr ~= nil )
	local tJsonData = _G.JSON.Decode( sFileStr )
	assert( tJsonData ~= nil )
	self.m_tJsonFileDataMap[sFileName] = tJsonData
	return tJsonData
end

return CDataManager