local _, core = ...;

core.quest = {};
local quest = core.quest;
local UIConfig;

local function getQuestTitles()
    local numQuestLogEntries = C_QuestLog.GetNumQuestLogEntries();
    local questTitles = {};

    for index=1, numQuestLogEntries do
        local questId = C_QuestLog.GetQuestIDForLogIndex(index);
        if (questId ~= 0) then
            local questTitle = C_QuestLog.GetTitleForQuestID(questId);

            local questIdAndTitle = {};
            questIdAndTitle.questId = questId;
            questIdAndTitle.questTitle = questTitle;
            table.insert(questTitles, questIdAndTitle);
        end
    end

    return questTitles;
end

function quest:Toggle()
	local menu = UIConfig or quest:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

function quest:printQuests()
    core:Print(core:tprint(getQuestTitles()));
end

function quest:abandonQuest(questId)
    C_QuestLog.SetSelectedQuest(questId);
    C_QuestLog.AbandonQuest();
end

function quest:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
	local btn = CreateFrame("Button", nil, UIConfig.ScrollFrame, "GameMenuButtonTemplate");
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
	UIConfig = CreateFrame("Frame", "ConeyQuestAbandon", QuestMapFrame, "UIPanelDialogTemplate");
	UIConfig:SetSize(350, 400);
	UIConfig:SetPoint("TOPLEFT", QuestMapFrame, "TOPRIGHT", 0, 25);
	UIConfig:SetPoint("BOTTOMLEFT", QuestMapFrame, "BOTTOMRIGHT", 0, 0);
	
	UIConfig.Title:ClearAllPoints();
	UIConfig.Title:SetFontObject("GameFontHighlight");
	UIConfig.Title:SetPoint("LEFT", ConeyQuestAbandonTitleBG, "LEFT", 6, 1);
	UIConfig.Title:SetText("Coney Quest Bulk Abandon");	
	
	UIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, UIConfig, "UIPanelScrollFrameTemplate");
	UIConfig.ScrollFrame:SetPoint("TOPLEFT", ConeyQuestAbandonDialogBG, "TOPLEFT", 4, -8);
	UIConfig.ScrollFrame:SetPoint("BOTTOMRIGHT", ConeyQuestAbandonDialogBG, "BOTTOMRIGHT", -3, 4);
	UIConfig.ScrollFrame:SetClipsChildren(true);
	UIConfig.ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
	
	UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
	UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -12, -18);
	UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18);

	local child = CreateFrame("Frame", nil, UIConfig.ScrollFrame);
	child:SetSize(308, 1000);
	UIConfig.ScrollFrame:SetScrollChild(child);	

    local quests = getQuestTitles();
    

    UIConfig.checkButtons = {};
    local anchor = child;
    for k, v in pairs(quests) do
        local questCheck = v;
        
        questCheck.checkButton = CreateFrame("CheckButton", nil, UIConfig.ScrollFrame, "UICheckButtonTemplate");

        questCheck.checkButton:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -25);

        questCheck.checkButton.text:SetText(v.questTitle);
        
        table.insert(UIConfig.checkButtons, questCheck);

        anchor = questCheck.checkButton;
    end

    -- core:Print(core:tprint(UIConfig.checkButtons));

    -- UIConfig.checkBtn1 = CreateFrame("CheckButton", nil, UIConfig.ScrollFrame, "UICheckButtonTemplate");
	-- UIConfig.checkBtn1:SetPoint("TOPLEFT", UIConfig.slider1, "BOTTOMLEFT", -10, -40);
	-- UIConfig.checkBtn1.text:SetText("My Check Button!");

	
	-- ----------------------------------
	-- -- Buttons
	-- ----------------------------------
	-- -- Save Button:
	-- UIConfig.saveBtn = self:CreateButton("CENTER", child, "TOP", -70, "Save");

	-- -- Reset Button:	
	-- UIConfig.resetBtn = self:CreateButton("TOP", UIConfig.saveBtn, "BOTTOM", -10, "Reset");

	-- -- Load Button:	
	-- UIConfig.loadBtn = self:CreateButton("TOP", UIConfig.resetBtn, "BOTTOM", -10, "Load");

	-- ----------------------------------
	-- -- Sliders
	-- ----------------------------------
	-- -- Slider 1:
	-- UIConfig.slider1 = CreateFrame("SLIDER", nil, UIConfig.ScrollFrame, "OptionsSliderTemplate");
	-- UIConfig.slider1:SetPoint("TOP", UIConfig.loadBtn, "BOTTOM", 0, -20);
	-- UIConfig.slider1:SetMinMaxValues(1, 100);
	-- UIConfig.slider1:SetValue(50);
	-- UIConfig.slider1:SetValueStep(30);
	-- UIConfig.slider1:SetObeyStepOnDrag(true);

	-- -- Slider 2:
	-- UIConfig.slider2 = CreateFrame("SLIDER", nil, UIConfig.ScrollFrame, "OptionsSliderTemplate");
	-- UIConfig.slider2:SetPoint("TOP", UIConfig.slider1, "BOTTOM", 0, -20);
	-- UIConfig.slider2:SetMinMaxValues(1, 100);
	-- UIConfig.slider2:SetValue(40);
	-- UIConfig.slider2:SetValueStep(30);
	-- UIConfig.slider2:SetObeyStepOnDrag(true);

	-- ----------------------------------
	-- -- Check Buttons
	-- ----------------------------------
	-- -- Check Button 1:
	-- UIConfig.checkBtn1 = CreateFrame("CheckButton", nil, UIConfig.ScrollFrame, "UICheckButtonTemplate");
	-- UIConfig.checkBtn1:SetPoint("TOPLEFT", UIConfig.slider1, "BOTTOMLEFT", -10, -40);
	-- UIConfig.checkBtn1.text:SetText("My Check Button!");

	-- -- Check Button 2:
	-- UIConfig.checkBtn2 = CreateFrame("CheckButton", nil, UIConfig.ScrollFrame, "UICheckButtonTemplate");
	-- UIConfig.checkBtn2:SetPoint("TOPLEFT", UIConfig.checkBtn1, "BOTTOMLEFT", 0, -10);
	-- UIConfig.checkBtn2.text:SetText("Another Check Button!");
	-- UIConfig.checkBtn2:SetChecked(true);

    -- enable dragging the frame...
	-- UIConfig:EnableMouse(true)
	-- UIConfig:SetMovable(true)
	-- UIConfig:SetClampedToScreen(true)
	-- UIConfig:RegisterForDrag("LeftButton")
	-- UIConfig:SetScript("OnDragStart", function(self)
	-- 	self:SetUserPlaced(true)
	-- 	self:StartMoving()
	--   end)
	-- UIConfig:SetScript("OnDragStop", function(self)
	-- 	self:StopMovingOrSizing()
	--   end)
	
	UIConfig:Hide();
	return UIConfig;
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