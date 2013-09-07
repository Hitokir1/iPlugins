class 'Plugin' -- {
	
	require "iFoundation_v2"
	if myHero.charName ~= "Tristana" then return end 

	local combo = ComboLibrary()

	local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
	local SkillW = Caster(_W, 900, SPELL_CIRCLE, math.huge, 0, 100, true)
	local SkillE = Caster(_E, 650, SPELL_TARGETED)
	local SkillR = Caster(_R, 645, SPELL_TARGETED)

	local Menu = nil

	function Plugin:__init()
		AutoCarry.Crosshair.SkillRange = 900
		combo:AddCasters({SkillW, SkillE, SkillR})
		combo:AddCast(_W, function(target) PlaceWall(target) end)
		AutoBuff.Instance(SkillQ)
    end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry then
			if Menu.Insec then 
				combo:CastSequenced(Target, true) 
			else 
				combo:CastCombo(Target) 
			end 
		end
	end 

	function PlaceWall(enemy) 
		if SkillW:Ready() and GetDistance(enemy) <= SkillW.range then
			local TargetPosition = Vector(enemy.x, enemy.y, enemy.z)
			local MyPosition = Vector(myHero.x, myHero.y, myHero.z)		
			local WallPosition = TargetPosition + (TargetPosition - MyPosition)*((150/GetDistance(enemy)))
			CastSpell(_W, WallPosition.x, WallPosition.z)
		end
	end

	function Plugin:OnLoad() 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Tristana") 
	Menu:addParam("Insec", "Insec", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Q"))

-- }