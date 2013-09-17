require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Ashe" then return end 
	local SkillW = Caster(_W, 1200, SPELL_LINEAR_COL, 2000, 0.180, 85, true)
	local SkillE = Caster(_E, 5500, SPELL_LINEAR)
	local SkillR = Caster(_R, math.huge, SPELL_LINEAR_COL, 1600, 1.0, 130, true)
	local combo = ComboLibrary()

	local wCollision = nil
	local Menu = nil
	local qEnabled = false
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(5500)
		combo:AddCasters({SkillW, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return ComboLibrary.KillableCast(Target, "R")
			end)
		wCollsion = Collision(SkillW.range, SkillW.speed, SkillW.delay, SkillW.width)
		AutoCarry.Plugins:RegisterPreAttack(function(Target) self:OnCustomAttack(Target) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if (myHero.mana / myHero.maxMana) < (Menu.qMana / 100) and Menu.advQ and qEnabled then 
			CastSpell(_Q)
		end 

		if Menu.wPowerPassive then 
			PowerFarm()
		end 

		if Menu.eMouse then 
			CastSpell(_E, mousePos.x, mousePos.z)
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		elseif AutoCarry.Keys.LaneClear or AutoCarry.Keys.LastHit then 
			PowerFarm()
		end 
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnCustomAttack(Target)
		if Menu.advQ then 
			if ValidTarget(Target) and Target.type == "obj_AI_Hero" and not qEnabled and (myHero.mana / myHero.maxMana) > (Menu.qMana / 100) then
				CastSpell(_Q)
			elseif Target.type ~= "obj_AI_Hero" and qEnabled then 
				CastSpell(_Q)
			end 
		end 
	end 

	function Plugin:OnCreateObj(object)
		if object and GetDistance(object) < 100 and object.name:lower():find("icesparkle") then 
			qEnabled = true
		end 
	end 

	function Plugin:OnDeleteObj(object)
		if object and GetDistance(object) < 100 and object.name:lower():find("icesparkle") then 
			qEnabled = false
		end 
	end 

	function PowerFarm()
		if SkillW:Ready() and Menu.wPower then 
			local Minion = AutoCarry.Minions:GetLowestHealthMinion() 
			local count = 0
			if Minion then 
				for index, min in pairs(AutoCarry.EnemyMinions().objects) do 
					if count >= Menu.wAmount then 
						break
					end 
					if min and ValidTarget(min) and GetDistance(min, Minion) <= SkillW.range then 
						if getDmg("W", min, myHero) >= min.health then 
							if not wCollsion:GetMinionCollision(myHero, min) then 
								count = count + 1
							end 
						end 
					end 
				end 
				if count >= Menu.wAmount then 
					SkillW:Cast(Minion)
				end 
			end 
		end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Ashe") 
	Menu:addParam("desc1","-- Casting Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("qMana", "Mana percentage to stop Q",SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	Menu:addParam("advQ", "Advanced-Q", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("eMouse", "E to Mouse", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("E"))
	Menu:addParam("desc2","-- PowerFarm Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("wPower", "W-PowerFarm", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("wPowerPassive", "Always Active", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("wAmount", "W amount",SCRIPT_PARAM_SLICE, 2, 0, 10, 0)
-- }