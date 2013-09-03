require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Sona" then return end 
	local SkillQ = Caster(_Q, 700, SPELL_SELF)
	local SkillW = Caster(_W, 1000, SPELL_SELF)
	local SkillE = Caster(_E, 1000, SPELL_SELF)
	local SkillR = Caster(_R, 1000, SPELL_LINEAR)

	local Ally, damage = nil, nil 

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
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		UpdateAura()
		if Target and AutoCarry.Keys.AutoCarry then
			Ally, damage = Monitor.GetHighestDamageAlly()
			if not BuffManager.TargetHaveBuff(myHero, "sonapowercord") then
				if SkillW:Ready() and Monitor.GetLowAlly() ~= nil and GetDistance(Monitor.GetLowAlly()) > SkillW.range then
					SkillW:Cast(Target)
				end
				if SkillQ:Ready() and getDmg("Q", Target, myHero) < Target.health then
					SkillQ:Cast(Target)
				end 
			else
				PrintChat("PowerCord")
				if Ally and Target.health < damage and SkillE:Ready() and currentAura ~= CELERITY then
					SkillE:Cast(Target)
				elseif SkillQ:Ready() and Target.health > (getDmg("Q", Target, myHero) * 3) and currentAura ~= VALOR then
					SkillQ:Cast(Target)
				elseif SkillW:Ready() and currentAura ~= PERSEVERANCE then
					SkillW:Cast(Target) 
				end 
				myHero:Attack(Taget) 
			end 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1000
		AutoShield.Instance(SkillW.range, SkillW)
	end 

	function UpdateAura() 
		for aura, value in pairs(AuraTable) do 
			if BuffManager.TargetHaveBuff(myHero, aura) then 
				currentAura = value
				break 
			end 
		end 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Sona") 
-- }