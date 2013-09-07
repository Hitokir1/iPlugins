require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Vladimir" then return end 
	local SkillQ = Caster(_Q, 600, SPELL_TARGETED)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 600, SPELL_SELF)
	local SkillR = Caster(_R, 700, SPELL_CIRCLE)
	local combo = ComboLibrary()

	local Menu = nil

	local eTick = 0
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 700
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return (ComboLibrary.KillableCast(Target, "R") or Monitor.CountEnemies(Target, SkillR.width) > Menu.rAmount) end)
		combo:AddCast(_R, function(Target) SkillR:CastMec(Target, Menu.rAmount) end)
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if SkillE:Ready() and not Monitor.IsTeleporting() and Menu.eStack and GetTickCount() - eTick >= 9500 then
			eTick = GetTickCount()
			SkillE:Cast(Target)
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Vladimir") 
	Menu:addParam("sep1", "-- Spell Cast Options --", SCRIPT_PARAM_INFO, "")
    Menu:addParam("eStack", "Stack E", SCRIPT_PARAM_ONOFF, true)
    Menu:addParam("rAmount", "Amount of people to use R on",SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
-- }