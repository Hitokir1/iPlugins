require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Blitzcrank" then return end 
	local SkillQ = Caster(_Q, 950, SPELL_LINEAR_COL, 1800, 0.25, 120)
	local SkillW = Caster(_W, 200, SPELL_SELF)
	local SkillE = Caster(_E, 200, SPELL_SELF)
	local SkillR = Caster(_R, 600, SPELL_SELF)
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
		AutoCarry.Crosshair.SkillRange = 1500
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_E, function(target) return ValidTarget(target, SkillE.range) end)
		combo:AddCustomCast(_W, function(target) return ValidTarget(target, SkillW.range) end)
		combo:AddCustomCast(_R, function(Target) return ((DamageCalculation.CalculateRealDamage(Target) > Target.health) or (getDmg("R", Target, myHero) > Target.health)) end)
		AutoBuff.Instance(SkillE)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Blitzcrank") 
-- }