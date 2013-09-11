require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Nidalee" then return end 
	local HumanQ = Caster(_Q, 1500, SPELL_LINEAR_COL, 1300, 0.100, 60, true)
	local HumanW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0.900, 80, true)
	local HumanE = Caster(_E, 600, SPELL_TARGETED_FRIENDLY)

	local CougarQ = Caster(_Q, 225, SPELL_SELF) 
	local CougarW = Caster(_W, 375, SPELL_SELF)
	local CougarE = Caster(_E, 300, SPELL_SELF)

	local SkillQ = HumanQ 
	local SkillW = HumanW 
	local SkillE = HumanE
	local SkillR = Caster(_R, math.huge, SPELL_SELF)

	local Menu = nil

	local isCougar = false

	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1500
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		AutoShield.Instance(HumanE.range, HumanE)
		combo:AddCustomCast(_Q, function(Target) return ValidTarget(Target, SkillQ.range) end)
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range) end)
		combo:AddCustomCast(_E, function(Target) return ValidTarget(Target, SkillE.range) end)
		combo:AddCustomCast(_R, function(Target) 
				if isCougar then 
					return (GetDistance(Target) > 500) and (myHero.health / myHero.maxHealth) > (Menu.escapeHp / 100) 
				else 
					return GetDistance(Target) < 225 or (myHero.health / myHero.maxHealth) < (Menu.escapeHp / 100) 
				end 
			end)

	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		isCougar = myHero:GetSpellData(_Q).name == "Takedown"
		UpdateSkills()

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	function UpdateSkills()
		if isCougar then 
			combo:UpdateCaster(_Q, CougarQ)
			combo:UpdateCaster(_W, CougarW)
			combo:UpdateCaster(_E, CougarE)
		else
			combo:UpdateCaster(_Q, HumanQ)
			combo:UpdateCaster(_W, HumanW)
			combo:UpdateCaster(_E, HumanE) 
		end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Nidalee") 
	Menu:addParam("desc1","-- Spell Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("escapeHp", "Cougar Override HP (runaway)",SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
-- }