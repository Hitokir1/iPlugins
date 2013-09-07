require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Yorick" then return end 
	local SkillQ = Caster(_Q, 200, SPELL_SELF)
	local SkillW = Caster(_W, 600, SPELL_CIRCLE, math.huge, 0.250, 200)
	local SkillE = Caster(_E, 550, SPELL_TARGETED)
	local SkillR = Caster(_R, 850, SPELL_TARGETED_FRIENDLY)
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 850
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target) return ValidTarget(Target, SkillQ.range) end)
		combo:AddCast(_R, function(Target) Combat.CastLowest(SkillR, Menu.rPercentage) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Yorick") 
	Menu:addParam("rPercentage", "R Percentage",SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
-- }