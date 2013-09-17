require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Veigar" then return end 

	local SkillQ = Caster(_Q, 650, SPELL_TARGETED)
	local SkillW = Caster(_W, 900, SPELL_CIRCLE, 1500, 1.35, 185, true)
	local SkillE = Caster(_E, 800, SPELL_CIRCLE, math.huge, 0, 600, true)
	local SkillR = Caster(_R, 650, SPELL_TARGETED)

	local combo = ComboLibrary()
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(900)
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		--combo:AddCast(_E, function(Target) SkillE:CastMec(Target, 1) end)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Veigar") 
-- }