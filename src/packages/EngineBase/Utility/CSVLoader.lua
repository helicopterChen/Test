local CSVLoader = {}
function CSVLoader.ReadCsvFile( sFileName, nDataBeginLine )
	nDataBeginLine = nDataBeginLine or 1
	local tHeaderData = {}
	local tChHeaderData = {}
	local tData = {}
	local tDataType = {}
	local tAttriData = {}
	local sFullFilePath = GET_FULL_FILE_PATH( sFileName )
	local sStringData = nil
	local oFile = io.open( sFullFilePath, "r" )
	if oFile ~= nil then
		sStringData = oFile:read( "*a" )
		oFile:close()
	end
	if sStringData == nil then
		return
	end
	local sTempString = string.gsub( sStringData, '\r\n', '\n' )
	sTempString = string.gsub( sStringData, '\r', '\n' )
    local tLinesData = string.split( sTempString, '\n')
    if tLinesData == nil then
    	return
    end
	local tLineData = {}
	for __, sLine in ipairs(tLinesData) do
		if sLine ~= nil and sLine ~= "" then
			local sTempStr =  string.gsub( sLine, '\r\n', '' )
			sTempStr =  string.gsub( sLine, '\n', '' )
			sTempStr =  string.gsub( sLine, '\r', '' )
			local tTempData = string.split( sTempStr, ',' )
			if tTempData ~= nil then
				if __ >= nDataBeginLine then
					tLineData[#tLineData+1] = tTempData
				elseif __ == 1 then --header名称
					tChHeaderData = tTempData
				end
			end
		end
	end
	--check
	tHeaderData = tLineData[1]
	tDataType = tLineData[2]
	for i = 3, #tLineData do
		local tTempData = {}
		for nIdx, sAttriName in ipairs( tHeaderData ) do
			local sType = tDataType[nIdx]
			local sVal = tLineData[i][nIdx]
			if sType ~= nil and sAttriName ~= nil and sVal ~= nil then
				--处理Con.1 Con.2 Con.3 为Con = { [1] =xx1,[2]=xx2,[3]=xx3 }
				if string.find( sAttriName, "%." ) ~= nil then	
					local nPointPos = string.find( sAttriName, "%." )
					local sTableName = string.sub( sAttriName, 1, nPointPos - 1)
					local nIndex = tonumber(string.sub( sAttriName, nPointPos + 1, -1 ))
					if tTempData[sTableName] == nil then
						tTempData[sTableName] = {}
					end
					if sType == "number" then
						tTempData[sTableName][nIndex] = tonumber(sVal) or 0
					elseif sType == "string" then
						tTempData[sTableName][nIndex] = tostring(sVal) or ""
					end
				else
					if sType == "number" then
						tTempData[sAttriName] = tonumber(sVal) or 0
					elseif sType == "string" then
						tTempData[sAttriName] = tostring(sVal) or ""
					end
				end
			end
		end
		tAttriData[#tAttriData+1] = tTempData
		tData[#tData+1] = tLineData[i]
	end
    return tHeaderData, tData, tAttriData, tDataType, tChHeaderData
end

return CSVLoader