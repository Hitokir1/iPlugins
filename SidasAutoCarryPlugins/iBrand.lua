require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Brand" then return end 
	local SkillQ = Caster(_Q, 1000, SPELL_LINEAR, 1603, 0.187, 110, true)
	local SkillW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0, 100, true)
	local SkillE = Caster(_E, 625, SPELL_TARGETED)
	local SkillR = Caster(_R, 750, SPELL_TARGETED)

	local combo = ComboLibrary()
		
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1100
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Brand") 
-- }