require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Sivir" then return end 

	local SkillQ = Caster(_Q, 1200, SPELL_LINEAR, 300, 0.200, 100, true)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, math.huge, SPELL_SELF)
	local SkillR = Caster(_R, 300, SPELL_SELF)

	local combo = ComboLibrary()


	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1200
		AutoShield.Instance(SkillE.range, SkillE)
		AutoBuff.Instance(SkillW)
		combo:AddCasters({SkillQ, SkillR})
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Sivir") 
-- }