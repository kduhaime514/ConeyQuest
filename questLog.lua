local _, core = ...;

core.quest = {};
local quest = core.quest;
local BulkAbandonFrame;
local questCheckPool = {};

local function GetOrAddQuestCheck(questId)
	for k, questCheck in pairs(questCheckPool) do
		if (questCheck.questId == questId) then
			return questCheck;
		end
	end

	local questCheck = {} 
	local questTitle = C_QuestLog.GetTitleForQuestID(questId);
	questCheck.questId = questId;
	questCheck.questTitle = questTitle;
	questCheck.checkButton = CreateFrame("CheckButton", "QuestCheck-" .. questId, BulkAbandonFrame.ScrollFrame, "UICheckButtonTemplate");
	table.insert(questCheckPool, questCheck);

	return questCheck;
end

local function getAbandonableQuests()
    local numQuestLogEntries = C_QuestLog.GetNumQuestLogEntries();
    local abandonableQuestChecks = {};

    for index=1, numQuestLogEntries do
        local questId = C_QuestLog.GetQuestIDForLogIndex(index);
        if (questId ~= 0) then
			-- TODO - test this
			if (C_QuestLog.IsOnQuest(questId) and C_QuestLog.CanAbandonQuest(questId) and not C_QuestLog.IsQuestTask(questId)) then
				local questCheck = GetOrAddQuestCheck(questId);
				table.insert(abandonableQuestChecks, questCheck);
			end
        end
    end

    return abandonableQuestChecks;
end

function quest:Toggle()
	local menu = BulkAbandonFrame or quest:CreateMenu();

	if menu:IsShown() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	menu:RegisterEvent("QUEST_LOG_UPDATE");
	menu:SetScript("OnEvent", quest.updateCheckQuestFrames);

	menu:SetShown(not menu:IsShown());
end

function quest:printQuests()
    core:Print(core:tprint(getAbandonableQuests()));
end

function quest:abandonQuest(questCheck)
    C_QuestLog.SetSelectedQuest(questCheck.questId);
    C_QuestLog.SetAbandonQuest(questCheck.questId);
    C_QuestLog.AbandonQuest();

	questCheck.checkButton:SetChecked(false);
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:VerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

function quest:updateCheckQuestFrames() 
	local quests = getAbandonableQuests();

	-- Hide all the frames first
	for k, questCheckFromPool in pairs(questCheckPool) do
		questCheckFromPool.checkButton:Hide();
	end

    BulkAbandonFrame.checkButtons = {};
    local anchor = BulkAbandonFrame.ScrollFrame:GetScrollChild();
    for k, questCheck in pairs(quests) do
		-- questCheck.checkButton = CreateFrame("CheckButton", "QuestCheck-" .. v.questId, BulkAbandonFrame.ScrollFrame, "UICheckButtonTemplate");

		-- first anchor needs to be a little different to anchor it to the scrollframe child
		if (k == 1) then
			questCheck.checkButton:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -5);
		else
			questCheck.checkButton:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -2);
		end

		questCheck.checkButton.text:SetText(questCheck.questTitle);
		questCheck.checkButton:Show();

		table.insert(BulkAbandonFrame.checkButtons, questCheck);

		anchor = questCheck.checkButton;
    end
end

local function AbandonSelectedButton_onClick()
	for k, v in pairs(BulkAbandonFrame.checkButtons) do
        local questCheck = v;
		if (questCheck.checkButton:GetChecked()) then
			core:Print("Abandoning " .. questCheck.questTitle);
			quest:abandonQuest(questCheck);
		end
	end

	PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST);
end

function quest:CreateMenu()
	BulkAbandonFrame = CreateFrame("Frame", "ConeyQuestAbandon", QuestMapFrame, "UIPanelDialogTemplate");
	BulkAbandonFrame:SetSize(300, 400);
	BulkAbandonFrame:SetPoint("TOPLEFT", QuestMapFrame, "TOPRIGHT", 0, 25);
	BulkAbandonFrame:SetPoint("BOTTOMLEFT", QuestMapFrame, "BOTTOMRIGHT", 0, 0);
	
	-- Title text
	BulkAbandonFrame.Title:ClearAllPoints();
	BulkAbandonFrame.Title:SetFontObject("GameFontHighlight");
	BulkAbandonFrame.Title:SetPoint("LEFT", ConeyQuestAbandonTitleBG, "LEFT", 6, 1);
	BulkAbandonFrame.Title:SetText("Coney Quest - Bulk Abandon");	

	-- Button Frame
	BulkAbandonFrame.ButtonFrame = CreateFrame("Frame", nil, BulkAbandonFrame);
	BulkAbandonFrame.ButtonFrame:SetPoint("TOPLEFT", ConeyQuestAbandonTitleBG, "BOTTOMLEFT", 0, 0);
	BulkAbandonFrame.ButtonFrame:SetPoint("BOTTOMRIGHT", ConeyQuestAbandonTitleBG, "BOTTOMRIGHT", 0, -50);

	BulkAbandonFrame.AbandonSelectedButton = CreateFrame("Button", nil, BulkAbandonFrame.ButtonFrame, "UIPanelButtonTemplate");
	BulkAbandonFrame.AbandonSelectedButton:SetPoint("TOPLEFT", BulkAbandonFrame.ButtonFrame, "TOPLEFT", 10, -10);
	BulkAbandonFrame.AbandonSelectedButton:SetPoint("BOTTOMRIGHT", BulkAbandonFrame.ButtonFrame, "BOTTOMRIGHT", -10, 10	);
    BulkAbandonFrame.AbandonSelectedButton:SetText("Abandon Selected");
    BulkAbandonFrame.AbandonSelectedButton:SetNormalFontObject("GameFontNormalSmall");
    BulkAbandonFrame.AbandonSelectedButton:SetHighlightFontObject("GameFontHighlightSmall");
	BulkAbandonFrame.AbandonSelectedButton:SetScript("OnClick", AbandonSelectedButton_onClick);

	-- Scroll frame
	BulkAbandonFrame.ScrollFrame = CreateFrame("ScrollFrame", nil, BulkAbandonFrame, "UIPanelScrollFrameTemplate");
	BulkAbandonFrame.ScrollFrame:SetPoint("TOPLEFT", BulkAbandonFrame.ButtonFrame, "BOTTOMLEFT", 0, 0);
	BulkAbandonFrame.ScrollFrame:SetPoint("BOTTOMRIGHT", ConeyQuestAbandonDialogBG, "BOTTOMRIGHT", -3, 4);
	BulkAbandonFrame.ScrollFrame:SetClipsChildren(true);
	BulkAbandonFrame.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
	
	-- Scroll bar
	BulkAbandonFrame.ScrollFrame.ScrollBar:ClearAllPoints();
	BulkAbandonFrame.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", BulkAbandonFrame.ScrollFrame, "TOPRIGHT", -12, -18);
	BulkAbandonFrame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", BulkAbandonFrame.ScrollFrame, "BOTTOMRIGHT", -7, 18);

	-- Scroll child
	local child = CreateFrame("Frame", nil, BulkAbandonFrame.ScrollFrame);
	child:SetSize(308, 1000);
	BulkAbandonFrame.ScrollFrame:SetScrollChild(child);	

	-- Checkboxes per quest
    quest:updateCheckQuestFrames();
	
	BulkAbandonFrame:Hide();
	return BulkAbandonFrame;
end

local function ExpanderButton_onClick()
	quest:Toggle();
end

function quest:AddMapFrameButton() 
	ExpanderButton = CreateFrame("Button", "ConeyQuestAbandonExpander", WorldMapFrame.BorderFrame, "UIPanelButtonTemplate");
	ExpanderButton:SetFrameLevel(512);
	ExpanderButton:SetPoint("RIGHT", WorldMapFrame.BorderFrame.MaximizeMinimizeFrame, "LEFT", -1, 0);
	ExpanderButton:SetSize(24, 24);
	ExpanderButton:SetText("CQ");
	ExpanderButton:SetScript("OnClick", ExpanderButton_onClick)
end