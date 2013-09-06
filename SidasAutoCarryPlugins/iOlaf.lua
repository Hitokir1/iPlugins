require "iFoundation_v2"

class 'Plugin' -- {
	
	if myHero.charName ~= "Olaf" then return end 
	local SkillQ = Caster(_Q, 1000, SPELL_LINEAR, 1650, 0.234, 100, true)
	local SkillW = Caster(_W, 225, SPELL_SELF)
	local SkillE = Caster(_E, 250, SPELL_TARGETED)
	local SkillR = Caster(_R, 300, SPELL_SELF)
	local combo = ComboLibrary()

	local axe = nil 

	local Menu = nil
	
	function Plugin:__init() 
	end 

	function Plugin:OnTick() 
		Target = AutoCarry.Crosshair:GetTarget()

		if axe and not axe.valid then 
			axe = nil 
		end 

		if Target and AutoCarry.Keys.AutoCarry then
			if Menu.AxeHelp and axe and axe.valid then 
				myHero:MoveTo(axe.x, axe.z) 
			end

			combo:CastCombo(Target)   
		end
	end 

	function Plugin:OnLoad() 
		AutoCarry.Crosshair.SkillRange = 1000
		combo:AddCasters({SkillQ, SkillW, SkillE, SkillR})
		combo:AddCustomCast(_R, function(Target) 
			return myHero.isTaunted or myHero.isCharmed or myHero.isFeared or myHero.isFleeing
			end)
	end 

	function Plugin:OnCreateObj(obj) 
		if obj and GetDistance(obj) < 1500 and not obj.name:find("Odin") then
			 if obj.name:find("olaf_axe_totem") then
			 	axe = obj
			 end 
		end 
	end 

	function Plugin:OnDeleteObj(obj) 
		if obj and GetDistance(obj) < 1500 and not obj.name:find("Odin") then
			 if obj.name:find("olaf_axe_totem") then 
			 	axe = nil
			 end 
		end 
	end 

	function Plugin:OnDraw() 
		if axe and axe.valid then 
			--DrawArrows(myHero, axe, 30, _ColorARGB.Green:ToARGB(), 50)
			DrawCircle(axe.x, axe.y, axe.z, 150, _ColorARGB.Green:ToARGB())
		end 
	end 

	Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Olaf") 
	Menu:addParam("AxeHelp", "Walk-To Axe", SCRIPT_PARAM_ONOFF, false)
-- }