autodonate = autodonate or {}

if not file.Exists("autodonate/weaponplugin.txt","DATA")then
	file.Write("autodonate/weaponplugin.txt","[]")
end
function autodonate.addweapon(player,weapon)
	local ad=util.JSONToTable(file.Read("autodonate/weaponplugin.txt","DATA")or{})
    if not ad[player:SteamID()]then
        ad[player:SteamID()]={}
    end
	ad[player:SteamID()][weapon]=true
	file.Write("autodonate/weaponplugin.txt",util.TableToJSON(ad))
end
hook.Add("PlayerLoadout","autodonateplugin_weapon",function(ply)
    local weapons=util.JSONToTable(file.Read("autodonate/weaponplugin.txt","DATA"))
    if weapons[ply:SteamID()]then
        timer.Simple(1,function()
            for _,v in pairs(weapons[ply:SteamID()])do
                ply:Give(_)
            end
        end)
    end
end)
