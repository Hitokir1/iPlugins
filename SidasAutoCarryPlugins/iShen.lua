require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Shen" then return end 
	local SkillQ = Caster(_Q, 475, SPELL_TARGETED)
	local SkillE = Caster(_E, 1000, SPELL_LINEAR_COL, 1603, 0.187, 110, true)
	local SkillW = Caster(_W, 200, SPELL_TARGETED_FRIENDLY)
	local SkillR = Caster(_R, 18500, SPELL_TARGETED_FRIENDLY)
	local Menu = nil
	local combo = ComboLibrary()
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Monitor.GetLowAlly() ~= nil and SkillR:Ready() then 
			_Message.AddMessage("WARNING: Ally is below threshold!! Press R!!", _ColorARGB.Red)
			if Menu.AutoR then 
				SkillR:Cast(Monitor.GetLowAlly())
			end 
		end 
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillE})
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Shen") 
	Menu:addParam("AutoR", "Press R to teleport to player", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
-- }