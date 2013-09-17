require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Draven" then return end 
	local SkillW = Caster(_W, Combat.GetTrueRange(), SPELL_SELF)
	local Menu = nil
 
 	local reticles = {}
	local qStacks = 0
	local aPred = nil

	function Plugin:__init() 
		AutoCarry.Plugins:RegisterPreAttack(function(Target) self:CustomAttackEnemy(Target) end)
		aPred = TargetPredictionVIP(Combat.GetTrueRange(), 1900, 0.100, 20)
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if Catch() and next(reticles) then
			if GetDistance(reticles[1]) > 90 and ShouldCatch(reticles[1]) then
				myHero:MoveTo(reticles[1].x, reticles[1].z) 
			end 
		end 
		if Target and AutoCarry.Keys.AutoCarry then 
			if ValidTarget(Target, SkillW.range) then 
				SkillW:Cast(Target)
			end
		end 
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair:SetSkillCrosshairRange(1200)
	end 

	function Plugin:OnProcessSpell(unit, spell)
		if unit.isMe and spell.name == "dravenspinning" then 
			qStacks = qStacks + 1 
		end 
	end 

	function Plugin:OnCreateObj(object)
		if myHero.dead then return end 
		if object then 
			if GetDistance(myHero, object) <= Menu.catchRange and object.name == "Draven_Q_reticle_self.troy" then
				table.insert(reticles, object) 
			elseif object.name == "draven_spinning_buff_end_sound.troy" then 
				qStacks = 0 
			end 
		end 
	end 

	function Plugin:OnDeleteObj(object) 
		if object then
			if GetDistance(myHero, object) <= Menu.catchRange and object.name == "Draven_Q_reticle_self.troy" then
				table.remove(reticles, 1) 
				qStacks = qStacks - 1
			end
		end 
	end 

	function Plugin:CustomAttackEnemy(Target) 
		if GetDistance(mousePos) <= Menu.catchRange then 
			if qStacks < 2 then CastSpell(_Q) end 
		end 
		myHero:Attack(Target)
	end 

	function ShouldCatch(reticle)
	    local enemy
	    if AutoCarry.Orbwalker.target ~= nil then enemy = AutoCarry.Orbwalker.target
	    elseif AutoCarry.SkillsCrosshair.target ~= nil then enemy = AutoCarry.SkillsCrosshair.target
	    else return true end
	    if not reticle then return false end
	    if GetDistance(mousePos, enemy) > GetDistance(enemy) then
	        if GetDistance(reticle, enemy) < GetDistance(enemy) then
	            return false
	        end
	        return true
	    else
	        local closestEnemy
	        for _, thisEnemy in pairs(AutoCarry.EnemyTable) do
	            if not closestEnemy then closestEnemy = thisEnemy
	            elseif GetDistance(thisEnemy) < GetDistance(closestEnemy) then closestEnemy = thisEnemy end
	        end
	        if closestEnemy then
	            local predPos = aPred:GetPrediction(closestEnemy)
	            if not predPos then return true end
	            if GetDistance(reticle, predPos) > Combat.GetTrueRange() + getHitBoxRadius(closestEnemy) then
	                return false
	            end
	            return true
	        else
	            return true
	        end
	    end
	end

	function Catch() 
		return AutoCarry.Keys.AutoCarry or AutoCarry.Keys.LastHit or AutoCarry.Keys.LaneClear or AutoCarry.Keys.MixedMode
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Draven") 
	Menu:addParam("catchRange", "Catch range",SCRIPT_PARAM_SLICE, 1200, 0, 1500, 0)

-- }