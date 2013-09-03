require "iFoundation_v2"
require "AoE_Skillshot_Position"

class 'Plugin' -- {
	
	if myHero.charName ~= "Evelynn" then return end 
	local SkillQ = Caster(_Q, 500, SPELL_SELF)
	local SkillW = Caster(_W, 0, SPELL_SELF)
	local SkillE = Caster(_E, 225, SPELL_TARGETED)
	local SkillR = Caster(_R, 650, SPELL_CIRCLE, math.huge, 0, 0, true)
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
		AutoCarry.Crosshair.SkillRange = 650
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return getDmg("R", Target, myHero) > Target.health or Monitor.CountEnemies(Target, SkillR.range) >= 3 end)
		combo:AddCast(_R, function(Target) 
				local p = GetAoESpellPosition(350, Target)
				if p and GetDistance(p) <= SkillR.range then
					CastSpell(_R, p.x, p.z)
				end
			end)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Evelynn") 
-- }