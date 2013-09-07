require "iFoundation_v2"

class 'Plugin' -- {

	if myHero.charName ~= "JarvanIV" then return end 
	local SkillQ = Caster(_Q, 770, SPELL_LINEAR, math.huge, 0.200, 100, true)
	local SkillW = Caster(_W, math.huge, SPELL_SELF)
	local SkillE = Caster(_E, 830, SPELL_CIRCLE, math.huge, 0.200, 100, true)
	local SkillR = Caster(_R, 650, SPELL_TARGETED)
	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 600
		combo:AddCasters({SkillE, SkillQ, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastSequenced(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "JarvanIV") 
-- }