require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Fizz" then return end 

	local Menu = nil

	local AvoidSkillList = {
	-- AOE
		["UFSlash"] = 300,
		["GragasExplosiveCask"] = 400,
		["CurseoftheSadMummy"] = 550,
		["LeonaSolarFlare"] = 400,
		["InfernalGuardian"] = 250,
		["DianaVortex"] = 300,
		["RivenMartyr"] = 200,
		["OrianaDetonateCommand"] = 400,
		["DariusAxeGrabCone"] = 200,
		["LeonaZenithBladeMissile"] = 200,
		["ReapTheWhirlwind"] = 600,
		["ShenShadowDash"] = 350,
		["GalioIdolOfDurand"] = 600,
		["XenZhaoParry"] = 200,
		["EvelynnR"] = 400,
		["Pulverize"] = 250,
		["VladimirHemoplague"] = 200,
	-- Target
		["Headbutt"] = 0,
		["Dazzle"] = 0,
		["CrypticGaze"] = 0,
		["Pantheon_LeapBash"] = 0,
		["RenektonPreExecute"] = 0,
		["IreliaEquilibriumStrike"] = 0,
		["MaokaiUnstableGrowth"] = 0,
		["BusterShot"] = 0,
		["BlindMonkRKick"] = 0,
		["VayneCondemn"] = 0,
		["SkarnerImpale"] = 0,
		["ViR"] = 0,
		["Terrify"] = 0,
		["IceBlast"] = 0,
		["NullLance"] = 0,
		["PuncturingTaunt"] = 0,
		["BlindingDart"] = 0,
		["VeigarPrimordialBurst"] = 0,
		["DeathfireGrasp"] = 0,
		["GarenJustice"] = 0,
		["DariusExecute"] = 0,
		["ZedUlt"] = 0,
		["PickaCard_yellow_mis.troy"] = 0,
		["RunePrison"] = 0,
		["PoppyHeroicCharge"] = 0,
		["AlZaharNetherGrasp"] = 0,
		["InfiniteDuress"] = 0,
		["UrgotSwap2"] = 0,
		["TalonCutthroat"] = 0,
		["LeonaShieldOfDaybreakAttack"] = 0,
	}

	local SkillQ = Caster(_Q, 550, SPELL_TARGETED)
	local SkillW = Caster(_W, 225, SPELL_SELF)
	local SkillE = Caster(_E, 400, SPELL_SELF) -- special 
	local SkillR = Caster(_R, 1275, SPELL_LINEAR_COL, 1380, 1.38, 50, true) 

	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1275
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range)end)
		combo:AddCustomCast(_E, function(Target) return ValidTarget(Target, SkillE.range)end)	
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		combo:AddCast(_E, function(Target)
				CastSpell(_E, Target.x, Target.z)
			end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnProcessSpell(unit, spell)
		if unit and spell and unit.team ~= myHero.team and AvoidSkillList[spell.name] and Menu.autoAvoid then 
			if (AvoidSkillList[spell.name] > 0 and GetDistance(spell.endPos) < AvoidSkillList[spell.name]) or spell.target == myHero then 
				CastSpell(_E)
			end
		end 
	end 

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Fizz") 
	Menu:addParam("desc1","-- Spell Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("autoAvoid", "Avoid spells using E", SCRIPT_PARAM_ONOFF, true)
-- }
