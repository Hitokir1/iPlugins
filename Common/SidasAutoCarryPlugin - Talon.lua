require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Talon" then return end 
	local SkillQ = Caster(_Q, 300, SPELL_SELF)
	local SkillW = Caster(_W, 700, SPELL_CONE, 2000, 0.250, 200, true)
	local SkillE = Caster(_E, 700, SPELL_TARGETED)
	local SkillR = Caster(_R, 200, SPELL_SELF)
	local combo = ComboLibrary()

	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(700)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return ComboLibrary.KillableCast(Target, "R") and ValidTarget(Target, SkillR.range) 
			end)
		combo:AddCustomCast(_Q, function(Target)
				return ValidTarget(Target, SkillQ.range)
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Talon") 
-- }
