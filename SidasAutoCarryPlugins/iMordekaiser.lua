require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Mordekaiser" then return end 
	local SkillQ = Caster(_Q, 200, SPELL_SELF)
	local SkillW = Caster(_W, 750, SPELL_TARGETED_FRIENDLY)
	local SkillE = Caster(_E, 700, SPELL_CONE)
	local SkillR = Caster(_R, 850, SPELL_TARGETED)

	local rGhost = false
	local rDelay = 0
	local combo = ComboLibrary()

	local Menu = nil
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		rGhost = myHero:GetSpellData(_R).name == "mordekaisercotgguide"
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 0
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
				return (rGhost and GetTickCount() >= rDelay) or (not rGhost and ComboLibrary.KillableCast(Target, "R"))
			end)
		combo:AddCast(_W, function(Target) 
				if Monitor.GetLowAlly() ~= nil then 
					SkillW:Cast(Monitor.GetLowAlly())
				elseif (myHero.health < myHero.maxHealth * (Menu.wPercentage / 100)) then
					SkillW:Cast(myHero)
				elseif Monitor.GetAllyWithMostEnemies(750) ~= nil then
					SkillW:Cast(Monitor.GetAllyWithMostEnemies(750))
				end 
			end)
		combo:AddCast(_R, function(Target)
				if rGhost and GetTickCount() >= rDelay then
					rDelay = GetTickCount() + 1000
				end 
				SkillR:Cast(Target) 
			end)
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Mordekaiser") 
	Menu:addParam("wPercentage", "Monitor w percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
-- }