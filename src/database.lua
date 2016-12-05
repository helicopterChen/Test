local luaSqlite3 = require "luasql.sqlite3"
local ENV = assert(luasql.sqlite3())
local conn = ENV:connect( GET_FULL_FILE_PATH("swc.db") )
local res = assert(conn:execute( [[SELECT * FROM people;]] ) )
