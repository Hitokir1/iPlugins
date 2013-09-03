require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Irelia" then return end 
	local SkillQ = Caster(_Q, 650, SPELL_TARGETED)
	local SkillW = Caster(_W, 700, SPELL_SELF)
	local SkillE = Caster(_E, 650, SPELL_TARGETED)
	local SkillR = Caster(_R, 1000, SPELL_LINEAR)
	local combo = ComboLibrary()

	local rTick = 0
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if rTick ~= 0 and GetTickCount() - rTick > 15000 then
			rTick = 0 
		end 
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ((rTick ~= 0 and GetTickCount() - rTick < 15000) or ComboLibrary.KillableCast(Target, "R")) end)
		combo:AddCast(_R, function(Target) 
				if rTick == 0 then
					rTick = GetTickCount()
				end 
				SkillR:Cast(Target) 
			end)
		AutoBuff.Instance(SkillW)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Irelia") 
-- }