require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Lissandra" then return end 

	local SkillQ = Caster(_Q, 700, SPELL_LINEAR, 2250, 0.250, 100, true) 
	local SkillW = Caster(_W, 450, SPELL_SELF)
	local SkillE = Caster(_E, 1025, SPELL_LINEAR, 853, 0.250, 100, true) 
	local SkillR = Caster(_R, 700, SPELL_TARGETED) 

	local eClaw = nil

	local combo = ComboLibrary()
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if eClaw ~= nil and not eClaw.valid then
			eClaw = nil 
		end 
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 650
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		combo:AddCustomCast(_E, function(Target) return ((eClaw == nil) or (eClaw ~= nil and not eClaw.valid)) end)
		combo:AddCast(_R, function(Target)
				SkillR:CastMec(Target, 2)
			end)
	end 

	function Plugin:OnCreateObj(object) 
		if object.name:find("Lissandra_E_Missile.troy") then
			eClaw = object
		end
	end 

	function Plugin:OnDeleteObj(object) 
		if object.name:find("Lissandra_E_Missile.troy") then
			eClaw = nil
		end
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Lissandra") 
-- }