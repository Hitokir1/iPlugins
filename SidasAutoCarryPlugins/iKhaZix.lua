require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Khazix" then return end 
	local SkillQ = Caster(_Q, 325, SPELL_TARGETED)
	local SkillW = Caster(_W, 1030, SPELL_LINEAR_COL, 1835, 0.225, 110, true)
	local SkillE = Caster(_E, 600, SPELL_CIRCLE, math.huge, 0, 100, true)
	local SkillR = Caster(_R, math.huge, SPELL_SELF)
	local combo = ComboLibrary()
	local Menu = nil
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		CheckEvolution()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillW, SkillE})
		combo:AddCustomCast(_E, function(Target)
				return ((ComboLibrary.KillableCast(Target, "E")) or GetDistance(Target) <= Menu.EJump)
			end)
	end 

	function CheckEvolution()
		if myHero:GetSpellData(_E).name == "khazixelong" then
	  		SkillE.range = 900
	 	end 
	 	if myHero:GetSpellData(_Q).name == "khazixqlong" then
	  		SkillQ.range = 375
	 	end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Khazix")
	Menu:addParam("EJump", "Distance to jump in with E (when not killable)",SCRIPT_PARAM_SLICE, 400, 0, 600, 0)
-- }