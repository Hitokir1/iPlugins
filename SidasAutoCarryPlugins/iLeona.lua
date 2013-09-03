require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Leona" then return end 
	local SkillQ = Caster(_Q, 100, SPELL_SELF) 
	local SkillW = Caster(_W, 100, SPELL_SELF)
	local SkillE = Caster(_E, 700, SPELL_LINEAR_COL, 1950, 0, 100, true) 
	local SkillR = Caster(_R, 1200, SPELL_CIRCLE) 
	local combo = ComboLibrary()
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1200
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Leona") 
-- }