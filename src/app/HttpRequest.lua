local http = require "socket.http"
local ltn12 = require("ltn12")

local sCode = arg[1]

local function _code_to_symbol( sCode )
	local sFirst = string.sub( sCode, 1, 1 )
	local sRet = ""
	if sFirst == '5' or sFirst == '6' or sFirst == '9' then
		sRet = string.format( 'sh%s', sCode )
	else
		sRet = string.format( 'sz%s', sCode )
	end
	return sRet
end

local tTables = {}
local sUrl = string.format( "http://api.finance.ifeng.com/akdaily/?code=%s&type=last", _code_to_symbol(sCode) )
local r, c = http.request {
	url = sUrl,
	sink = ltn12.sink.table(tTables)
}
local s = table.concat(tTables)
local sPath = GET_FULL_FILE_PATH( string.format("/stocks_data/%s.json", sCode ) )
local oFile = io.open( sPath, "w" )
oFile:write(s)
oFile:close()