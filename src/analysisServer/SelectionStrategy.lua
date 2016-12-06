local SelectionStrategy = class( "SelectionStrategy" )

---------------------------------------------------------------------------------------------------------------------------------------------------
function SelectionStrategy:ctor( sName )
	self.m_sName = sName
	self.m_tBasicCondConf = {}
end

function SelectionStrategy:SetBasicCondConf( tConf )
	for i, v in pairs( tConf ) do
		self.m_tBasicCondConf[i] = v
	end
end

function SelectionStrategy:DoSelection()
	local oDataManager = GAME_APP:GetDataManager()
	local tAllStockConf = oDataManager:GetDataByName( "AllStockConf" )
	self:DoBasicSelection( tAllStockConf )
end

function SelectionStrategy:DoBasicSelection( tSelectedData )
	local tBasicCondConf = self.m_tBasicCondConf
	local oDataManager = GAME_APP:GetDataManager()
	local tFitCond = {}
	for i, v in pairs(tSelectedData) do
		local bCondOk = true
		for attri, val in pairs(v) do
			if type(val) == "number" and tBasicCondConf[attri] ~= nil then
				local nMin= tBasicCondConf[attri].min
				local nMax= tBasicCondConf[attri].max
				if not(nMin <= val and val <= nMax) then
					bCondOk = false
					break
				end
			end
		end
		if bCondOk == true then
			table.insert(tFitCond,v)
		end
	end
	for i, v in ipairs(tFitCond) do
		print(i,v.code,v.pb,v.name)
	end
end

function SelectionStrategy:DoProfitSelection( tSelectedData )
end

function SelectionStrategy:DoCondSelection( tSelectedData )
end

function SelectionStrategy:Update( dt )
end
---------------------------------------------------------------------------------------------------------------------------------------------------
return SelectionStrategy