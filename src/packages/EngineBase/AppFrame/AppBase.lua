local AppBase = class("AppBase")
local TimerManager = import( "..Utility.TimerManager" )

function AppBase:ctor(appName, packageRoot)
	_G.GAME_APP = self
	self.m_oTimerManager = TimerManager:GetInstance()
	self.m_sAppName = appName
	self.m_nLastUpdateTime = 0
	self.m_nUpdateDeltaTime = 20
    self.m_sPackageRoot = packageRoot or "app"
end

local _NOW_TIME = 0
function AppBase:DefaultRun()
	local function mainLoopCallback()
		_NOW_TIME = os.clock()
		self.Update( self, _NOW_TIME - self.m_nLastUpdateTime )
		self.m_nLastUpdateTime = _NOW_TIME
	end
	self.m_oTimerManager:SetTimer( self.m_nUpdateDeltaTime, mainLoopCallback )
	self.m_oTimerManager:Run()
end

function AppBase:SetUpdateRate( nRate )
	self.m_nUpdateDeltaTime = tonumber(1000/nRate)
end

function AppBase:Update( dt )
end

return AppBase