local screenWidth, screenHieght = guiGetScreenSize()
local mainWIndowWidth,mainWindowHieght = 960,600
local paddingWidth, paddingHeight = 20,40
local mainWindow, logList
local limit = 50
local show = true

function updateChatLogList(res)
    destroyElement(logList)
    logList = guiCreateGridList(paddingWidth, paddingHeight, (mainWIndowWidth * 0.7) - paddingWidth, mainWindowHieght - (paddingHeight * 2) , false, mainWindow)
    guiGridListAddColumn(logList, "id", 0.05)
    guiGridListAddColumn(logList, "type", 0.05)
    guiGridListAddColumn(logList, "time", 0.1)
    guiGridListAddColumn(logList, "player", 0.1)
    guiGridListAddColumn(logList, "group", 0.1)
    guiGridListAddColumn(logList, "message", 0.3)
    guiGridListAddColumn(logList, "zone", 0.1)
    guiGridListAddColumn(logList, "position", 0.15)

    for i=1,#res do 
        guiGridListAddRow(logList, res[i].id, res[i].type, res[i].time, res[i].player, res[i].group, res[i].message, res[i].zone, res[i].position)
    end
end
addEvent("updateChatLog", true)
addEventHandler("updateChatLog", localPlayer, updateChatLogList)

function openPanel() 
    mainWindow = guiCreateWindow((screenWidth - mainWIndowWidth) / 2, (screenHieght - mainWindowHieght) / 2, mainWIndowWidth, mainWindowHieght, "Chat Log", false)
    logList = guiCreateGridList(paddingWidth, paddingHeight, (mainWIndowWidth * 0.7) - paddingWidth, mainWindowHieght - (paddingHeight * 2) , false, mainWindow)
    local players = getElementsByType("player")
    local authorLabel = guiCreateLabel(paddingWidth, mainWindowHieght - 30, mainWIndowWidth, 50, "© ImanEro", false, mainWindow)
    local searchButton = guiCreateButton(700, 480, 230, 35, "Search", false, mainWindow)
    local closeButton = guiCreateButton(700, 525, 230, 35, "Close", false, mainWindow)
    local titleLabel = guiCreateLabel(672, paddingHeight, 268, 30, "Log Filters", false, mainWindow)
    local rowsLabel = guiCreateLabel(700, 70, 230, 35, "Rows :", false, mainWindow)
    local rowsEdit = guiCreateEdit(740, 70, 45, 20, tostring(limit), false, mainWindow)
    local rowsInfoLabel = guiCreateLabel(790, 70, 230, 35, "Leave Empty for all the resaults", false, mainWindow)
    local idLabel = guiCreateLabel(700, 100, 230, 35, "Id :", false, mainWindow)
    local idEdit = guiCreateEdit(740, 100, 45, 20, "", false, mainWindow)
    local playerLabel = guiCreateLabel(700, 130, 230, 35, "Player :", false, mainWindow)
    local playerComboBox = guiCreateComboBox(750, 130, 100, 250, "", false, mainWindow)
    local groupLabel = guiCreateLabel(700, 160, 230, 35, "Group :", false, mainWindow)
    local groupComboBox = guiCreateComboBox(750, 160, 100, 250, "", false, mainWindow)
    
    -- Customization
    guiWindowSetMovable(mainWindow, false)
    guiWindowSetSizable(mainWindow, false)
    showCursor(true)
    guiEditSetMaxLength(rowsEdit, 3)
    guiEditSetMaxLength(idEdit, 3)
    guiLabelSetHorizontalAlign(titleLabel, "center")
    guiLabelSetColor(rowsInfoLabel, 100, 100, 100)
    for _,player in pairs(players) do
       guiComboBoxAddItem(playerComboBox, getPlayerName(player))
    end

    -- Events
    triggerServerEvent("fetchChatLog", resourceRoot, localPlayer, limit)
    addEventHandler("onClientGUIClick", searchButton, function()
        limit = tonumber(guiGetText(rowsEdit)) or nil
        local id = tonumber(guiGetText(idEdit)) or nil
        local playerName = guiComboBoxGetItemText(playerComboBox, guiComboBoxGetSelected(playerComboBox))
        if playerName == "" then playerName = nil end
        triggerServerEvent("fetchChatLog", resourceRoot, localPlayer, limit, id, playerName)  
    end, false)
    addEventHandler("onClientGUIClick", closeButton, function() closePanel()  end, false)
end

function closePanel()
    destroyElement(mainWindow)
    showCursor(false)
end

-- Opens chat log ui wiht command
addCommandHandler("clog", function()
    if show then 
        openPanel() 
        show = false
    else
        closePanel()
        show = true
    end
end, true, false)

--! Remove this before commit
openPanel()