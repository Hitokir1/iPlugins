require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Viktor" then return end 
	local SkillQ = Caster(_Q, 600, SPELL_TARGETED) 
	local SkillW = Caster(_W, 625, SPELL_CIRCLE)
	local SkillE = Caster(_E, 540, SPELL_TARGETED) 
	local SkillR = Caster(_R, 700, SPELL_CIRCLE) 
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
		AutoCarry.Crosshair.SkillRange = 700
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Viktor") 
-- }