local _, core = ...;

core.tracked = {};
local tracked = core.tracked;

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
    tracked:UntrackAll();
end

local function UntrackAllButton_questWatchListChanged(...)
    if (tracked.trackerButton:IsShown() and C_QuestLog.GetNumQuestWatches() == 0) then
        tracked.trackerButton:Hide();
    elseif (not tracked.trackerButton:IsShown() and C_QuestLog.GetNumQuestWatches() > 0) then
        tracked.trackerButton:Show();
    end
end

function tracked:CreateButton()
    tracked.trackerButton = CreateFrame("Button", "Coney_ObjectivesButton", ObjectiveTrackerFrame, "UIPanelButtonTemplate");
    tracked.trackerButton:SetSize(20, 20);
    tracked.trackerButton:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -40, 0);
    tracked.trackerButton:SetText("X");
    tracked.trackerButton:SetNormalFontObject("GameFontNormalSmall");
    tracked.trackerButton:SetHighlightFontObject("GameFontHighlightSmall");

    tracked.trackerButton:RegisterEvent("QUEST_WATCH_LIST_CHANGED");
    tracked.trackerButton:SetScript("OnEvent", UntrackAllButton_questWatchListChanged);

    tracked.trackerButton:SetScript("OnClick", UntrackAllButton_onClick);
end

function tracked:UntrackAll()
    UntrackQuests();
    UntrackWorldQuests();
end

function tracked:PrintTrackedQuests()
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