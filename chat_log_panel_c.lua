local screenWidth, screenHieght = guiGetScreenSize()
local mainWIndowWidth,mainWindowHieght = 960,600
local paddingWidth, paddingHeight = 20,40
local mainWindow, logList
local limit = 100
local show = true


function updateChatLogList(res) 
    local oldRow = guiGridListGetRowCount(logList)
    if oldRow > 0 then
        destroyElement(logList)
        logList = guiCreateGridList(paddingWidth, paddingHeight, (mainWIndowWidth * 0.7) - paddingWidth, mainWindowHieght - (paddingHeight * 2) , false, mainWindow)
        guiGridListAddColumn(logList, "id", 0.05)
        guiGridListAddColumn(logList, "type", 0.05)
        guiGridListAddColumn(logList, "time", 0.1)
        guiGridListAddColumn(logList, "player", 0.1)
        guiGridListAddColumn(logList, "group", 0.1)
        guiGridListAddColumn(logList, "message", 0.2)
        guiGridListAddColumn(logList, "zone", 0.1)
        guiGridListAddColumn(logList, "position", 0.1)
    end
    for i=1,#res do 
        guiGridListAddRow(logList, res[i].id, res[i].type, res[i].time, res[i].player, res[i].group, res[i].message, res[i].zone, res[i].position)
    end
end
addEvent("updateChatLog", true)
addEventHandler("updateChatLog", localPlayer, updateChatLogList)

function openPanel() 
    mainWindow = guiCreateWindow((screenWidth - mainWIndowWidth) / 2, (screenHieght - mainWindowHieght) / 2, mainWIndowWidth, mainWindowHieght, "Chat Log", false)
    logList = guiCreateGridList(paddingWidth, paddingHeight, (mainWIndowWidth * 0.7) - paddingWidth, mainWindowHieght - (paddingHeight * 2) , false, mainWindow)
    --* TEMP
    local refreshButton = guiCreateButton(700, 40, 230, 55, "Refresh", false, mainWindow)

    -- Customization
    guiWindowSetMovable(mainWindow, false)
    guiWindowSetSizable(mainWindow, false)
    showCursor(true)
    guiGridListAddColumn(logList, "id", 0.05)
    guiGridListAddColumn(logList, "type", 0.05)
    guiGridListAddColumn(logList, "time", 0.1)
    guiGridListAddColumn(logList, "player", 0.1)
    guiGridListAddColumn(logList, "group", 0.1)
    guiGridListAddColumn(logList, "message", 0.2)
    guiGridListAddColumn(logList, "zone", 0.1)
    guiGridListAddColumn(logList, "position", 0.1)

    -- Events
    triggerServerEvent("fetchChatLog", resourceRoot, localPlayer, limit)
    addEventHandler("onClientGUIClick", refreshButton, function() triggerServerEvent("fetchChatLog", resourceRoot, localPlayer, limit)  end, false)
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