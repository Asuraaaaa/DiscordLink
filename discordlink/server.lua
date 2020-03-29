dbEnable = true -- DO NOT CHANGE

RegisterServerEvent('checkIsLinked')
AddEventHandler('checkIsLinked', function()
    local source = source
    local player = GetPlayerName(source)
    local _id = GetDiscordID(source)

    if _id ~= false then
        print("[Discord Link] Discord Linked Successfully for " ..player)
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Discord Link] ^2Discord Account Linked Successfully!"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Discord Link] ^7Your Discord ID: ^3" .._id}
        })
    end
end)

RegisterCommand('discordlink', function(source, args, rawCommand)
	local license = FetchIdentifier("license", source)
	local sql1 = "SELECT * FROM `discordlink_identifiers` WHERE license=@license"
	MySQL.Async.fetchAll(sql1, {['license'] = license}, function(result) 
		if not result[1] then
			local sql2 = "SELECT * FROM `discordlink_linkcodes` WHERE license=@license"
			MySQL.Async.fetchAll(sql2, {['license'] = license}, function(result2) 
				if not result2[1] then
					local link_code = math.random(1000, 9000)
				    local sql3 = "INSERT INTO `discordlink_linkcodes` (license, link_code) VALUES (@license, @linkcode)"
				    MySQL.Async.execute(sql3, {['license'] = license, ['linkcode'] = link_code}, function()
				        TriggerClientEvent('chat:addMessage', source, {
				            args = { "^3[Discord Link] ^5Your Link Code is: ^3"..link_code.."^5 DM the Discord Link bot with the following command to link your account: ^3%link "..link_code }
				        })
				    end)
				else
					TriggerClientEvent('chat:addMessage', source, {
						args = { "^3[Discord Link] ^5You already have a link code that you havent used! It is: ^3 "..result2[1].link_code }
					})
				end
			end)  
		else
			TriggerClientEvent('chat:addMessage', source, {
				args = { "^3[Discord Link] ^5Your account is already linked to the Discord account with the following ID: ^3"..result[1].discord_id }
			})
		end
	end)
end)

RegisterServerEvent('discordlink:linkplayer')
AddEventHandler('discordlink:linkplayer', function(discordId, linkcode)
    local sql1 = "SELECT * FROM `discordlink_linkcodes` WHERE link_code = @linkcode"
    MySQL.Async.fetchAll(sql1, {['linkcode'] = linkcode}, function(result)
        if result[1] then
        	local sql2 = "SELECT * FROM `discordlink_identifiers` WHERE discord_id=@discord"
        	MySQL.Async.fetchAll(sql2, {['discord'] = discordId}, function(result2)
        		if not result2[1] then
        			InsertToIdentifiers(result[1].license, discordId)
		            print("Discord Account: "..discordId.." linked with FiveM account "..result[1].license.." successfully")
		            TriggerEvent('discordlink:success', discordId, result[1].license);	            
		            local sql3 = "DELETE FROM `discordlink_linkcodes` WHERE link_code=@linkcode"
		            MySQL.Async.execute(sql3, {['linkcode'] = linkcode}, function() end)
        		else
        			TriggerEvent("discordlink:failed", "It appears your Discord Account is already linked with another FiveM account with the license: "..result2[1].license)
        			MySQL.Async.execute(sql3, {['linkcode'] = linkcode}, function() end)
        		end
        	end)          
        else
        	TriggerEvent("discordlink:failed", "The link code you entered does not exist on the system! Please make sure you are entering the correct link code, and try again!")
        end
    end)
end)

---------- FUNCTIONS ----------

function CreateTables()
    local sql = "CREATE TABLE IF NOT EXISTS `discordlink_identifiers` (`license` varchar(255) PRIMARY KEY NOT NULL, `discord_id` varchar(255) NOT NULL); CREATE TABLE IF NOT EXISTS `discordlink_linkcodes` (`license` varchar(255) PRIMARY KEY NOT NULL, `link_code` INT NOT NULL)"
    MySQL.ready(function ()
        MySQL.Async.execute(sql, {}, function() end)       
    end)
end

if dbEnable then
    CreateTables()
end
    
function InsertToIdentifiers(license, discord)
    local sql1 = "SELECT license FROM `discordlink_identifiers` WHERE license=@license"
    MySQL.Async.fetchAll(sql1, {['license'] = license}, function(result)
        if not result[1] then
            local sql2 = "INSERT INTO `discordlink_identifiers` (`license`, `discord_id`) VALUES (@license, @discord)"
        	MySQL.Async.execute(sql2, {['license'] = license, ['discord'] = discord}, function()
            	print("[Discord Link] Inserted Identifiers for "..license.." into table 'discordlink_identifiers'")
        	end)
        end 
    end)         
end
   
function FetchIdentifier(type, source)
	local identifiers = GetPlayerIdentifiers(source)	    
    for key, value in ipairs(identifiers) do
        if string.match(value, type..":") then	
        	local identifier = string.gsub(value, type..":", "")
            return identifier
        end
    end
    return false    
end

function GetDiscordID(source)
    local license = FetchIdentifier("license", source)
    local discordID = nil;
    if license ~= nil then
        local sql = "SELECT discord_id FROM `discordlink_identifiers` WHERE license=@license"
        data = MySQL.Sync.fetchAll(sql, {['license'] = license})
        if not rawequal(next(data), nil) then
            discordID = data[1].discord_id
            return discordID;
        else
            return false
        end       
    end
end
    

