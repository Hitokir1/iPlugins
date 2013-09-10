require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "TwistedFate" then return end 

	local WDISTANCE = Combat.GetTrueRange()
	local Menu = nil

	local SkillQ = Caster(_Q, 1450, SPELL_CONE, 1450, 0.250, 90, true)
	local combo = ComboLibrary()

	local Cards = {
		["Blue"] = {
			troy = "Card_Blue.troy",
			lock = "bluecardlock",
		},
		["Yellow"] = {
			troy = "Card_Yellow.troy",
			lock = "goldcardlock"
		},
		["Red"] = {
			troy = "Card_Red.troy",
			lock = "redcardlock"
		},
		["None"] = {troy="", lock=""}
	}
	local currentCard = Cards["None"]
	local usedUltimate = false
	
	function Plugin:__init() 
		AutoCarry.Crosshair.SkillRange = 1500
		combo:AddCasters({SkillQ})
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()
		if usedUltimate and Menu.useYellow and Menu.autoLock then 
			PickCard(Cards["Yellow"])
		end 
		if Target and AutoCarry.Keys.AutoCarry then
			if GetDistance(Target) <= WDISTANCE then 
				if Monitor.CountEnemies(Target, 225) >= 3 and Menu.useRed then 
					PickCard(Cards["Red"]) 
				elseif Menu.useYellow then
					PickCard(Cards["Yellow"])
				end 
			end 
		elseif AutoCarry.Keys.LaneClear then 
			if (myHero.mana / myHero.maxMana) < (Menu.blueMana / 100) and Menu.useBlue then 
				PickCard(Cards["Blue"])
			elseif Menu.useRed then
				PickCard(Cards["Red"])
			end 
		elseif AutoCarry.Keys.LastHit and Menu.useBlue then 
			PickCard(Cards["Blue"])
		end 
	end 

	function Plugin:OnLoad() 
	end 

	function Plugin:OnProcessSpell(unit, spell)
		if unit.isMe and spell.name == "Destiny" then 
			usedUltimate = true
		end 
	end 

	function PickCard(card)
		if card then
			if myHero:GetSpellData(_W).name == "PickACard" then CastSpell(_W) end
			if myHero:GetSpellData(_W).name == card.lock then 
				CastSpellEx(_W) 
				if usedUltimate == true and not myHero:CanUseSpell(_W) == READY then 
					usedUltimate = false 
				end 
			end 
		end 
	end 

	--[[function Plugin:OnCreateObj(object)
		if object and GetDistance(object) <= 70 then
			for card, obj in pairs(Cards) do
				if object.name == obj.troy then 
					currentCard = card 
				end 
			end 
		end 
	end]]

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "TwistedFate") 
	Menu:addParam("desc1","-- Auto-Card Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("blueMana", "Mana percentage to use Blue Card",SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
	Menu:addParam("useBlue", "Use Blue Card", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useRed", "Use Red Card", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("useYellow", "Use Gold Card", SCRIPT_PARAM_ONOFF, true)
	Menu:addParam("desc1","-- Ultimate Options --", SCRIPT_PARAM_INFO, "")
	Menu:addParam("autoLock", "Auto-Lock Yellow after Ult", SCRIPT_PARAM_ONOFF, true)
	--Menu:addParam("Escape", "Escape to nearest turret with ultimate", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
-- }
