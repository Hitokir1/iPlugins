require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "FiddleSticks" then return end 

	local SkillQ = Caster(_Q, 575, SPELL_TARGETED)
	local SkillW = Caster(_W, 475, SPELL_TARGETED)
	local SkillE = Caster(_E, 750, SPELL_TARGETED)
	local SkillR = Caster(_R, 800, SPELL_SELF)

	local wTick = 0
	local wCast = false
	local wDuration = 5000

	local combo = ComboLibrary()

		
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 800
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return (getDmg("R", Target, myHero) >= Target.health or Monitor.CountEnemies(myHero, SkillR.range) >= 2) end)
		combo:AddCast(_W, function(Target) SkillW:Cast(Target) wTick = GetTickCount() end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Fiddlesticks") 
-- }