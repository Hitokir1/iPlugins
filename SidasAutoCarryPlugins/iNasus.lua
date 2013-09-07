--[[

require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "" then return end 
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
		AutoCarry.Crosshair.SkillRange = 0
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "") 
-- }

--]]
class 'Plugin' -- {
	require "iFoundation_v2"


	if myHero.charName ~= "Nasus" then return end 

	local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
	local SkillW = Caster(_W, 700, SPELL_TARGETED)
	local SkillE = Caster(_E, 650, SPELL_CIRCLE)
	local SkillR = Caster(_R, 300, SPELL_SELF)
	
	local combo = ComboLibrary()

	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 700
		combo:AddCasters({SkillQ, SkillW, SkillE})
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
			--if SkillR:Ready() then SkillR:Cast(Target) end 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Nasus") 
-- }