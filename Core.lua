------------------ BUTTON --------------------------

local trackerButton = CreateFrame("Button", "Coney_ObjectivesButton", ObjectiveTrackerFrame, "UIPanelButtonTemplate");
trackerButton:SetSize(20, 20);
trackerButton:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", -40, 0);
trackerButton:SetText("UT");
trackerButton:SetNormalFontObject("GameFontNormalSmall");
trackerButton:SetHighlightFontObject("GameFontHighlightSmall");

------------------ FUNCTIONALITY -------------------

function UntrackAll()
    UntrackQuests();
    UntrackWorldQuests();
end

function UntrackQuests()
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

function UntrackWorldQuests()
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

function DoSomething()
    DEFAULT_CHAT_FRAME:AddMessage("Doing something...");

    -- This works! So ObjectiveTrackerFrame is the UI we want to append a button to
    ObjectiveTrackerFrame:Show();
    -- ObjectiveTrackerFrame:Hide();
end

function PrintTrackedQuests()
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

------------------ SLASH COMMANDS ------------------
SLASH_UNTRACKALL1 = "/cut_untrack";
SlashCmdList["UNTRACKALL"] = UntrackAll;

SLASH_PRINTQUESTS1 = "/cut_print"; 
SlashCmdList["PRINTQUESTS"] = PrintTrackedQuests;

SLASH_DOSOMETHING1 = "/doit";
SlashCmdList["DOSOMETHING"] = DoSomething;


--[[
    5 layers, from furthest back to furthest forward are:
        - BACKGROUND
        - BORDER
        - ARTWORK
        - OVERLAY
        - HIGHLIGHT

]]

