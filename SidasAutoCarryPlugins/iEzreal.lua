require "iFoundation_v2"
class 'Plugin' -- {
	
	if myHero.charName ~= "Ezreal" then return end 
	local SkillQ = Caster(_Q, 1100, SPELL_LINEAR_COL, 2000, 0.251, 80, true)
	local SkillW = Caster(_W, 1050, SPELL_LINEAR, 1600, 0.250, 100, true)
	local SkillE = Caster(_E, 475, SPELL_TARGET)
	local SkillR = Caster(_R, 2000, SPELL_LINEAR, 1700, 1.0, 100, true)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 2000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		combo:AddCast(_E, function(Target) SkillE:CastMouse(mousePos) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Ezreal") 
-- }