require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Ryze" then return end 
	local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
	local SkillW = Caster(_W, 600, SPELL_TARGETED)
	local SkillE = Caster(_E, 600, SPELL_TARGETED)
	local SkillR = Caster(_R, 600, SPELL_SELF)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 600
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return ValidTarget(Target, SkillR.range)
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Ryze") 
-- }