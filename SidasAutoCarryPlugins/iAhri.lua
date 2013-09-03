require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Ahri" then return end 

	local SkillQ = Caster(_Q, 880, SPELL_LINEAR, 1700, 0.25, 50)
	local SkillW = Caster(_W, 800, SPELL_SELF)
	local SkillE = Caster(_E, 975, SPELL_LINEAR_COL, 1600, 0.1, 50)
	local SkillR = Caster(_R, 1000, SPELL_LINEAR, math.huge, 0, 100)

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
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_W, function(target) return ValidTarget(target, SkillW.range) end)
		combo:AddCustomCast(_R, function(target) return (DamageCalculation.CalculateRealDamage(target) > target.health) or ((getDmg("R", target, myHero) * 3) > target.health) end)
		combo:AddCast(_R, function(target) SkillR:CastMouse(mousePos) end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Ahri") 
-- }
