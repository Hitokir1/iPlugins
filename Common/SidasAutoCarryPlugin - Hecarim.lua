require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Hecarim" then return end 
	local SkillQ = Caster(_Q, 325, SPELL_SELF)
	local SkillW = Caster(_W, 525, SPELL_SELF)
	local SkillE = Caster(_E, 500, SPELL_SELF)
	local SkillR = Caster(_R, 1000, SPELL_CIRCLE, math.huge, 0, 150, true)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(600)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_Q, function(Target) return ValidTarget(Target, SkillQ.range) end)
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range) end)
		combo:AddCustomCast(_E, function(Target) return ValidTarget(Target, SkillE.range) end)
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Hecarim") 
-- }