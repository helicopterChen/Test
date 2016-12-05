local TableUtility = {}

TableUtility.SPACE_DELTA = "  "

function TableUtility.GetDataString( tData, sSpace )
	if( sSpace == nil ) then
		sSpace = ""
	end
	local sDataStr = ""
	if( type(tData) == "table" ) then
		sDataStr = "{\n"
		for i, v in pairs( tData ) do
			if(	type(v) ~= "table" ) then
				local valStr = v
				if( type(v) == "string" ) then
					valStr = string.format("\'%s\'",v  )
				end
				if( tonumber(i) ~= nil ) then
					sDataStr = sDataStr .. sSpace .. TableUtility.SPACE_DELTA .. string.format( "[%s] = %s,\n", tostring(i), tostring( valStr ) )
				else
					sDataStr = sDataStr .. sSpace .. TableUtility.SPACE_DELTA .. string.format( "%s = %s,\n", tostring(i), tostring( valStr ) )
				end
			else
				if( tonumber(i) ~= nil ) then
					sDataStr = sDataStr ..  sSpace .. TableUtility.SPACE_DELTA .. string.format( "[%s]=\n", tostring(i) )
				else
					sDataStr = sDataStr ..  sSpace .. TableUtility.SPACE_DELTA .. string.format( "%s=\n", tostring(i) )
				end
				sDataStr = sDataStr ..  sSpace .. TableUtility.SPACE_DELTA .. TableUtility.GetDataString( v, sSpace .. TableUtility.SPACE_DELTA )
			end
		end
		sDataStr = sDataStr .. sSpace .. "}\n"
	elseif( type(tData) == "nil") then
		return "nil"
	else
		sDataStr = tostring(tData)
	end
	return sDataStr
end

function TableUtility.ConvertNumberData( tData )
	for i, v in pairs( tData ) do
		if tonumber(v) ~= nil then
			tData[i] = tonumber(v)
		elseif type( v ) == "table" then
			TableUtility.ConvertNumberData( v )
		end
	end
end


function TableUtility.PrintTable( tTableData )
	if( type(tTableData) ~= "table" ) then
		print( "Not table!" )
		return
	end
	print( TableUtility.GetDataString( tTableData ) )
end

function TableUtility.PrintTableSimple( tTableData )
	if( type(tTableData) ~= "table" ) then
		print( "Not table!" )
		return
	end
	for i, v in pairs(tTableData) do
		print( i, v )
	end
end

function TableUtility.CopyTable( tTableData )
	if tTableData == nil then
		return
	end
	local tTableCopyed = {}
	for k, v in pairs(tTableData) do
		local key,value = nil,nil
		if( type(k) == "table" ) then
			key = TableUtility.CopyTable( k )
		else
			key = k
		end
		if( type(v) == "table" ) then
			value = TableUtility.CopyTable( v )
		else
			value = v
		end
		tTableCopyed[key] = value
	end
	return tTableCopyed
end

function TableUtility.GetTableString( tData )
	return TableUtility.GetDataString( tTableData )
end

function TableUtility.LoadTableFromString( string )
	
end

function TableUtility.GetStringKeyTable( tData )
	local tTable = {}
	for i, v in pairs( tData ) do
		if type(v) == 'number' or type(v) == 'string' then
			tTable[tostring(i)] = v
		elseif type(v) == 'table' then
			tTable[tostring(i)] = TableUtility.GetStringKeyTable( v )
		end
	end
	return tTable
end

function TableUtility.GetNumberKeyTable( tData )
	local tTable = {}
	for i, v in pairs( tData ) do
		if type(v) == 'number' or type(v) == 'string' then
			local key = tonumber( i ) or i
			tTable[key] = v
		elseif type(v) == 'table' then
			local key = tonumber( i ) or i
			tTable[key] = TableUtility.GetNumberKeyTable( v )
		end
	end
	return tTable
end

return TableUtility