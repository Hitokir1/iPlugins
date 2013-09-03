require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Xerath" then return end 
	local SkillQ = Caster(_Q, 1050, SPELL_LINEAR, math.huge, 0.600) 
	local SkillW = Caster(_W, 1750, SPELL_SELF)
	local SkillE = Caster(_E, 650, SPELL_TARGETED)
	local SkillR = Caster(_R, 900, SPELL_CIRCLE, math.huge, 0.250)
	local combo = ComboLibrary()

	local wActive = false
	local rTick = 0
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if rTick ~= 0 and GetTickCount() - rTick > 12000 then
			rTick = 0 
		end 
	
		UpdateCasters()
 	
 		if Target and AutoCarry.Keys.AutoCarry then
 			if (GetDistance(Target) > 1050 and GetDistance(Target) < 1750) and SkillW:Ready() and (SkillE:Ready() or SkillQ:Ready() or SkillR:Ready()) then
				if not wActive then
					SkillW:Cast(Target) 
					UpdateCasters()
				end 
			end 
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1750
		combo:AddCasters({SkillQ, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
				return ((rTick ~= 0 and GetTickCount() - rTick < 12000) or (DamageCalculation.CalculateRealDamage(Target) > Target.health or getDmg("R", Target, myHero) > Target.health))
			end)
	end 

	function Plugin:OnCreateObj(obj) 
		if obj and obj.name:find("Xerath_LocusOfPower") then
			wActive = true 
			AutoCarry.CanMove = false
		end 
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj and obj.name:find("Xerath_LocusOfPower") then
			wActive = false
			AutoCarry.CanMove = false
		end 
	end 


	function UpdateCasters() 
		if wActive then
			SkillQ.range = 1750
			SkillE.range = 950
			SkillR.range = 1600
		else
			SkillQ.range = 1050 
			SkillE.range = 650
			SkillR.range = 900 
		end 
		combo:UpdateCaster(_Q, SkillQ)
		combo:UpdateCaster(_E, SkillE)
		combo:UpdateCaster(_R, SkillR)
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Xerath") 
-- }