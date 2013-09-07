require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Nautilus" then return end 
	local SkillQ = Caster(_Q, 1030, SPELL_LINEAR_COL, 1841, 0.250, 100, true)
	local SkillW = Caster(_W, 700, SPELL_SELF)
	local SkillE = Caster(_E, 600, SPELL_SELF)
	local SkillR = Caster(_R, 850, SPELL_TARGET)

	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1200
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target) return GetDistance(Target) > Combat.GetTrueRange() end)
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range) end)
		combo:AddCustomCast(_E, function(Target) return ValidTarget(Target, SkillE.range) end)
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		AutoShield.Instance(SkillW.range, SkillW) 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Nautilus") 
-- }