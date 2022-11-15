local _, core = ...;


function core:printQuests()
    local numQuestLogEntries = C_QuestLog.GetNumQuestLogEntries();

    for index=1, numQuestLogEntries do
        local questId = C_QuestLog.GetQuestIDForLogIndex(index);

        if (questId ~= 0) then
            core:Print(questId);
            local questTitle = C_QuestLog.GetTitleForQuestID(questId);
            core:Print(questTitle);
        end
    end
end

function core:abandonQuest(questId)
    C_QuestLog.SetSelectedQuest(questId);
    C_QuestLog.AbandonQuest();
end

function core:test() 
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