local _, core = ...;

core.quest = {};
local quest = core.quest;
local BulkAbandonFrame;

local function getAbandonableQuests()
    local numQuestLogEntries = C_QuestLog.GetNumQuestLogEntries();
    local questTitles = {};

    for index=1, numQuestLogEntries do
        local questId = C_QuestLog.GetQuestIDForLogIndex(index);
        if (questId ~= 0) then
			if (C_QuestLog.CanAbandonQuest(questId) and not C_QuestLog.IsQuestTask(questId)) then
				local questTitle = C_QuestLog.GetTitleForQuestID(questId);

				local questIdAndTitle = {};
				questIdAndTitle.questId = questId;
				questIdAndTitle.questTitle = questTitle;

				table.insert(questTitles, questIdAndTitle);
			end
        end
    end

    return questTitles;
end

function quest:Toggle()
	local menu = BulkAbandonFrame or quest:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

function quest:printQuests()
    core:Print(core:tprint(getAbandonableQuests()));
end

function quest:abandonQuest(questId)
    C_QuestLog.SetSelectedQuest(questId);
    C_QuestLog.AbandonQuest();
end

function quest:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
	local btn = CreateFrame("Button", nil, BulkAbandonFrame.ScrollFrame, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
	btn:SetSize(140, 40);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	return btn;
end

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end

function quest:CreateMenu()
	BulkAbandonFrame = CreateFrame("Frame", "ConeyQuestAbandon", QuestMapFrame, "UIPanelDialogTemplate");
	BulkAbandonFrame:SetSize(350, 400);
	BulkAbandonFrame:SetPoint("TOPLEFT", QuestMapFrame, "TOPRIGHT", 0, 25);
	BulkAbandonFrame:SetPoint("BOTTOMLEFT", QuestMapFrame, "BOTTOMRIGHT", 0, 0);
	
	-- Title text
	BulkAbandonFrame.Title:ClearAllPoints();
	BulkAbandonFrame.Title:SetFontObject("GameFontHighlight");
	BulkAbandonFrame.Title:SetPoint("LEFT", ConeyQuestAbandonTitleBG, "LEFT", 6, 1);
	BulkAbandonFrame.Title:SetText("Coney Quest Bulk Abandon");	

	-- Button Frame
	BulkAbandonFrame.ButtonFrame = CreateFrame("Frame", nil, BulkAbandonFrame);
	BulkAbandonFrame.ButtonFrame:SetPoint("TOPLEFT", ConeyQuestAbandonTitleBG, "BOTTOMLEFT", 0, 0);
	BulkAbandonFrame.ButtonFrame:SetPoint("BOTTOMRIGHT", ConeyQuestAbandonTitleBG, "BOTTOMRIGHT", 0, -50);

	BulkAbandonFrame.AbandonSelectedButton = CreateFrame("Button", nil, BulkAbandonFrame.ButtonFrame, "UIPanelButtonTemplate");
	BulkAbandonFrame.AbandonSelectedButton:SetPoint("TOPLEFT", BulkAbandonFrame.ButtonFrame, "TOPLEFT", 10, -10);
	BulkAbandonFrame.AbandonSelectedButton:SetPoint("BOTTOMRIGHT", BulkAbandonFrame.ButtonFrame, "BOTTOMRIGHT", -10, 10);

	-- BulkAbandonFrame.AbandonSelectedButton:SetPoint("BOTTOMRIGHT", BulkAbandonFrame.ButtonFrame, "TOPLEFT", 100, 60);
    BulkAbandonFrame.AbandonSelectedButton:SetText("Abandon Selected");
    BulkAbandonFrame.AbandonSelectedButton:SetNormalFontObject("GameFontNormalSmall");
    BulkAbandonFrame.AbandonSelectedButton:SetHighlightFontObject("GameFontHighlightSmall");

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
    local quests = getAbandonableQuests();
    BulkAbandonFrame.checkButtons = {};
    local anchor = child;
    for k, v in pairs(quests) do
        local questCheck = v;
        
        questCheck.checkButton = CreateFrame("CheckButton", nil, BulkAbandonFrame.ScrollFrame, "UICheckButtonTemplate");
        questCheck.checkButton:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -25);
        questCheck.checkButton.text:SetText(v.questTitle);
        table.insert(BulkAbandonFrame.checkButtons, questCheck);

        anchor = questCheck.checkButton;
    end
	
	BulkAbandonFrame:Hide();
	return BulkAbandonFrame;
end


function quest:test() 
    local currentQuestFrameWidth = QuestMapFrame:GetWidth();
    QuestMapFrame:SetWidth(currentQuestFrameWidth + 50);

    -- TODO - seems like the children of this dynamically adjust as well...
    -- it isn't as simple as widening the right side of the frame to make more room for the quest log
    local currentBorderFrameWidth = WorldMapFrame:GetWidth();
    WorldMapFrame:SetWidth(currentBorderFrameWidth + 50);

    -- TODO - probably dynamically set all these ints. Test on different monitors
    -- QuestMapFrame:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", 50, -25);
    -- QuestMapFrame:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", 50, 3);
end
-- see QuestLogQuests_Update for reference if you end up building on the UI