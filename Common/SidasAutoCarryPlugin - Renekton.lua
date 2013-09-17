require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Renekton" then return end 
	local SkillQ = Caster(_Q, 225, SPELL_SELF)
	local SkillW = Caster(_W, 225, SPELL_SELF)
	local SkillE = Caster(_E, 450, SPELL_LINEAR)
	local SkillR = Caster(_R, math.huge, SPELL_SELF)
	local Menu = nil
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(450)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target)
				return ValidTarget(Target, SkillQ.range)
			end)
		combo:AddCustomCast(_W, function(Target)
				return ValidTarget(Target, SkillW.range)
			end)
		combo:AddCustomCast(_R, function(Target)
				return ((myHero.health / myHero.maxHealth) < (Menu.rPercentage / 100)) or (ComboLibrary.KillableCast(Target, "R") and Menu.useR)
			end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Renekton") 
	Menu:addParam("desc1","-- Ultimate Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("rPercentage", "HP % for Ult",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
	Menu:addParam("useR", "Ult for kill", SCRIPT_PARAM_ONOFF, true)
-- }