autodonate = autodonate or {}

file.CreateDir("autodonate")
if not file.Exists("autodonate/base.txt","DATA")then
	file.Write("autodonate/base.txt","[]")
end
if autodonate["qiwi_enabled"] and not file.Exists("autodonate/qiwi_payments.txt","DATA")then
	file.Write("autodonate/qiwi_payments.txt","")
end

util.AddNetworkString("autodonate")

hook.Add("PlayerSay","autodonatechat",function(ply,text)
	if table.HasValue(autodonate["chatcommand"],string.lower(text))then
		net.Start("autodonate")
		net.WriteString("menuopen")
		net.Send(ply)
		return""
	end
end)

function autodonate.addbalance(steamid,money,service,data)
	local ad=util.JSONToTable(file.Read("autodonate/base.txt","DATA")or{})
	local moneyx=(ad[steamid])and ad[steamid]["moneys"]+money or money
	if not ad[steamid]then
		ad[steamid]={}
		ad[steamid]["history"]={}
		ad[steamid]["history"]["data"]={}
	end
	ad[steamid]["moneys"]=moneyx
	ad[steamid]["history"]["data"][data]={services=service,moneys=money,totalmoneys=moneyx}
	file.Write("autodonate/base.txt",util.TableToJSON(ad))
end

local function addbuy(player,name,price,func)
	local ad=util.JSONToTable(file.Read("autodonate/base.txt","DATA")or{})
	local moneyx=ad[player:SteamID()]["moneys"]
	if not ad[player:SteamID()]then
		ad[player:SteamID()]={}
		ad[player:SteamID()]["history"]={}
		ad[player:SteamID()]["history"]["data"]={}
	end
	ad[player:SteamID()]["moneys"]=moneyx-price
	ad[player:SteamID()]["history"]["data"][os.date("%d %b %Y %H:%M:%S")]={buyed=name,moneys=price,totalmoneys=moneyx}
	file.Write("autodonate/base.txt",util.TableToJSON(ad))
	func(player)
end

net.Receive("autodonate",function(len,ply)
	local sl=net.ReadString()
	if sl=="myhistory"then
		local ad=util.JSONToTable(file.Read("autodonate/base.txt","DATA"))
		if ad[ply:SteamID()]then
			net.Start("autodonate")
			net.WriteString("myhistory")
			net.WriteTable(ad[ply:SteamID()]["history"])
			net.WriteFloat(ad[ply:SteamID()]["moneys"])
			net.Send(ply)
		end
	elseif sl=="buy"then
		local index=net.ReadFloat()
		local buy=net.ReadString()
		local ad=util.JSONToTable(file.Read("autodonate/base.txt","DATA"))
		local dat=autodonate["donate"][index][buy]
		if ad[ply:SteamID()]and ad[ply:SteamID()]["moneys"]then
			if autodonate["donate"][index][buy] and ad[ply:SteamID()]["moneys"]>=autodonate["donate"][index][buy]["price"]then
				addbuy(ply,buy,dat["price"],dat["func"])
				ply:ChatPrint(string.format(autodonate["translate_you_buy"],buy,dat["price"]))
			else
				ply:ChatPrint(autodonate["translate_not_enough_money"])
			end
		end
	end
end)

timer.Create("autodonatecheck",5,0,function()
	if autodonate["qiwi_enabled"]then
		http.Fetch("https://edge.qiwi.com/payment-history/v2/persons/"..autodonate["qiwi_number"].."/payments?rows=10",function(data)
			local data=util.JSONToTable(data)["data"]
			for _,payments in ipairs(data)do
				local data=payments["date"]
				local number=payments["account"]
				local comment=payments["comment"]
				local money=payments["sum"]["amount"]
				local currency=payments["sum"]["currency"]
				local indificator=number..data:Replace("+",""):Replace("-","")
				if not string.find(file.Read("autodonate/qiwi_payments.txt","DATA"),indificator or"a")then
					if autodonate["qiwi_currency"]==currency then
						if comment then
							local serverip=string.Explode("|",comment)[1]
							local steamid=string.Explode("|",comment)[2]
							if serverip==game.GetIPAddress()then
								autodonate.addbalance(steamid,money,"QIWI",data)
							end
						end
					end
					file.Append("autodonate/qiwi_payments.txt",indificator.."\n")
				end
			end
		end,function()end,{Authorization="Bearer "..autodonate["qiwi_token"]})
	end
end)
