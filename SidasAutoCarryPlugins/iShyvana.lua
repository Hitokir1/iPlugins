require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Shyvana" then return end 
	local SkillQ = Caster(_Q, 200, SPELL_SELF)
	local SkillW = Caster(_W, 300, SPELL_SELF)
	local SkillE = Caster(_E, 950, SPELL_LINEAR, 1750, 0, 50, true) 
	local SkillR = Caster(_R, 1000, SPELL_LINEAR)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 950
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target) return ValidTarget(Target, SkillQ.range) end)
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Shyvana") 
-- }