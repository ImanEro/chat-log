local function fetch(player, limit, type, id, playerName)
    local typeQuery,idQuery,playerQuery,limitQuery = "","","",""

    if limit then limitQuery = " LIMIT " .. limit end
    if type and type ~= "all" then typeQuery = "type = '" .. type .. "' AND " end
    if id then idQuery = "id = " .. tostring(id) .. " AND " end
    if playerName then playerQuery = "player = '" .. playerName .. "' AND " end
    
    local qh = dbQuery(db, "SELECT * FROM chats WHERE ".. typeQuery .. idQuery .. playerQuery .. " TRUE UNION SELECT * FROM commands WHERE " .. idQuery .. playerQuery .." TRUE " .. limitQuery .. ";")
    local res = dbPoll(qh, -1)
    triggerClientEvent(player, "updateChatLog", player, res)
end
addEvent("fetchChatLog", true)
addEventHandler("fetchChatLog", root, fetch)