local SRC_FILE_PATH = "C:/Users/buddygame-p1/Desktop/test_stock"
local PACK_PATH = package.path
package.path = string.format("%s;%s?.lua;%s?/init.lua", PACK_PATH, SRC_FILE_PATH, SRC_FILE_PATH) 


local alien = require 'alien'   
WinProc_types = { ret = "long", abi = "stdcall"; "pointer", "uint", "uint", "long" }   
alien.kernel32.MultiByteToWideChar:types{ abi="stdcall"; ret="int";   
    "long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpMultiByteStr]],   
    "long" --[[cbMultiByte]], "pointer" --[[lpWideCharStr]], "int" --[[cchWideChar]]}  
  
alien.kernel32.WideCharToMultiByte:types{ abi="stdcall"; ret="int";   
    "long" --[[CodePage]], "long" --[[dwFlags]], "pointer" --[[lpWideCharStr]],   
    "int" --[[cchWideChar]], "pointer" --[[lpMultiByteStr]], "int" --[[cbMultiByte]],  
    "string" --[[lpDefaultChar]], "pointer" --[[lpUsedDefaultChar]]}  
      
local CP_ACP  = 0;
local CP_UTF8 = 65001; 
  
function ASCII_TO_UTF8(str)   
    local codePage = CP_ACP;   
    local flags = 0;   
    local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, nil, 0);   
    local buffer = alien.buffer(2 * wide_len);   
    local res = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, buffer, wide_len);   
    -- 上面已转为 UTF-16 编码，下面再转为 UTF-8  
    codePage = CP_UTF8   
    local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil);  
    local res_buffer = alien.buffer(multi_len + 1);  
    res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len + 1, nil, nil);  
    return tostring(res_buffer);   
end  


function UTF8_TO_ASCII(str)   
    local codePage = CP_UTF8;   
    local flags = 0;   
    local wide_len = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, nil, 0);   
    local buffer = alien.buffer(2 * wide_len);   
    local res = alien.kernel32.MultiByteToWideChar(codePage, flags, str, #str+1, buffer, wide_len);   
    -- 上面已转为 UTF-16 编码，下面再转为 UTF-8  
    codePage = CP_ACP   
    local multi_len = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer ,  wide_len, nil, 0, nil, nil);  
    local res_buffer = alien.buffer(multi_len + 1);  
    res = alien.kernel32.WideCharToMultiByte(codePage, flags, buffer , wide_len, res_buffer, multi_len + 1, nil, nil);  
    return tostring(res_buffer);   
end  


socket = require "socket"
local ltn12 = require("ltn12")
local xml = require 'pl.xml'
local TableUtility = require "TableUtility"

print(socket._VERSION)
print("-------------------------------")

-- load required modules
http = require "socket.http"
mime = require "mime"

local tTables = {}
r, c, h = http.request {
  --url = "http://api.finance.ifeng.com/akdaily/?code=sz000651&type=last",
  url = "http://vip.stock.finance.sina.com.cn/q/go.php/vFinanceAnalyze/kind/mainindex/index.phtml?s_i=&s_a=&s_c=&reportdate=2014&quarter=2&p=1&num=3000",
  sink = ltn12.sink.table(tTables)
}
local s = table.concat(tTables)

local nBegin, nEnd = string.find(s, "<table class=\"list_table\" id=\"dataTable\">" )
local str = string.sub( s, nBegin, -1 )
local nBegin, nEnd = string.find( str, "</table>" )
str = string.sub( str, 1, nEnd )
str = string.gsub( str, '\t', '' )
str = string.gsub( str, '\n', '' )
local sTemp = string.gsub( str,"<span[^>]+>","" )
sTemp = string.gsub( sTemp,"</span>","" )
sTemp = string.gsub( sTemp,"<!--[^>]+>","" )
sTemp = string.gsub( sTemp,"<td style[^>]+>","<td>" )
sTemp = string.gsub( sTemp,"<a href[^>]+>","" )
sTemp = string.gsub( sTemp,"</a>","" )
sTemp = string.gsub( sTemp,"\n\r","" )
sTemp = string.gsub( sTemp,"\n","" )
sTemp = string.gsub( sTemp,"\r","" )
sTemp = string.gsub( sTemp,"\t+"," " )
sTemp = string.gsub( sTemp,"%s+",' ' )
sTemp = ASCII_TO_UTF8([[<?xml version="1.0" encoding="utf-8"?>]] .. "\n".. sTemp)
local tData, err = xml.parse(sTemp)


function FindChildNode( tData, sNodeName )
	for i, v in ipairs(tData) do
		print(i,v)
	end
end

function GetTableData(oDoc)
	local tHeadData = {}
	local tTabData = {}
	local tHead=oDoc:child_with_name( "thead" )
	if tHead~= nil then
		local tr = tHead:child_with_name( "tr" )
		if tr ~= nil then
			local tChildTd = tHead:get_elements_with_name( "td" )
			for i, td in ipairs(tChildTd) do
				table.insert(tHeadData,td:get_text())
			end
		end
	end
	local tTR =oDoc:get_elements_with_name( "tr" )
	if tTR~= nil then
		for i, tr in ipairs(tTR) do
			local tRowData = {}
			local tChildTd = tr:get_elements_with_name( "td" )
			for i, td in ipairs(tChildTd) do
				table.insert(tRowData,td:get_text())
			end 
			table.insert(tTabData,tRowData)
		end
	end
	return tTabData, tHeadData
end

if tData ~= nil then
	local tData, tHead = GetTableData(tData)
	--local sStr = TableUtility.GetDataString( tData )
	local sStr= ""
	for i, v in ipairs(tData)do
		for k, val in ipairs(v) do
			sStr = sStr .. string.format("%s,",val)
		end
		sStr = sStr .. "\n"
	end
	if sStr ~= nil then
		local oFile = io.open( "D:/output.txt", "w" )
		if oFile ~= nil then
			oFile:write(sStr)
			oFile:close()
		end
	end
end
print("-------------------------------")