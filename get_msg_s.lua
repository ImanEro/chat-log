local function fetch(player, limit)
    local qh = dbQuery(db, "SELECT * FROM chats UNION SELECT * FROM commands limit ?;", limit)
    local res = dbPoll(qh, -1)
    triggerClientEvent(player, "updateChatLog", player, res)
end
addEvent("fetchChatLog", true)
addEventHandler("fetchChatLog", root, fetch)