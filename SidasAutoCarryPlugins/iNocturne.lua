require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Nocturne" then return end 
	local SkillQ = Caster(_Q, 1200, SPELL_LINEAR, 1398, 0.249, 50, true) 
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 425, SPELL_TARGETED)	
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1200
		combo:AddCasters({SkillQ, SkillW, SkillE})
		combo:AddCustomCast(_W, function(Target) return GetDistance(Target) < Menu.wDistance end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Nocturne") 
	Menu:addParam("wDistance", "W distance", SCRIPT_PARAM_SLICE, 0, 0, 500, 0)
-- }