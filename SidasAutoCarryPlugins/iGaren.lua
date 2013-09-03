require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Garen" then return end 
	local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 200, SPELL_SELF)
	local SkillR = Caster(_R, 400, SPELL_TARGETED)
	local isSpinning = false
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
		AutoCarry.Crosshair.SkillRange = 400
		combo:AddCasters({SkillE, SkillR})
		AutoShield.Instance(SkillW.range, SkillW)
		AutoBuff.Instance(SkillQ)
		combo:AddCustomCast(_R, function(Target)
				return ComboLibrary.KillableCast(Target, "R") 
			end)
		combo:AddCustomCast(_E, function(Target)
				return not isSpinning
			end)
	end 

	function Plugin:OnCreateObj(obj) 
		if obj and GetDistance(obj) < 500 then 
			if obj.name:find("garen_bladeStorm") then 
				isSpinning = true 
			end 
		end 
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj and GetDistance(obj) < 500 then 
			if obj.name:find("garen_bladeStorm") then 
				isSpinning = false 
			end 
		end 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Garen") 
-- }
