for i=0,24 do
	local size = 10+i
	surface.CreateFont("autodonatefont_"..size, {
	font = "Roboto",
	size = size,
	})
end
http.Fetch("https://i.imgur.com/sGvf4cP.png",function(a)file.Write("autodonatematerial1.png",a)end)
local mnv={}
local function menudonate()
	surface.SetFont("autodonatefont_18")
	local menu=vgui.Create("DFrame")
	menu:SetSize(700,400)
	menu:Center()
	menu:SetTitle("")
	menu:MakePopup()
	menu:SetSizable(true)
	menu:ShowCloseButton(false)
	menu.Paint=function(q,r,s)
		draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
		draw.RoundedBoxEx(6,180,30,r-180,s-30,Color(36,37,45),false,false,false,true)
		draw.SimpleText("exec autodonate v0.1","autodonatefont_24",5,2.5,Color(255,255,255))
	end
	local closebutton=vgui.Create("DButton",menu)
	closebutton:SetText("")
	closebutton:SetSize(17,17)
	closebutton:SetPos(675,7)
	closebutton.Paint=function(q,r,s)
		if closebutton.Hovered then 
			surface.SetDrawColor(255,255,255)
		else
			surface.SetDrawColor(200,200,200)
		end 
		surface.SetMaterial(Material("data/autodonatematerial1.png"))
		surface.DrawTexturedRect(0,0,r,s)
	end 
	closebutton.DoClick=function()
		menu:Close()
	end
	local tabpos = 35
	local function addtab(name,func)
		local tabbutton=vgui.Create("DButton",menu)
		tabbutton:SetFont("autodonatefont_22")
		tabbutton:SetText(name)
		tabbutton:SetTextColor(Color(255,255,255))
		tabbutton:SetSize(166,30)
		tabbutton:SetPos(7,tabpos)
		tabbutton.Paint=function(q,r,s)
		draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
			if tabbutton.Hovered then 
				draw.RoundedBox(6,0,0,r,s,Color(76,99,136))
			elseif mnv["t"]==name then
				draw.RoundedBox(6,0,0,r,s,Color(66,99,126))
			end 
		end 
		tabbutton.DoClick=function()
			mnv["t"]=name
			if IsValid(mnv.select)then mnv.select:Remove()end
			mnv.select=vgui.Create("DScrollPanel",menu)
			mnv.select:SetPos(180,400)
			mnv.select:MoveTo(180,30,.1,0,-1)
			mnv.select:SetSize(700-180,400-30)
			mnv.select.Paint=function(q,r,s)end
			func()
		end
		tabpos=tabpos+37
	end
	for _,v in pairs(autodonate["categories"])do
		addtab(v,function()
			local right=7
			local up=7
			for f,z in pairs(autodonate["donate"][_])do
				local itembutton=vgui.Create("DButton",mnv.select)
				itembutton:SetText("")
				itembutton:SetSize(249.5,37)
				itembutton:SetPos(right,up)
				surface.SetFont("autodonatefont_16")
				local wg,gf=surface.GetTextSize(z["price"]..autodonate["currency"])
				itembutton.Paint=function(q,r,s)
					draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
					if itembutton.Hovered then 
						draw.RoundedBox(6,0,0,r,s,Color(76,99,136))
					end 
					draw.SimpleText(f,"autodonatefont_18",5,2.5,Color(255,255,255))
					draw.SimpleText(z["desc"],"autodonatefont_14",5,20,Color(255,255,255))
					draw.SimpleText(z["price"]..autodonate["currency"],"autodonatefont_16",243-wg,2,Color(255,255,255))
				end
				itembutton.DoClick=function()
					local description = z["fulldesc"]
					surface.SetFont("autodonatefont_18")
					local one, two = surface.GetTextSize(description)
					local buymenu=vgui.Create("DFrame")
					buymenu:SetSize(350,two+100)
					buymenu:Center()
					buymenu:SetTitle("")
					buymenu:MakePopup()
					buymenu:SetSizable(true)
					buymenu:ShowCloseButton(false)
					buymenu.Paint=function(q,r,s)
						draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
						draw.RoundedBox(6,0,30,r,s,Color(36,37,45))
						draw.SimpleText(autodonate["translate_buy"],"autodonatefont_24",5,2.5,Color(255,255,255))
						draw.SimpleText(f,"autodonatefont_24",5,33,Color(255,255,255))
					end
					local closebutton=vgui.Create("DButton",buymenu)
					closebutton:SetText("")
					closebutton:SetSize(17,17)
					closebutton:SetPos(325,7)
					closebutton.Paint=function(q,r,s)
						if closebutton.Hovered then 
							surface.SetDrawColor(255,255,255)
						else
							surface.SetDrawColor(200,200,200)
						end 
						surface.SetMaterial(Material("data/autodonatematerial1.png"))
						surface.DrawTexturedRect(0,0,r,s)
					end 
					closebutton.DoClick=function()
						buymenu:Close()
					end
					local desc=vgui.Create("DButton",buymenu)
					desc:SetSize(one,two)
					desc:SetPos(5,60)
					desc:SetFont("autodonatefont_18")
					desc:SetText(description)
					desc:SetTextColor(Color(255,255,255))
					desc.Paint=function()end
					local buybutton = autodonate["translate_buy"].." ("..z["price"]..autodonate["currency"]..")"
					surface.SetFont("autodonatefont_22")
					local qone, qtwo = surface.GetTextSize(buybutton)
					local buybt=vgui.Create("DButton",buymenu)
					buybt:SetFont("autodonatefont_22")
					buybt:SetText(buybutton)
					buybt:SetTextColor(Color(255,255,255))
					buybt:SetSize(qone+10,30)
					buybt:SetPos(5,two+63)
					buybt.Paint=function(q,r,s)
						draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
						if buybt.Hovered then
							draw.RoundedBox(6,0,0,r,s,Color(76,99,136))
						end
					end 
					buybt.DoClick=function()
						buymenu:Close()
						net.Start("autodonate")
						net.WriteString("buy")
						net.WriteFloat(_)
						net.WriteString(f)
						net.SendToServer()
					end
				end
				if right == 266-3 then
					up=up+37+7
					right=7
				else
					right=right+259-3
				end
			end
		end)
	end
	addtab("History",function()
		net.Start("autodonate")
		net.WriteString("myhistory")
		net.SendToServer()
		timer.Simple(0.1,function() if not mnv.balance then return end
			local pla=7
			for _,v in pairs(mnv.myhistorys["data"] or{})do
				if v["buyed"]then if mnv["t"]~="History"then return end
					local logf = string.format(autodonate["translate_history_purchase"],_,v["buyed"],v["moneys"]..autodonate["currency"],v["totalmoneys"]..autodonate["currency"])
					local log=vgui.Create("DButton",mnv.select)
					log:SetText("")
					log:SetSize(505,25)
					log:SetPos(5,pla)
					log:SetToolTip(logf)
					log.Paint=function(q,r,s)
						draw.SimpleText(logf,"autodonatefont_20",5,2.5,Color(255,255,255))
					end
					pla=pla+27
				end
			end
			for _,v in pairs(mnv.myhistorys["data"] or{})do
				if v["services"]then if mnv["t"]~="History"then return end
					local logf = string.format(autodonate["translate_history_buy"],_,v["moneys"]..autodonate["currency"],v["services"],v["totalmoneys"]..autodonate["currency"])
					local log=vgui.Create("DButton",mnv.select)
					log:SetText("")
					log:SetSize(505,25)
					log:SetPos(5,pla)
					log:SetToolTip(logf)
					log.Paint=function(q,r,s)
						draw.SimpleText(logf,"autodonatefont_20",5,2.5,Color(255,255,255))
					end
					pla=pla+27
				end
			end
		end)
	end)
	addtab(autodonate["translate_balance"],function()
		net.Start("autodonate")
		net.WriteString("myhistory")
		net.SendToServer()
		mnv.select.Paint=function(q,r,s)
			draw.SimpleText(autodonate["translate_addbalance"],"autodonatefont_20",5,30,Color(255,255,255))
			if not mnv.balance then return end
			draw.SimpleText(autodonate["translate_balance"]..": "..mnv.balance..autodonate["currency"],"autodonatefont_24",5,2.5,Color(255,255,255))
		end
		if autodonate["qiwi_enabled"]then
			local qiwiaddbalance=vgui.Create("DButton",mnv.select)
			qiwiaddbalance:SetFont("autodonatefont_22")
			qiwiaddbalance:SetText("Qiwi")
			qiwiaddbalance:SetTextColor(Color(255,255,255))
			qiwiaddbalance:SetSize(50,30)
			qiwiaddbalance:SetPos(5,55)
			qiwiaddbalance.Paint=function(q,r,s)
				draw.RoundedBox(6,0,0,r,s,Color(28,29,34))
				if qiwiaddbalance.Hovered then
					draw.RoundedBox(6,0,0,r,s,Color(76,99,136))
				end
			end 
			qiwiaddbalance.DoClick=function()
				if game.GetIPAddress()~="loopback"then
					gui.OpenURL("https://qiwi.com/payment/form/99?extra%5B%27account%27%5D="..autodonate["qiwi_number"].."&amountFraction=0&extra%5B%27comment%27%5D="..game.GetIPAddress().."|"..LocalPlayer():SteamID())
				end
			end
		end
	end)
end
net.Receive("autodonate",function()
	local sl=net.ReadString()
	if sl=="menuopen"then
		menudonate()
		mnv["t"]=nil
	elseif sl=="myhistory"then
		mnv.myhistorys=net.ReadTable()
		mnv.balance=net.ReadFloat()
	end
end)
