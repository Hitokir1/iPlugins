require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Zac" then return end 
	local SkillQ = Caster(_Q, 550, SPELL_CONE)
	local SkillW = Caster(_W, 250, SPELL_SELF)
	local SkillE = Caster(_E, 1150, SPELL_CIRCLE, 1288, 0.140, 50, true) 
	local SkillR = Caster(_R, 0, SPELL_SELF)
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Zac") 
-- }