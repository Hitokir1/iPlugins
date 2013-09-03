--[[ BETA ]]
require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Varus" then return end 

	local Q_RANGE, Q_SPEED, Q_DELAY, Q_WIDTH = 1600, 1850, 0, 60

	local combo = ComboLibrary()

	local qCasted = false 
	local qTick = 0
	local qChargeTime = 0 
	local dynamicRange = 0 
	local OVERSHOOT_RANGE = 70
	local qFixTick = 0

	local qPrediction = nil 
	local qTargeting = nil 

	local BlightTable = {
		"VarusW_counter_01.troy", 
		"VarusW_counter_02.troy",
		"VarusW_counter_03.troy"
	}

	local enemyTable = {}
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		-- Q Range calculation
		if qCasted then
			qChargeTime = math.max(0, GetTickCount()- qTick)
			qChargeTime = math.min(qChargeTime, 2000)
		else
			qChargeTime = 0
		end
		dynamicRange = 925 + (0.3375 * qChargeTime)
		if qChargeTime < 300 then
			dynamicRange = dynamicRange - OVERSHOOT_RANGE
		end

		-- Q Fixez
		if GetTickCount() - qFixTick > 99 then 
			qFixTick = GetTickCount()
			if qCasted and (Target and not ValidTarget(Target, 1600)) then 
				CastSpell(10)
				qCasted = false
			end 
		end 

		if Target and AutoCarry.Keys.AutoCarry then

			qPrediction = qTargeting:GetPrediction(Target)

			if not qCasted and GetDistance(Target) < 1600 - 2 * Target.ms then 
				CastQ(0, Target)
			end 
			if qCasted and qPrediction and GetDistance(qPrediction) < dynamicRange and qPrediction.networkID == Target.networkID and qPrediction:GetHitChance(Target) > 0.6 
				and (GetTickCount() - qTick > 300 or (GetDistance(qPrediction) < 800 and GetTickCount() - qTick > 300)) then 
				CastQ(1, qPrediction) 
			end 
		end
	end 

	function Plugin:OnSendPacket(p) 
		local packet = Packet(p) --smartcast fix
	    if p.header == 0xE6 and qCasted then -- 2nd cast of channel spells packet2
			p.pos = 5
	        spelltype = p:Decode1()
			if spelltype == 0x80 then -- 0x80 == Q
	            p.pos = 1
	            p:Block()
	        end
	    end
	end 

	function OnGainBuff(unit, buff) 
		if unit and buff and buff.source == myHero then 
			PrintChat("GAINED: " .. buff.name)
		end 
	end 

	function OnChangeStack(unit, buff) 
		if unit and buff and buff.source == myHero then 
			PrintChat("GAINED: " .. buff.stack)
		end 
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1600
		combo:AddCasters({SkillQ, SkillR})
		for i=0, heroManager.iCount, 1 do
	        local playerObj = heroManager:GetHero(i)
	        if playerObj and playerObj.team ~= myHero.team then
	                playerObj.blight = { tick = 0, count = 0, }
	                table.insert(enemyTable,playerObj)
	        end
		end

		qTargeting = TargetPredictionVIP(Q_RANGE, Q_SPEED, Q_DELAY, Q_WIDTH)
	end 

	function Plugin:OnCreateObj(object)
		if object and object.valid and object.name == "VarusQChannel.troy" and GetDistance(object) <= 150 then 
			qCasted = true 
		end 
	end 

	function Plugin:OnCreateObj(object)
		if object and object.valid and object.name == "VarusQChannel.troy" and GetDistance(object) <= 150 then 
			qCasted = false
		end 
	end

	-- STAGES : 0 - Initial, 1 - Packet cast
	function CastQ(stage, Target) 
		if stage == 0 then
			if not qCasted and myHero:CanUseSpell(_Q) == READY then 
				if Target then 
					CastSpell(_Q, Target.x, Target.z) 
				else 
					CastSpell(_Q, mousePos.x, mousePos.z)
				end 
				qTick = GetTickCount()
			end 
		elseif stage == 1 then 
			qCasted = false
			packet = CLoLPacket(0xE6)
			packet:EncodeF(myHero.networkID)
			packet:Encode1(128) --Q
			packet:EncodeF(Target.x)
			packet:EncodeF(Target.y)
			packet:EncodeF(Target.z)
			packet.dwArg1 = 1
			packet.dwArg2 = 0
			SendPacket(packet)
			qTick = GetTickCount()
		end 
	end 

	function GetEnemy(target) 
		for i, enemy in pairs(enemyTable) do 
			if enemy and not enemy.dead and enemy.visible and enemy == target then
				return enemy
			end 
		end 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Varus") 
-- }
