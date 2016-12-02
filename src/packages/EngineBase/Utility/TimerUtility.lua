require "iuplua"

local TimerManager = class("TimerManager")

function TimerManager:ctor()
	self.m_tTimers = {}
end

function TimerManager:GetInstance()
	if _G.__TimerManager == nil then
		_G.__TimerManager = TimerManager:create()
	end
	return _G.__TimerManager
end

function TimerManager:SetTimer( nTime, callBack )
	local oTimer = iup.timer{ time=nTime or 30 }
	if oTimer ~= nil then
		oTimer.run = "YES"
		function oTimer:action_cb()
			callBack()
		end
	end
end

function TimerManager:RemoveTimer( sTimerName )
end

function TimerManager:Run()
	iup.MainLoop()
end

return TimerManager