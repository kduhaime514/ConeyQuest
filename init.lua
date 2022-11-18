local _, core = ...

--------------------------------------
-- Custom Slash Command
--------------------------------------
core.commands = {
	["config"] = core.quest.Toggle, -- this is a function (no knowledge of Config object)
	
	["help"] = function()
		print(" ");
		core:Print("List of slash commands:")
		core:Print("|cff00cc66/cq config|r - shows config menu");
		core:Print("|cff00cc66/cq help|r - shows help info");
        core:Print("|cff00cc66/cq untrack|r - untracks all quests")
		print(" ");
	end,
    ["untrack"] = core.tracked.UntrackAll,
    ["print"] = core.tracked.PrintTrackedQuests,
	["test"] = core.quest.printQuests,
	["test2"] = core.quest.test2,
	["example"] = {
		["test"] = function(...)
			core:Print("My Value:", tostringall(...));
		end
	}
};

local function HandleSlashCommands(str)	
	if (#str == 0) then	
		-- User just entered "/at" with no additional args.
		core.commands.help();
		return;		
	end	
	
	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local path = core.commands; -- required for updating found table.
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- if string length is greater than 0.
			arg = arg:lower();			
			if (path[arg]) then
				if (type(path[arg]) == "function") then				
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;					
				elseif (type(path[arg]) == "table") then				
					path = path[arg]; -- another sub-table found!
				end
			else
				-- does not exist!
				core.commands.help();
				return;
			end
		end
	end
end

function core:tprint(tbl, indent) 

	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2 
	for k, v in pairs(tbl) do
		toprint = toprint .. string.rep(" ", indent)
		if (type(k) == "number") then
		toprint = toprint .. "[" .. k .. "] = "
		elseif (type(k) == "string") then
		toprint = toprint  .. k ..  "= "   
		end
		if (type(v) == "number") then
		toprint = toprint .. v .. ",\r\n"
		elseif (type(v) == "string") then
		toprint = toprint .. "\"" .. v .. "\",\r\n"
		elseif (type(v) == "table") then
		toprint = toprint .. core:tprint(v, indent + 2) .. ",\r\n"
		else
		toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
		end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"

	return toprint;
end
	  


function core:Print(...)
    local hex = select(4, core.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Coney Quest:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

-- WARNING: self automatically becomes events frame!
function core:init(event, name)
	if (name ~= "ConeyQuest") then return end 

	-- allows using left and right buttons to move through chat 'edit' box
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
	end

	SLASH_ConeyQuest1 = "/cq";
	SlashCmdList.ConeyQuest = HandleSlashCommands;

    core.tracked:CreateButton();
    core:Print("Welcome back", UnitName("player").."!");
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);