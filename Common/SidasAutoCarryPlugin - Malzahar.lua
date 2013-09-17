require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Malzahar" then return end 
	local SkillQ = Caster(_Q, 900, SPELL_CIRCLE, 1400, 0.25)
	local SkillW = Caster(_W, 800, SPELL_CIRCLE, 2000, 0.25)
	local SkillE = Caster(_E, 650, SPELL_TARGETED) 
	local SkillR = Caster(_R, 700, SPELL_TARGETED) 
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(900)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return not TargetHaveBuff("alzaharnethergraspsound", myHero) and ComboLibrary.KillableCast(Target, "R") end)
		combo:AddCustomCast(_Q, function(Target) return not TargetHaveBuff("alzaharnethergraspsound", myHero) end)
		combo:AddCustomCast(_W, function(Target) return not TargetHaveBuff("alzaharnethergraspsound", myHero) end)
		combo:AddCustomCast(_E, function(Target) return not TargetHaveBuff("alzaharnethergraspsound", myHero) end)	
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Malzahar") 
-- }