require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Karma" then return end 
	local SkillQ = Caster(_Q, 1050, SPELL_LINEAR_COL, 1800, 0.250, 100, true) 
	local SkillW = Caster(_W, 650, SPELL_TARGETED)
	local SkillE = Caster(_E, 800, SPELL_TARGETED) 
	local SkillR = Caster(_R, math.huge, SPELL_SELF) 
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1050
		combo:AddCasters({SkillQ, SkillW, SkillR})
		combo:AddCast(_R, function(Target) 
				SkillR:Cast(Target) 
				if myHero.health <= myHero.maxHealth * (Menu.wPercentage / 100) then
					SkillW:Cast(Target) 
				elseif Monitor.GetLowAlly() ~= nil then
					SkillE:Cast(Monitor.GetLowAlly()) 
				else
					SkillQ:Cast(Target)
				end 
			end)
		AutoShield.Instance(SkillE.range, SkillE)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Karma") 
	Menu:addParam("ePercentage", "E Percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	Menu:addParam("wPercentage", "W Percentage w/ R",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
-- }