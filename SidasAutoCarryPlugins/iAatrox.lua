require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Aatrox" then return end 
	local SkillQ = Caster(_Q, 800, SPELL_CIRCLE, 1800, 0.270, 80)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 1000, SPELL_CONE, 1600, 0.270, 30)
	local SkillR = Caster(_R, math.huge, SPELL_SELF)

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
		combo:AddCustomCast(_W, function(Target) 
				local spellName = myHero:GetSpellData(_W).name
				return (myHero.health < myHero.maxHealth * 0.50 and spellName == "aatroxw2") or
					(myHero.health > myHero.maxHealth * 0.50 and spellName == "AatroxW") 
			end)
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
    end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Aatrox") 
-- }