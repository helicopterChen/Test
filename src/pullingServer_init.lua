LFS = require "lfs"
CURRENT_PATH = LFS:currentdir()
SRC_FILE_PATH = CURRENT_PATH .. "/src/"
RES_FILE_PATH = CURRENT_PATH .. "/res/"

local PACK_PATH = package.path
package.path = string.format("%s;%s?.lua;%s?/init.lua", PACK_PATH, SRC_FILE_PATH, SRC_FILE_PATH)  

function GET_FULL_FILE_PATH( sPath )
	local sFullPath = string.format( "%s/%s", RES_FILE_PATH, sPath )
	local sPath = string.gsub( sFullPath, "\\", '/' )
	sPath = string.gsub( sPath, "//", '/' )
	return sPath
end

__LOG_STR_MAP_ = {}
function SYS_LOG( ... )
	local logStr = "" .. os.date() .. ": "
	for k,v in ipairs({...}) do
		logStr = logStr .. tostring( v ) .. "\t"
	end
	print(logStr)
	__LOG_STR_MAP_[#__LOG_STR_MAP_+1] = logStr
end

require "functions"
require "package_support"

require "pullingServer.config"
require "pullingServer.main"