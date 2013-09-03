require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Darius" then return end 
	local combo = ComboLibrary()

	local SkillQ = Caster(_Q, 425, SPELL_SELF)
	local SkillW = Caster(_W, 145, SPELL_SELF)
	local SkillE = Caster(_E, 540, SPELL_LINEAR_COL, math.huge, 0, 100, true)
	local SkillR = Caster(_R, 460, SPELL_TARGETED)

	local hemoTable = {
	        [1] = "darius_hemo_counter_01.troy",
	        [2] = "darius_hemo_counter_02.troy",
	        [3] = "darius_hemo_counter_03.troy",
	        [4] = "darius_hemo_counter_04.troy",
	        [5] = "darius_hemo_counter_05.troy",
	}
	local enemyTable = {}

	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		enemy = GetEnemy(Target) 
		if Target and AutoCarry.Keys.AutoCarry then
			if (GetTickCount() - enemy.hemo.tick > 5000) or (enemy and enemy.dead) then enemy.hemo.count = 0 end
			combo:CastCombo(Target) 
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 600
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, 
			function(Target)
				local hemoCount = GetEnemy(Target).hemo.count
				return (getDmg("R", Target, myHero) * (hemoCount * 0.2) > Target.health) or (hemoCount == 5) 
			end)
		combo:AddCustomCast(_Q, function(Target) return ValidTarget(Target, SkillQ.range) end)
		combo:AddCustomCast(_W, function(Target) return ValidTarget(Target, SkillW.range) end)
		combo:AddCustomCast(_E, function(Target) return ValidTarget(Target, SkillE.range) end)
		for i=0, heroManager.iCount, 1 do
	        local playerObj = heroManager:GetHero(i)
	        if playerObj and playerObj.team ~= myHero.team then
	                playerObj.hemo = { tick = 0, count = 0, }
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

	function Plugin:OnCreateObj(obj)
		if obj then
			if string.find(string.lower(obj.name),"darius_hemo_counter") then
	            for i, enemy in pairs(enemyTable) do
	                if enemy and not enemy.dead and enemy.visible and GetDistance(enemy,obj) <= 50 then
	                    for k, hemo in pairs(hemoTable) do
	                        if obj.name == hemo then
	                            enemy.hemo.tick = GetTickCount()
	                            enemy.hemo.count = k
	                            PrintFloatText(enemy,21,k .. " Bleedings")
	                        end
	                    end
	                end
	            end
	        end
	    end 
	end 


	local Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Darius") 
-- }
