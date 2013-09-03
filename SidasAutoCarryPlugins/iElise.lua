require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Elise" then return end 

	local HumanQ = Caster(_Q, 625, SPELL_TARGETED)
	local HumanW = Caster(_W, 950, SPELL_LINEAR_COL, math.huge, 0, 100, true)
	local HumanE = Caster(_E, 1075, SPELL_LINEAR_COL, 1450, 0.250, 50, true)

	local SpiderQ = Caster(_Q, 475, SPELL_TARGETED)
	local SpiderW = Caster(_W, math.huge, SPELL_SELF)
	local SpiderE = Caster(_E, 1075, SPELL_TARGETED)

	local SkillQ = HumanQ 
	local SkillW = HumanW 
	local SkillE = HumanE
	local SkillR = Caster(_R, math.huge, SPELL_SELF)

	local isSpider = false 

	local Menu = nil

	local combo = ComboLibrary()
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		isSpider = myHero:GetSpellData(_R).name == "EliseRSpider"
		UpdateSkills()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 0
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target)
				return not SkillQ:Ready() and not SkillW:Ready() and not SkillE:Ready()
			end)
		combo:AddCustomCast(_E, function(Target) 
				if isSpider then
					return (GetDistance(Target) <= Menu.eRange) or DamageCalculation.CalculateRealDamage(Target) > Target.health 
				end 
				return true
			end)
	end 

	function UpdateSkills() 
		if isSpider then
			combo:UpdateCaster(_Q, SpiderQ)
			combo:UpdateCaster(_W, SpiderW)
			combo:UpdateCaster(_E, SpiderE)
		else
			combo:UpdateCaster(_Q, HumanQ)
			combo:UpdateCaster(_W, HumanW)
			combo:UpdateCaster(_E, HumanE) 
		end  
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Elise") 
	Menu:addParam("eRange", "Jump with E range",SCRIPT_PARAM_SLICE, 400, 0, SpiderE.range, 0)
-- }