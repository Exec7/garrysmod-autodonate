autodonate = autodonate or {}

if not file.Exists("autodonate/healthplugin.txt","DATA")then
    file.Write("autodonate/healthplugin.txt","[]")
end
function autodonate.addhealth(player,health)
    local ad=util.JSONToTable(file.Read("autodonate/healthplugin.txt","DATA")or{})
    local healthall=(ad[player:SteamID()])and ad[player:SteamID()]+health or health
    ad[player:SteamID()]=healthall
    file.Write("autodonate/healthplugin.txt",util.TableToJSON(ad))
end
hook.Add("PlayerLoadout","autodonateplugin_health",function(ply)
    local healthg=util.JSONToTable(file.Read("autodonate/healthplugin.txt","DATA"))
    if healthg[ply:SteamID()] then
        timer.Simple(1,function()
            local hp=ply:Health()
            ply:SetHealth(hp+healthg[ply:SteamID()])
        end)
    end
end)

if not file.Exists("autodonate/armorplugin.txt","DATA")then
    file.Write("autodonate/armorplugin.txt","[]")
end
function autodonate.addarmor(player,armor)
    local ad=util.JSONToTable(file.Read("autodonate/armorplugin.txt","DATA")or{})
    local armorall=(ad[player:SteamID()])and ad[player:SteamID()]+armor or armor
    ad[player:SteamID()]=armorall
    file.Write("autodonate/armorplugin.txt",util.TableToJSON(ad))
end
hook.Add("PlayerLoadout","autodonateplugin_armor",function(ply)
    local armorg=util.JSONToTable(file.Read("autodonate/armorplugin.txt","DATA"))
    if armorg[ply:SteamID()] then
        timer.Simple(1,function()
            local armor=ply:Armor()
            ply:SetArmor(armor+armorg[ply:SteamID()])
        end)
    end
end)
