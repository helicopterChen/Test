LFS = require "lfs"
CURRENT_PATH = LFS:currentdir()
SRC_FILE_PATH = CURRENT_PATH .. "/src/"
RES_FILE_PATH = CURRENT_PATH .. "/res/"

local PACK_PATH = package.path
package.path = string.format("%s;%s?.lua;%s?/init.lua", PACK_PATH, SRC_FILE_PATH, SRC_FILE_PATH)  

function GET_FULL_FILE_PATH( sPath )
	local sFullPath = string.format( "%s/%s", RES_FILE_PATH, sPath )
	return string.gsub( sFullPath, "\\", '/' )
end

require "config"
require "functions"
require "package_support"
require "main"