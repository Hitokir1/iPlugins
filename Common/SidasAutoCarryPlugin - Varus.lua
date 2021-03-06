require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Varus" then return end 

	local Q_RANGE, Q_SPEED, Q_DELAY, Q_WIDTH = 1600, 1850, 0, 60
	local SkillQ = Caster(_Q, 1600, SPELL_LINEAR) 
	local SkillE = Caster(_E, 925, SPELL_CIRCLE, 1750, 0.24, 235)
	local SkillR = Caster(_R, 1075, SPELL_LINEAR_COL, 2000, 0.25, 100)
	local combo = ComboLibrary()

	local qCasted = false 
	local qTick = 0
	local qChargeTime = 0 
	local dynamicRange = 0 
	local OVERSHOOT_RANGE = 70
	local qFixTick = 0

	local qPrediction = nil 
	local qTargeting = nil 

	local Menu = nil

	local BlightTable = {
		"VarusW_counter_01.troy", 
		"VarusW_counter_02.troy",
		"VarusW_counter_03.troy"
	}

	local enemyTable = {}
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(1600)
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target) 
			enemy = GetEnemy(Target)
			return enemy and ((Menu.wStack == 0) or (enemy.blight.count == Menu.wStack and myHero:GetSpellData(_W).level >= 1)) 
			end)
		combo:AddCustomCast(_E, function(Target) 
			enemy = GetEnemy(Target)
			return enemy and ((Menu.wStack == 0) or (enemy.blight.count == Menu.wStack and myHero:GetSpellData(_W).level >= 1)) 
			end)
		combo:AddCast(_Q, function(Target) 
				qPrediction = qTargeting:GetPrediction(Target)

				if not qCasted and GetDistance(Target) < 1600 - 2 * Target.ms then 
					CastQ(0, Target)
				end 
				if qCasted and qPrediction and GetDistance(qPrediction) < dynamicRange --[[and qPrediction.networkID == Target.networkID and qPrediction:GetHitChance(Target) > 0.6 
					and (GetTickCount() - qTick > 300 or (GetDistance(qPrediction) < 800 and GetTickCount() - qTick > 300))]]  then 
					CastQ(1, qPrediction) 
				end 
			end)
		combo:AddCustomCast(_R, function(Target) 
				return ComboLibrary.KillableCast(Target, "R") or Monitor.CountEnemies(Target, 400) >= 3 
			end)
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

		enemy = GetEnemy(Target)

		if enemy and Target then
			if (GetTickCount() - enemy.blight.tick > 6000) or enemy.dead then enemy.blight.count = 0 end 
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
			combo:CastCombo(Target)
		elseif Menu.EscapeMode then 
			Target = Combat.GetNearest()
			if Target then 
				if SkillE:Ready() then 
					SkillE:Cast(Target)
				elseif SkillR:Ready() and (myHero.health / myHero.maxHealth) < (Menu.rHealth / 100) then
					SkillR:Cast(Target)
				end 
			end 
		elseif Menu.CastQMouse then 
			if not qCasted --[[and GetDistance(Target) < 1600 - 2 * Target.ms]] then 
				CastQ(0, Target)
			end 
			if qCasted and GetDistance(mousePos) < dynamicRange --[[and qPrediction.networkID == Target.networkID and qPrediction:GetHitChance(Target) > 0.6 
				and (GetTickCount() - qTick > 300 or (GetDistance(qPrediction) < 800 and GetTickCount() - qTick > 300))]]  then 
				CastQ(1, mousePos) 
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
		if unit and buff and buff.source == myHero and buff.name:find("varusw") then 
			for i, enemy in pairs(enemyTable) do 
				if enemy and not enemy.dead and enemy.visible and enemy == unit then
					enemy.blight.tick = GetTickCount()
					enemy.blight.count = buff.stack 
					PrintFloatText(enemy, 21, "Blight Stacks: " ..buff.stack)
				end 
			end 
		end 
	end 

	function OnUpdateBuff(unit, buff) 
		if unit and buff and buff.source == myHero and buff.name:find("varusw") then 
			for i, enemy in pairs(enemyTable) do 
				if enemy and not enemy.dead and enemy.visible and enemy == unit then
					enemy.blight.tick = GetTickCount()
					enemy.blight.count = buff.stack 
					PrintFloatText(enemy, 21, "Blight Stacks: " ..buff.stack)
				end 
			end 
		end 
	end 

	function Plugin:OnLoad() 
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

	function Plugin:OnDeleteObj(object)
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

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Varus") 
	Menu:addParam("desc1","-- Passive Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("wStack", "Proc E",SCRIPT_PARAM_SLICE, 3, 0, 3, 0)
	Menu:addParam("desc2","-- Cast Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("CastQMouse", "Cast Q to mouse position", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Q"))
	Menu:addParam("desc3","-- Escape Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("EscapeMode", "Escape Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	Menu:addParam("rHealth", "R Escape Health",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
-- }
