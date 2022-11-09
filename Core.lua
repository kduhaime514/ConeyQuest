local _, core = ...;

------------------ BUTTON --------------------------

local trackerButton = CreateFrame("Button", "Coney_ObjectivesButton", ObjectiveTrackerFrame, "UIPanelButtonTemplate");
trackerButton:SetSize(20, 20);
trackerButton:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -40, 0);
trackerButton:SetText("UT");
trackerButton:SetNormalFontObject("GameFontNormalSmall");
trackerButton:SetHighlightFontObject("GameFontHighlightSmall");

------------------ FUNCTIONALITY -------------------

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

--[[
    5 layers, from furthest back to furthest forward are:
        - BACKGROUND
        - BORDER
        - ARTWORK
        - OVERLAY
        - HIGHLIGHT

]]

