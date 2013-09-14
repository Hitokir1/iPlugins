--[[
	
	Currently a WIP; this library is designed to make awarness methods absolete, and instead introduce
	a universal system of callbacks using a manager to simply distribute them. This allows much more
	information for the script writer, and much more flexability. 

	Version 0.0
	- Initial release

--]]
require "MapPosition"

local ObjectTable = {
	["Turret"] = "obj_AI_Turret",
	["NPC"] = "obj_AI_Minion", 

}

--[[
	EventManager

	Brains of the operation, used for event management. 
--]]
class 'EventManager' -- {

	EventManager.instance = ""

	function EventManager.Instance()
		if EventManager.instance == "" then EventManager.instance = EventManager() end 
		return EventManager.instance 
	end 
	
	function EventManager:__init()
		self.Events = {}
	end 

	function EventManager.RegisterEvent(name) 
		EventManager.Instance():_RegisterEvent(name)
	end 

	function EventManager:_RegisterEvent(name)
		self.Events[name] = {functions = {}}
	end 

	function EventManager.RegisterCallback(EventName, Func) 
		EventManager.Instance():_RegisterCallback(EventName, Func)
	end 

	function EventManager:_RegisterCallback(EventName, Func)
		table.insert(self.Events[EventName], {callback = Func})
	end 

	function EventManager.FireEvent(EventName, table)
		EventManager.Instance():_FireEvent(EventName, table)
	end 

	function EventManager:_FireEvent(EventName, tab)
		for index, obj in pairs(self.Events[EventName]) do 
			if obj.callback ~= nil then 
				obj.callback(table.unpack(tab))	
			end
		end 
	end 

-- }

--[[
	iTurrets 

	Callbacks:
		- TurretDamage (object, lastHealth, currentHealth)
--]]
class 'iTurrets' -- {
	
	function iTurrets:__init() 
		self.turrets = {}
		self.EventName = "TurretDamage"

		for i=1, objManager.maxObjects do
			local obj = objManager:getObject(i) 
			if obj and obj.valid and obj.type == ObjectTable["Turret"] then 
				table.insert(self.turrets, {object = obj, lastHealth = 0})
			end 
		end
		EventManager.RegisterEvent(self.EventName)
		AddTickCallback(function(obj) self:OnTick() end)
	end 

	function iTurrets:OnTick()
		for index, turret in pairs(self.turrets) do 
			local object = turret.object
			if object.valid then 
				if object.health ~= turret.lastHealth then 
					EventManager.FireEvent(self.EventName, {object, turret.lastHealth, object.health})
					self.turrets[index].lastHealth = object.health 
				end 
			end 
		end 
	end 

-- }

--[[
	iHeroes

	Callbacks:
		- LocationChange (unit, current (string), last (string))
		- HPChange (unit, current (int), last (int))
		- ManaChange (unit, current (int), last(int))
		- OnRecall (unit)
		- OnDeath (unit, deathTimer)
--]]
class 'iHeroes' -- {

	local Locations = {
		["TOP"] = function(unit) return MapPosition:onTopLane(unit) end,
		["MID"] = function(unit) return MapPosition:onMidLane(unit) end,
		["BOT"] = function(unit) return MapPosition:onBotLane(unit) end,
		["OUTJUNGLE"] = function(unit) return MapPosition:inOuterJungle(unit) end,
		["INJUNGLE"] = function(unit) return MapPosition:inInnerJungle(unit) end,
		["OUTRIVER"] = function(unit) return MapPosition:inOuterRiver(unit) end,
		["INRIVER"] = function(unit) return MapPosition:inInnerRiver(unit) end,
		["BLUEBASE"] = function(unit) return MapPosition:inLeftBase(unit) end,
		["PURPLEBASE"] = function(unit) return MapPosition:inRightBase(unit) end,
		["NONE"] = function() end 
	}
	
	function iHeroes:__init()
		self.Heroes = {}
		--self.EventName = "iHeroes" Multi-events
		for i=1, heroManager.iCount, 1 do 
			local player = heroManager:GetHero(i)
			if player then 
				table.insert(self.Heroes, {object = player, health = 0, mana = 0, location = nil, death = 0})
			end 
		end 
		EventManager.RegisterEvent("LocationChange")
		EventManager.RegisterEvent("HPChange")
		EventManager.RegisterEvent("ManaChange")
		EventManager.RegisterEvent("OnRecall")
		EventManager.RegisterEvent("OnDeath")
		AddTickCallback(function(obj) self:OnTick() end)
		AddProcessSpellCallback(function(obj, spell) self:OnProcessSpell(obj, spell) end)	
	end 

	function iHeroes:OnTick()
		for index, hero in pairs(self.Heroes) do 
			if hero then 
				local player = hero.object
				if player then 
					--> OnDeath
					if player.dead then
						if hero.death == 0 then 
							EventManager.FireEvent("OnDeath", {player, player.deathTimer})
						end
						hero.death = player.deathTimer
					else 
						hero.death = 0
					end 
					--> LocationChange
					local location = self.GetLocation(player)
					if location ~= hero.location then 
						EventManager.FireEvent("LocationChange", {player, location, hero.location})
						self.Heroes[index].location = location
					end 
					--> HPChange
					local health = player.health 
					if health ~= hero.health then 
						EventManager.FireEvent("HPChange", {player, health, hero.health})
						self.Heroes[index].health = health 
					end 
					--> ManaChange
					local mana = player.mana 
					if mana ~= hero.mana then 
						EventManager.FireEvent("HPChange", {player, mana, mana.health})
						self.Heroes[index].mana = mana
					end 
				end 
			end 
		end 
	end 

	function iHeroes:OnProcessSpell(unit, spell) 
		if unit and unit.valid and unit.team ~= myHero.team and (spell.name == "Recall" or spell.name == "RecallImproved" or spell.name == "OdinRecall") then
			for index, hero in pairs(self.Heroes) do 
				local player = hero.object
				if player.networkID == unit.networkID then 
					EventManager.FireEvent("OnRecall", {player})
					break 
				end 
			end 
		end 
	end 

	function iHeroes.GetLocation(unit)
		for i, location in pairs(Locations) do 
			if location(unit) then 
				return i 
			end 
		end 
	end 

-- }

