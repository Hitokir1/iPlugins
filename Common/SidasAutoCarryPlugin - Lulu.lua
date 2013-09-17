require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Lulu" then return end 
	local SkillQ = Caster(_Q, 950, SPELL_LINEAR, 1350, 0.203, 50, true) 
	local SkillW = Caster(_W, 650, SPELL_TARGETED) 
	local SkillE = Caster(_E, 650, SPELL_TARGETED)
	local SkillEShield = Caster(_E, 650, SPELL_TARGETED_FRIENDLY)
	local SkillR = Caster(_R, 900, SPELL_TARGETED)
	local combo = ComboLibrary()
	local Menu = nil 
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(950)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCast(_R, function(Target)
				if Monitor.GetLowAlly() ~= nil then
					SkillR:Cast(Monitor.GetLowAlly())
				elseif myHero.health / myHero.maxHealth <= (Menu.rPercentage / 100) then
					SkillR:Cast(myHero) 
				end 
			end)
		combo:AddCast(_E, function(Target)
				if Monitor.GetLowAlly() ~= nil then 
					SkillE:Cast(Monitor.GetLowAlly()) 
				else
					SkillE:Cast(Target) 
				end 
			end)
		Priority.Instance(true)
		AutoShield.Instance(SkillEShield.range, SkillEShield)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Lulu") 
	Menu:addParam("rPercentage", "R Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

-- }