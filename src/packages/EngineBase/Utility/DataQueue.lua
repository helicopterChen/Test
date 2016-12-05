local DataQueue = class( "DataQueue" )
local _table_insert = table.insert 
local _table_remove = table.remove 

function DataQueue:ctor()
	self.m_tQueue = {};
end

function DataQueue:InQueue( tData )
	_table_insert( self.m_tQueue, tData )
end

function DataQueue:OutQueue()
	return _table_remove( self.m_tQueue, 1 )
end

function DataQueue:IsEmpty()
	return (next(self.m_tQueue) == nil)
end

function DataQueue:Back()
	return self.m_tQueue[#self.m_tQueue]
end

function DataQueue:Front()
	return self.m_tQueue[1]
end

function DataQueue:Clear()
	self.m_tQueue = {}
end

function DataQueue:Count()
	return #self.m_tQueue
end

function DataQueue:GetDataInQueue()
	return self.m_tQueue
end

return DataQueue