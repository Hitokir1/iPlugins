require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Thresh" then return end 
	local SkillQ = Caster(_Q, 1075, SPELL_LINEAR_COL, 2000, 0.491, 50, true)
	local SkillW = Caster(_W, 950, SPELL_CIRCLE, math.huge, 0, 100, true)
	local SkillE = Caster(_E, 400, SPELL_LINEAR, math.huge, 0, 100, true)
	local SkillR = Caster(_R, 450, SPELL_CIRCLE, math.huge, 0, 100, true)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(1075)
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Thresh") 
-- }