require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Maokai" then return end 

	local SkillQ = Caster(_Q, 600, SPELL_LINEAR) 
	local SkillW = Caster(_W, 650, SPELL_TARGETED)
	local SkillE = Caster(_E, 1100, SPELL_CIRCLE)
	local SkillR = Caster(_R, 625, SPELL_CIRCLE, math.huge, 0, 1150)

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
		AutoCarry.Crosshair.SkillRange = 1100
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
				return Monitor.CountEnemies(Target, SkillR.width) >= 2 
			end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Maokai") 
-- }
