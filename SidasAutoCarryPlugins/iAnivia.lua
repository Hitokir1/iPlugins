require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Anivia" then return end 

	local SkillQ = Caster(_Q, 1100, SPELL_LINEAR, 860.05, 0.250, 110, true)
	local SkillW = Caster(_W, 1000, SPELL_CIRCLE, math.huge, 0, 200, true) 
	local SkillE = Caster(_E, 700, SPELL_TARGETED)
	local SkillR = Caster(_R, 615, SPELL_CIRCLE, math.huge, 0, 200, true)

	local GlacialStorm = false
	local qObject = nil

	local combo = ComboLibrary()
		
	function Plugin:__init() 
		BuffManager.Instance()
		AutoCarry.Crosshair.SkillRange = 1100
		lastMana = myHero.mana 
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(target) return qObject == nil end)
		--combo:AddCustomCast(_E, function(target) return BuffManager.TargetHaveBuff(target, "chilled") end)
		combo:AddCustomCast(_R, function(target) return not GlacialStorm and myHero.mana > 200 end)
		combo:AddCast(_E, function(target) PlaceWall(target) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if GlacialStorm then
			MonitorUltimate() 
		end 

		if Target and qObject ~= nil then
			if GetDistance(qObject, Target) <= 50 then
				CastSpell(_Q)
			end
		end

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnCreateObj(obj) 
		if obj.name:find("cryo_storm") then
	  		GlacialStorm = true
	  		lastMana = myHero.mana
	 	elseif obj.name:find("FlashFrost_mis") then
	 		qObject = obj
	 	end
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj.name:find("cryo_storm") then
	  		GlacialStorm = false
	 	elseif obj.name:find("FlashFrost_mis") then
	 		qObject = nil
	 	end
	end 

	function PlaceWall(enemy) 
		if SkillW:Ready() and GetDistance(enemy) <= SkillW.range then
			local TargetPosition = Vector(enemy.x, enemy.y, enemy.z)
			local MyPosition = Vector(myHero.x, myHero.y, myHero.z)		
			local WallPosition = TargetPosition + (TargetPosition - MyPosition)*((150/GetDistance(enemy)))
			CastSpell(_W, WallPosition.x, WallPosition.z)
		end
	end

	function MonitorUltimate() 
		local maxMana = myHero.maxMana * (15 / 100)
		if (lastMana - myHero.mana) > maxMana then 
			DisableUltimate()
		end
	end

	function DisableUltimate()
		if SkillR:Ready() and GlacialStorm then
			CastSpell(_R)
		end
	end

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Anivia") 
-- }
