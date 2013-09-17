require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Nami" then return end 
	local SkillQ = Caster(_Q, 850, SPELL_CIRCLE, math.huge, 0.400, true)
	local SkillW = Caster(_W, 725, SPELL_TARGETED)
	local SkillR = Caster(_R, 1000, SPELL_LINEAR, 1200, 0.500, true) 
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(1000)
		combo:AddCasters({SkillQ, SkillW, SkillR})
		combo:AddCustomCast(_R, function(Target) return Menu.useR end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		Priority.Instance(true)
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Nami") 
	Menu:addParam("useR", "Use Ultimate", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
-- }