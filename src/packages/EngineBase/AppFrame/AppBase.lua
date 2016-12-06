local AppBase = class("AppBase")
local TimerManager = import( "..Utility.TimerManager" )
local cDataManager = import( ".cDataManager" )

function AppBase:ctor(appName, packageRoot)
	_G.GAME_APP = self
	self.m_oDataManager = cDataManager:GetInstance()
	self.m_oTimerManager = TimerManager:GetInstance()
	self.m_sAppName = appName
	self.m_nLastUpdateTime = 0
	self.m_nUpdateDeltaTime = 20
    self.m_sPackageRoot = packageRoot or "app"
end

function AppBase:InitConfig()
end

local _NOW_TIME = 0
function AppBase:DefaultRun()
	local function mainLoopCallback( sName )
		_NOW_TIME = os.clock()
		self.Update( self, _NOW_TIME - self.m_nLastUpdateTime )
		self.m_nLastUpdateTime = _NOW_TIME
	end
	self.m_oTimerManager:SetTimer( "MAIN_LOOP_TIMER", self.m_nUpdateDeltaTime, mainLoopCallback )
	iup.MainLoop()
end

function AppBase:SetUpdateRate( nRate )
	self.m_nUpdateDeltaTime = tonumber(1000/nRate)
end

function AppBase:Update( dt )
end

function AppBase:GetDataManager()
	return self.m_oDataManager
end

return AppBase