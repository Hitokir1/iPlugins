require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Fiora" then return end 
	local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, math.huge, SPELL_SELF)
	local SkillR = Caster(_R, 400, SPELL_TARGETED)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(600)
		combo:AddCasters({SkillQ, SkillR})
		AutoShield.Instance(SkillW.range, SkillW)
		AutoBuff.Instance(SkillE)
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Fiora") 
-- }