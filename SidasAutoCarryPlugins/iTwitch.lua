require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Twitch" then return end 
	local SkillQ = Caster(_Q, math.huge, SPELL_SELF)
	local SkillW = Caster(_W, 950, SPELL_CIRCLE, 1600, 0.250, 100, true)
	local SkillE = Caster(_E, 1200, SPELL_SELF)
	local SkillR = Caster(_R, 850, SPELL_SELF)

	local enemyTable = {}

	local combo = ComboLibrary()
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		enemy = GetEnemy(Target)

		if enemy then
			if (GetTickCount() - enemy.posion.tick > 6500) or enemy.dead then enemy.posion.count = 0 end 
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1200
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_E, function(Target) 
				enemy = GetEnemy(Target)
				return enemy and enemy.posion.count == 6 
			end)
		combo:AddCustomCast(_R, function(Target) return ComboLibrary.KillableCast(Target, "R") end)
		for i=0, heroManager.iCount, 1 do
	        local playerObj = heroManager:GetHero(i)
	        if playerObj and playerObj.team ~= myHero.team then
	                playerObj.posion = { tick = 0, count = 0, }
	                table.insert(enemyTable,playerObj)
	        end
		end
	end 

	function GetEnemy(target) 
		for i, enemy in pairs(enemyTable) do 
			if enemy and not enemy.dead and enemy.visible and enemy == target then
				return enemy
			end 
		end 
	end 

	function OnGainBuff(unit, buff) 
		if unit == nil or buff == nil then return end 
		if buff.source == myHero and buff.name:find("deadlyvenom") then
			for i, enemy in pairs(enemyTable) do 
				if enemy and not enemy.dead and enemy.visible and enemy == unit then
					enemy.posion.tick = GetTickCount()
					enemy.posion.count = 1
				end 
			end 
		end 
	end 

	function OnUpdateBuff(unit, buff) 
		if unit == nil or buff == nil then return end 
		if buff.source == myHero and buff.name == "deadlyvenom" then
			for i, enemy in pairs(enemyTable) do 
				if enemy and not enemy.dead and enemy.visible and enemy == unit then
					enemy.posion.tick = GetTickCount()
					enemy.posion.count = buff.stack
				end 
			end 
		end 
	end 

	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Twitch") 
-- }