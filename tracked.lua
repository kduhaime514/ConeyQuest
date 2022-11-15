local _, core = ...;

local function UntrackQuests()
    local totalTracked = C_QuestLog.GetNumQuestWatches();

    if (totalTracked > 0)
    then
        for trackerIndex=totalTracked, 1, -1
        do
            local trackedQuestId = C_QuestLog.GetQuestIDForQuestWatchIndex(trackerIndex);
            C_QuestLog.RemoveQuestWatch(trackedQuestId);
        end
    end
end

local function UntrackWorldQuests()
    local totalTracked = C_QuestLog.GetNumWorldQuestWatches();

    if (totalTracked > 0)
    then
        for trackerIndex=totalTracked, 1, -1
        do
            local trackedQuestId = C_QuestLog.GetQuestIDForWorldQuestWatchIndex(trackerIndex);
            C_QuestLog.RemoveWorldQuestWatch(trackedQuestId);
        end
    end
end

local function UntrackAllButton_onClick() 
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    core:UntrackAll();
end

local function UntrackAllButton_questWatchListChanged(...)
    if (core.trackerButton:IsShown() and C_QuestLog.GetNumQuestWatches() == 0) then
        core.trackerButton:Hide();
    elseif (not core.trackerButton:IsShown() and C_QuestLog.GetNumQuestWatches() > 0) then
        core.trackerButton:Show();
    end
end

function core:CreateButton()
    core.trackerButton = CreateFrame("Button", "Coney_ObjectivesButton", ObjectiveTrackerFrame, "UIPanelButtonTemplate");
    core.trackerButton:SetSize(20, 20);
    core.trackerButton:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -40, 0);
    core.trackerButton:SetText("X");
    core.trackerButton:SetNormalFontObject("GameFontNormalSmall");
    core.trackerButton:SetHighlightFontObject("GameFontHighlightSmall");

    core.trackerButton:RegisterEvent("QUEST_WATCH_LIST_CHANGED");
    core.trackerButton:SetScript("OnEvent", UntrackAllButton_questWatchListChanged);

    core.trackerButton:SetScript("OnClick", UntrackAllButton_onClick);
end

function core:Test()
    core:Print("Widening the quest frame maybe?");
    QuestScrollFrame:SetWidth(500);
end

function core:UntrackAll()
    UntrackQuests();
    UntrackWorldQuests();
end

function core:PrintTrackedQuests()
    local totalTracked = C_QuestLog.GetNumQuestWatches();

    if (totalTracked > 0)
    then
        for trackerIndex=1, totalTracked, 1
        do
            local trackedQuestId = C_QuestLog.GetQuestIDForQuestWatchIndex(trackerIndex);
            DEFAULT_CHAT_FRAME:AddMessage("Tracked quest id " .. trackerIndex .. ": " .. trackedQuestId .. " " .. QuestUtils_GetQuestName(trackedQuestId));
        end
    end
end