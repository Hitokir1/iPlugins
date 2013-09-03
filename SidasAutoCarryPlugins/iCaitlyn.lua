require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Caitlyn" then return end 

	local SkillQ = Caster(_Q, 1300, SPELL_LINEAR, 2200, 0.625, 90, true)
	local SkillW = Caster(_W, 800, SPELL_CIRCLE)
	local SkillE = Caster(_E, 800, SPELL_LINEAR_COL, 2000, 0, 80, true)
	local SkillR = Caster(_R, 2000, SPELL_TARGETED)

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
		AutoCarry.Crosshair.SkillRange = 3000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return getDmg("R", Target, myHero) > Target.health end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Caitlyn") 
-- }