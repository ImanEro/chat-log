db = nil

function dbStructure() 
    dbExec(db, [[CREATE TABLE IF NOT EXISTS chats (
        "id"	INTEGER NOT NULL UNIQUE,
        "type"	INTEGER,
        "time"	TEXT NOT NULL,
        "player"	TEXT NOT NULL,
        "group"	TEXT NOT NULL,
        "message"	TEXT,
        "zone"	TEXT,
        "position"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
    );]])
    dbExec(db, [[CREATE TABLE IF NOT EXISTS commands (
        "id"	INTEGER NOT NULL UNIQUE,
        "type"	INTEGER,
        "time"	TEXT NOT NULL,
        "player"	TEXT NOT NULL,
        "group"	TEXT NOT NULL,
        "message"	TEXT,
        "zone"	TEXT,
        "position"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
    );]])
end

function getPlayerAcls(player)
    local acls = {}
    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return "Guest"
    end

    local accountName = getAccountName(account)
    for _, group in ipairs(aclGroupList()) do
        if isObjectInACLGroup("user." .. accountName, group) then
            local groupName = aclGroupGetName(group)
            table.insert(acls, 1, groupName)
        end
    end
    return acls[1]
end

-- Initialize the resource on start
function startChatSystem()
    db = dbConnect("sqlite", "messages.db")
    dbStructure()
end
addEventHandler("onResourceStart", root, startChatSystem)