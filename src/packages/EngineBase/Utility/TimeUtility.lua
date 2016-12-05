local TimeUtility = {}
--获取时间
function TimeUtility.GetDateTimeEx( nTime )
	local nTimeVal = os.time()	
	local timeData = {}
	if nTime ~= nil then
		nTimeVal = nTime
	end
	timeData.Year = tonumber(os.date( "%Y", nTimeVal ))
	timeData.Month = tonumber(os.date( "%m", nTimeVal  ))
	timeData.Day = tonumber(os.date( "%d", nTimeVal  ))
	timeData.Hour = tonumber(os.date( "%H", nTimeVal  ))
	timeData.Minute = tonumber(os.date( "%M", nTimeVal  ))
	timeData.Second = tonumber(os.date( "%S", nTimeVal  ))
	timeData.WeekDay = tonumber(os.date( "%w", nTimeVal  ))	
	if( timeData.Year == nil ) then
		timeData = nil
	end	
	return timeData, nTimeVal
end

--两个时间差的秒数
function TimeUtility.DateDiffSeconds( beginTime, endTime )
	if( beginTime == nil ) then
		return nil
	end
	
	local beginTimeSeconds = os.time{ year = beginTime.Year, month = beginTime.Month, day = beginTime.Day, hour = beginTime.Hour, min = beginTime.Minute, sec = beginTime.Second }
	local endTimeSeconds =  os.time()
	if( endTime ~= nil ) then
		endTimeSeconds = os.time{ year = endTime.Year, month = endTime.Month, day = endTime.Day, hour = endTime.Hour, min = endTime.Minute, sec = endTime.Second }
	end
	
	return (endTimeSeconds - beginTimeSeconds)
end

--根据时间差来获取时间
function TimeUtility.GetDateTimeValFromTime( beginTime, diffseconds )
	if( beginTime == nil ) then
		return nil
	end
	local timeTable = 
	{
		Year = beginTime.Year or 0,
		Month = beginTime.Month or 0,
		Day = beginTime.Day or 0,
		Hour = beginTime.Hour or 0,
		Minute = beginTime.Minute or 0,
		Second = beginTime.Second or 0,
		DiffSeconds = diffseconds or 0,
	}
	return TimeUtility.GetDateValByDateTable( timeTable )
end

--获得一天的时间
function TimeUtility.WhatWeekDayOfDay( nTime )
	nTime = nTime or os.time()
	return tonumber(os.date( "%w" , nTime ))
end

--获取某年，某月的天数时间
function TimeUtility.GetMonthDays( nYear, nMonth )
	if nYear == nil or nMonth == nil then
		return
	end
	if nMonth < 1 or nMonth > 12 then
		return
	end
	local tMonthDay = { [1] = 31,[2] = 28, [3] = 31,[4]=30,[5]= 31,[6]=30,[7]=31,[8]=31,[9]=30,[10]=31,[11]=30,[12]=31}
	if nYear % 4 == 0 and nMonth == 2 then
		return 29
	else
		return tMonthDay[nMonth]
	end
end

--转换时间函数
--转换时间格式10:12:00 范围(00:00:00 - 23:59:59)
function TimeUtility.TransTimeStrToVal( timeStr )
	--检查格式
	local timeToken = string.split( timeStr, ':' )
	if( timeToken == nil or #timeToken ~= 3 ) then
		return
	end
	return tonumber( timeToken[1] ) * 3600 + tonumber( timeToken[2] ) * 60 + tonumber( timeToken[3] )
end

--转换时间函数
--又数字转换为时间格式10:12:00 范围(00:00:00 - 23:59:59)
function TimeUtility.TransTimeValToStr( nTimeVal,showNum, bSecFormat )
	nTimeVal = math.floor(nTimeVal)
	local nHours = math.floor( nTimeVal / 3600 )
	local nMinutes = math.floor( (nTimeVal - (nHours * 3600)) / 60 )
	local nSeconds = math.floor( nTimeVal % 60 )
	local sTimeStr = "00:00:00"
	local sHours = "00"
	local sMinnutes = "00"
	local sSeconds = "00"
	if nHours < 10 then
		sHours = string.format( "0%d", nHours )
	else
		sHours = string.format( "%d", nHours )
	end
	if nMinutes < 10 then
		sMinnutes = string.format( "0%d", nMinutes )
	else
		sMinnutes = string.format( "%d", nMinutes )
	end
	if nSeconds < 10 then
		sSeconds = string.format( "0%d", nSeconds )
	else
		sSeconds = string.format( "%d", nSeconds )
	end
	if bSecFormat ~= true then
		if showNum == 2 then
			sTimeStr = string.format( "%s:%s", sMinnutes, sSeconds )
		else
			sTimeStr = string.format( "%s:%s:%s", sHours, sMinnutes, sSeconds )
		end
	else
		if showNum == 2 then
			sTimeStr = string.format( "%s\'%s", sMinnutes, sSeconds )
		else
			sTimeStr = string.format( "%s\'%s\"%s", sHours, sMinnutes, sSeconds )
		end
	end
	return sTimeStr
end

--转换时间格式
function TimeUtility.GetDateValByDateTable( tTimeData )
	local nTimeVal = os.time{ year = tTimeData.Year, month = tTimeData.Month, day = tTimeData.Day, hour = tTimeData.Hour, min = tTimeData.Minute, sec = tTimeData.Second }
	if tTimeData.DiffSeconds ~= nil and tTimeData.DiffSeconds ~= 0 then
		nTimeVal = nTimeVal + tonumber(tTimeData.DiffSeconds)
	end
	return nTimeVal
end

return TimeUtility