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
require "functions"
require "package_support"

require "dataServer.config"
require "dataServer.main"