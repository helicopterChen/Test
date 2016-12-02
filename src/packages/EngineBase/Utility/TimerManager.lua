require "iuplua"

local TimerManager = class("TimerManager")

function TimerManager:ctor()
	self.m_tTimers = {}
end

function TimerManager:GetInstance()
	if _G.__TimerManager == nil then
		_G.__TimerManager = TimerManager:new()
	end
	return _G.__TimerManager
end

function TimerManager:SetTimer( sTimerName, nTime, callBack )
	if self.m_tTimers[sTimerName] == nil then
		local oTimer = iup.timer{ time=nTime or 30 }
		if oTimer ~= nil then
			oTimer.run = "YES"
			oTimer.m_sTimerName = sTimerName
			function oTimer:action_cb()
				callBack( self.m_sTimerName )
			end
			self.m_tTimers[sTimerName] = oTimer
		end
	end
	iup.MainLoop()
end

function TimerManager:RemoveTimer( sTimerName )
	local oTimer = self:GetTimer( sTimerName )
	if oTimer ~= nil then
		self:RunTimer( sTimerName, false)
		self.m_tTimers[sTimerName] = nil
	end
end

function TimerManager:GetTimer( sTimerName )
	return self.m_tTimers[StopTimer]
end

function TimerManager:RunTimer( sTimerName, bRun )
	local oTimer = self:GetTimer( sTimerName )
	if oTimer ~= niil then
		if bRun == true then
			oTimer.run = "YES"
		else
			oTimer.run = "NO"
		end
	end
end

return TimerManager