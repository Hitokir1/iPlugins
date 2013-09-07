require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Karthus" then return end 
	local SkillQ = Caster(_Q, 875, SPELL_CIRCLE, 900, 0.25)
	local SkillW = Caster(_W, 1000, SPELL_CONE)
	local SkillE = Caster(_E, 425, SPELL_SELF)
	local SkillR = Caster(_R, math.huge, SPELL_SELF)

	local Menu = nil

	local eEnabled = false 

	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
				return Menu.rKS 
			end)
		combo:AddCast(_E, function(Target) 
				if (Menu.eMonitor and not eEnabled) and (Target and GetDistance(Target) <= SkillE.range) then
					SkillE:Cast(Target) 
				end 
			end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Menu.eMonitor and eEnabled and (Target == nil or GetDistance(Target) > SkillE.range) then
			SkillE:Cast(Target)
		end 
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnCreateObj(obj) 
		if obj ~= nil and obj.name == "Defile_glow.troy" then
	        eEnabled = true
	    end
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj ~= nil and obj.name == "Defile_glow.troy" then
	        eEnabled = false
	    end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Karthus") 
	Menu:addParam("rKS", "KS with R (MEGAKILL)", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("eMonitor", "Monitor E (disable for manual)", SCRIPT_PARAM_ONOFF, true)
-- }