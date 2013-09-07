require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Pantheon" then return end 
	local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
	local SkillW = Caster(_W, 600, SPELL_CIRCLE, math.huge, 0, 100, true)
	local SkillE = Caster(_E, 225, SPELL_LINEAR, math.huge, 0, 100, true)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 600
		combo:AddCasters({SkillQ, SkillW, SkillE})
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Pantheon") 
-- }