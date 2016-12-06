local StrategyManager = class( "StrategyManager" )
local SelectionStrategy = import( ".SelectionStrategy" )
local DataQueue = _G.ENGINE_BASE.DataQueue
---------------------------------------------------------------------------------------------------------------------------------------------------
function StrategyManager:ctor()
	self.m_oStrategyDataQueue = DataQueue:create()
end

function StrategyManager:GetInstance()
	if _G.__StrategyManager == nil then
		_G.__StrategyManager = StrategyManager:create()
	end
	return _G.__StrategyManager
end

function StrategyManager:CreateStrategy( sId )
	local oDataManager = GAME_APP:GetDataManager()
	local tSelectCondConf = oDataManager:GetDataByNameAndId( "SelectCondConf", tostring(sId) )
	if tSelectCondConf == nil then
		return
	end
	local oStrategy = SelectionStrategy:create( tSelectCondConf.desc )
	if oStrategy ~= nil then
		oStrategy:SetBasicCondConf( tSelectCondConf )
		self.m_oStrategyDataQueue:InQueue( oStrategy )
	end
end

function StrategyManager:AddStrategyToProcess( sStrategyName )
end

function StrategyManager:Update( dt )
	if self.m_oCurProcessStrategy == nil then
		local oStrategy = self.m_oStrategyDataQueue:OutQueue()
		if oStrategy ~= nil then
			self.m_oCurProcessStrategy = oStrategy
			oStrategy:DoSelection()
		end
	else
		self.m_oCurProcessStrategy:Update( dt )
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return StrategyManager