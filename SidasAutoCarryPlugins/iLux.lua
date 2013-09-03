require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Lux" then return end 
	local SkillQ = Caster(_Q, 1150, SPELL_LINEAR_COL, 1175, 0.250, 80, true)
	local SkillW = Caster(_W, 1075, SPELL_LINEAR, 1400, 0.150, 50, true)
	local SkillE = Caster(_E, 1100, SPELL_CIRCLE, 1300, 0.150, 275, true)
	local SkillR = Caster(_R, 3000, SPELL_LINEAR, math.huge, 0.700, 200, true)
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if EParticle ~= nil and not EParticle.valid then 
			EParticle = nil 
		elseif EParticle ~= nil and EParticle.valid and Target and GetDistance(EParticle, Target) <= 275 then
			SkillE:Cast(Target)
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 3000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return Menu.rCombo and ComboLibrary.KillableCast(Target, "R") 
			end)
		combo:AddCustomCast(_W, function(Target) 
				return myHero.health / myHero.maxHealth <= (Menu.wPercentage / 100)
			end)
		combo:AddCustomCast(_E, function(Target)
				return EParticle == nil 
			end)
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function Plugin:OnCreateObj(object)
		if object.name:find("LuxLightstrike_tar") then
			EParticle = object
		end
	end

	function Plugin:OnDeleteObj(object)
		if object.name:find("LuxLightstrike_tar") or (EParticle and EParticle.rawHash == object.rawHash) then
			EParticle = nil
		end 
	end

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Lux") 
	Menu:addParam("rCombo", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("wPercentage", "Monitor w percentage",SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
-- }