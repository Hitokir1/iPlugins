require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Sona" then return end 
	local SkillQ = Caster(_Q, 700, SPELL_SELF)
	local SkillW = Caster(_W, 1000, SPELL_SELF)
	local SkillE = Caster(_E, 1000, SPELL_SELF)
	local SkillR = Caster(_R, 1000, SPELL_LINEAR)

	local Ally, damage = nil, nil 
	local targetDamage = 0

	local Menu = nil

	NONE = 0 -- DERP?
	VALOR = 1 -- AD/AP BUFF
	PERSEVERANCE = 2 -- RESISTANCE BUFF
	CELERITY = 3 -- MOVEMENT SPEED BUFF

	local AuraTable = {
		["valoraura"] = VALOR, 
		["perseveranceaura"] = PERSEVERANCE, 
		["discordaura"] = CELERITY
	}

	local currentAura = NONE 
	local powerCord = false 
	
	function Plugin:__init() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(1000)
		AutoShield.override = true
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Target and AutoCarry.Keys.AutoCarry and not Monitor.IsTeleporting() then
			Ally, damage = Monitor.GetHighestDamageAlly()
			if Ally then 
				targetDamage = DamageCalculation.CalculateRealDamage(Ally, Target) 
			end 
			if powerCord then 
				if damage >= Target.health or MovementPrediction.GetDirection(Target) == DIRECTION_AWAY then 
					if currentAura ~= CELERITY then 
						SkillE:Cast(Target) 
					end 
					myHero:Attack(Target) 
				elseif Ally and targetDamage >= Ally.health then 
					if currentAura ~= PERSEVERANCE then 
						SkillW:Cast(Target) 
					end 
					myHero:Attack(Target)
				elseif (getDmg("Q", Target, myHero) * 2) < Target.health then 
					if currentAura ~= VALOR then 
						SkillE:Cast(Target) 
					end 
					myHero:Attack(Target)
				end 
			else
				Poke(Target) 
				Heal(Ally)
			end 
		end
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnGainBuff(unit, buff) 
		if unit and buff then 
			if buff.name == "sonapowercord" then
				powerCord = true 
				PrintFloatText(myHero, 21, "PowerCord!")
			end 
			for aura, value in pairs(AuraTable) do 
				if buff.name == aura then 
					currentAura = value
					break 
				end 
			end 
		end 
	end 

	function Plugin:OnLoseBuff(unit, buff) 
		if unit and buff then 
			if buff.name == "sonapowercord" then
				powerCord = false
			end 
		end 
	end 

	function Heal(ally)
		if not SkillW:Ready() then return false end 
		if ally then 
			if (ally.health / ally.maxHealth) < (Menu.wPercent / 100) and GetDistance(ally) <= SkillW.range then
				return SkillW:Cast(ally) 
			end 
		else 
			local distance = math.huge 
			local best = nil 
			for _, player in pairs(_Heroes.GetObjects(ALLY, SkillW.range)) do 
				if best == nil then 
					best = player
					distance = GetDistance(player)
				elseif GetDistance(player) < distance and best.health < player.health then 
					best = player 
					distance = GetDistance(player) 
				end 
			end 

			if best and GetDistance(player) < SkillW.range then 
				if (best.health / best.maxHealth) < (Menu.wPercent / 100) then
					return SkillW:Cast(Target) 
				end 
			end 
 		end 
	end 

	function Poke(Target)
		if not Target or not SkillQ:Ready() then return false end 
		if Target then 
			if GetDistance(Target) <= SkillQ.range then 
				local qDmg = getDmg("Q", Target, myHero) 
				if Target.health > qDmg then 
					return SkillQ:Cast(Target) 
				end 
			end 
		end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Sona") 
	Menu:addParam("wPercent", "Heal Percentage",SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
-- }