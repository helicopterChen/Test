local Json = import( ".Json" )

local _tinsert 		= table.insert
local _strSub 		= string.sub
local _strFind 		= string.find
local _strFmt 		= string.format

local VECTOR_SEP = ","
local STRING_SEP = "\n"

--[[
	class JsonParser:	
		通用json格式的解析工具
]]		
local JsonParser  = {}

-- 解析格式常数
JsonParser.FMT_TYPE_TABLE = "t"  -- table/hash
JsonParser.FMT_TYPE_ARRAY = "a" -- 数组


function _splite( str, sep, f)
	if not str or not sep then
		return nil
	end

	local posBegin ,subStr
	local ret = {}
	while str ~= "" do

		posBegin 	= _strFind(str, sep)  	
		if posBegin == nil then
			subStr 	= str
			str 	= ""
		else
			subStr 	= _strSub(str, 0, posBegin - 1)
			str 	= _strSub(str, posBegin + 1, -1)
		end

		if f then
			subStr = f(subStr)
		end
		_tinsert(ret, subStr)
	end 

	return ret
end

local function lfStrSafeToNumber( str )
	return tonumber(str) or 0
end

local function lfStrSafeToInt( str )
	local num = math.floor(lfStrSafeToNumber(str))
	return num
end

-- 设置表格中vector类型的分割符
function JsonParser.setVECTOR_SEP( sep )
	VECTOR_SEP = sep or ","
end

-- ul标准json中用到的
function JsonParser.Value( vType, strValue)
	if vType == "I" then
		local errInfo = nil
		local num
		if strValue == "" then
			num = 0
		else
			num = tonumber(strValue)
			if not num then
				num = 0
				errInfo = "Parse I failed ("..strValue..")"
			end
		end				
		return num, errInfo
    elseif vType == "I2" then
        local vars = _splite(strValue, VECTOR_SEP, lfStrSafeToNumber)
        local values = {x = vars[1] or 0, y = vars[2] or 0}
        return values, nil
    elseif vType == "I3" then
        local vars = _splite(strValue, VECTOR_SEP, lfStrSafeToNumber)
        local values = {x = vars[1] or 0, y = vars[2] or 0, z = vars[3] or 0}
        return values, nil
	elseif vType == "S" then
		return strValue, nil
	elseif vType == "IV" then
		local vars = _splite(strValue, VECTOR_SEP, lfStrSafeToNumber)
		return vars, nil
	elseif vType == "SV" then
		local vars = _splite(strValue, VECTOR_SEP)
		return vars, nil
	elseif vType == "B" then
		local vars = ( strValue == "true" or strValue == "TRUE" )
		return vars, nil
	elseif vType == "R" then
		if strValue == "" then
			return nil, nil
		else
			return _G[strValue], nil
		end
	elseif vType == "RV" then
		if not strValue or strValue == "" then return {},nil end
		local tmpVars = _splite(strValue, VECTOR_SEP)
		local vars = {}
		for i,strTmp in ipairs(tmpVars) do
			if strTmp ~= "" then
				vars[i] = _G[strTmp]
			end
		end

		return vars, nil

	elseif vType == "T" then
		local t = loadstring( 'return ' .. strValue )()
		return t, nil		
	else
		return nil, "unknow type " .. vType
	end
	return nil, "Parse failed"
end


-- 将一个原始的标准json表格转化为struct方式的table
-- needP2K 
-- 		true 表示需要用P2K表对fields进行一次转换
function JsonParser.ToStructList(fileName , needP2K)
    --Logger.warn(fileName)

	--local jsonStr = string.fromfile(fileName)
	-- caosi_debug("jsonStr", jsonStr)	
	--if not jsonStr then return nil end
	--local jsont = Json.Decode(jsonStr)
	local fileData = cc.HelperFunc:getFileData( "res/" .. fileName ) or ""
    local jsont = Json.Decode(fileData)

	local types = jsont.types
	local fields = jsont.fields
	local values =  jsont.values 

	if needP2K then
		-- 需要进行一次key转换
		local newKeyName
		for k,srcKeyName in pairs(fields) do
			newKeyName = gfP2KGet(srcKeyName) 
			if not newKeyName then
				Logger.error("JsonParser.ToStructList, needP2K key err", srcKeyName, fileName)
			else
				fields[k] = newKeyName
			end
		end
	end


	local ret = {}
	local t, var, err
	for k, v in pairs(values) do
		t = {}
		table.insert(ret , t)

		for i,vv in pairs(v)  do
			var, err = JsonParser.Value( types[i], vv)
			if err ~= nil then
				Logger.warn("JsonParser.ToStructList() unknow type", fileName, err, types[i], i, vv )
			else
				t[fields[i]] =  var								
			end
		end
	end
	return ret
end


-- 将指定的通用json文件中的数据载入到内存中， 成为一个有唯一索引的列表
-- vector 		用于存放载入后数据的table
-- fileName		原始json文件
-- needP2K 		是否需要将key进行P2K字典转换
-- keyName 		作为唯一索引的数据的key的名称
function JsonParser.ToHash( vector, fileName , needP2K, keyName)
	if true then
		local fmts = {
			{ JsonParser.FMT_TYPE_TABLE, keyName }
		}
		return JsonParser.parseFile(vector, fileName, needP2K, fmts)		
	end
	-- local vars = JsonParser.ToStructList( fileName, needP2K )
	-- local id, objOrg
	-- local count = 0
	-- local total = 0

	-- for _, obj in pairs(vars) do
	-- 	-- Logger.printTable(obj)
	-- 	id = obj[ keyName ]
	-- 	objOrg = vector[ id ]
	-- 	if objOrg ~= nil then
	-- 		Logger.error("JsonParser.ToHash redefined",fileName, id, objOrg[ keyName ]  , obj[ keyName ])
	-- 	else
	-- 		count = count + 1
	-- 	end
	-- 	vector[ id ] = obj
	-- 	total = total + 1
	-- end
	-- return total, count -- 返回总数和有效数量
end

-- 单条数据格式化处理
local function _fmtParseBase( vector, value, fmts,fmtsLen, fmtIndex )
	local curFmt = fmts[fmtIndex] -- 本层解析到的格式
	local curFmtType = curFmt[1]

	if curFmtType == JsonParser.FMT_TYPE_TABLE then
		local nextFmt 		= fmts[fmtIndex + 1] -- 下一层的格式
		local nextFmtType 	= ( nextFmt and nextFmt[1] ) -- 下一层的格式类型		
		local keyName 		= curFmt[2]
		local keyValue 		= value[keyName]
		local list 			= vector[keyValue]

		-- 下一级处理
		if nextFmtType == JsonParser.FMT_TYPE_TABLE then
			if not list then
				vector[keyValue] = {}
			end
			-- 继续递归
			return _fmtParseBase(vector[keyValue], value, fmts, fmtsLen, fmtIndex + 1)	
		elseif nextFmtType == JsonParser.FMT_TYPE_ARRAY then
			if not list then
				vector[keyValue] = {}
			end
			-- 放入列表中， 结束
			table.insert(vector[keyValue], value)
			return true
		elseif nextFmtType == nil then -- 直接处理数据
			if list then
				Logger.warn("data redefined")
				--Logger.printTable(list)
				--Logger.printTable(value)
			end
			-- 数据到位， 结束
			vector[keyValue] = value	
			return true
		else
			Logger.warn("unknow nextFmt type", nextFmtType)
		end
	elseif curFmtType == JsonParser.FMT_TYPE_ARRAY then
		-- 放入列表中， 结束
		table.insert(vector, value)
		return true
	else
		Logger.warn("invalied curFmtType type", curFmtType)
	end 
	return false
end


--[[
fmtList = {
	{JsonParser.FMT_TYPE_TABLE, keyName}
	{JsonParser.FMT_TYPE_ARRAY}
}
]]
function JsonParser.parseFile( vector, fileName , needP2K, fmtList)
	local vars = JsonParser.ToStructList( fileName, needP2K )
	if not vars then return nil end
	local fmtsLen = #fmtList
	local fmt, count


	-- 格式预处理
	local fmts = {}
	local total = 0
	count = 0
	for i=1, fmtsLen do
		fmt = fmtList[i]
		table.insert(fmts, fmt)
		count = count + 1
		if fmt[1] == JsonParser.FMT_TYPE_ARRAY then -- 数组只能作为最后一层
			break
		end
	end
	fmtsLen = count -- 实际的格式长度

	-- 遍历数据列表
	count = 0
	for k, obj in pairs(vars) do
		if _fmtParseBase(vector, obj, fmts, fmtsLen, 1) then
			count = count + 1
		else
			Logger.error("JsonParser.parseFile err",fileName, k )
		end
		total = total + 1
	end
	return total, count -- 返回总数和有效数量
end

function JsonParser.parseFileEx( vector, fileName, needP2K, bIsArray )
	local fmtList = {{JsonParser.FMT_TYPE_TABLE, "id"},}
	if bIsArray == true then
		fmtList = {{JsonParser.FMT_TYPE_TABLE, "id"},  {JsonParser.FMT_TYPE_ARRAY}}
	end
	return JsonParser.parseFile( vector, fileName , needP2K, fmtList)
end

return JsonParser