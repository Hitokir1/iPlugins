require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "MonkeyKing" then return end 
	local SkillQ = Caster(_Q, 200, SPELL_SELF)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 625, SPELL_TARGETED)
	local SkillR = Caster(_R, 162, SPELL_SELF)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 625
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return ComboLibrary.KillableCast(Target, "R")
			end)
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

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "MonkeyKing") 
-- }