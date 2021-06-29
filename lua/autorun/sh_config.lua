autodonate = autodonate or {}

autodonate["currency"]="rub"

autodonate["qiwi_enabled"]=true
autodonate["qiwi_number"]="70000000000"--qiwi number phone

autodonate["translate_addbalance"]="Add balance:"
autodonate["translate_balance"]="Balance"
autodonate["translate_buy"]="Buy"
autodonate["translate_not_enough_money"]="[autodonate] Low money, top up your balance!"
autodonate["translate_you_buy"]="[autodonate] You buy %s for %s"
autodonate["translate_history_purchase"]="%s - Purchase %s for %s:%s"
autodonate["translate_history_buy"]="%s - Replenishment '%s' by %s:%s"

--autodonate_addmoney STEAM_0:0:204076914 1000
concommand.Add("autodonate_addmoney",function(a,b,b,c)if a:IsPlayer()then return end;local d=string.Explode(" ",c)autodonate.addbalance(d[1],d[2],"CONSOLE",os.date("%d %b %Y %H:%M:%S"))end)

autodonate["categories"]={"Ranks","Money","Boosting","Weapons"}
autodonate["donate"]={
	[1]={--Ranks 1
		["Moderator"]={
			desc="moderator",
			fulldesc="please\nbuy moderator",
			price=300,
			func=function(player)player:SetUserGroup("moderator")end
		},
		["Admin"]={
			desc="admin",
			fulldesc="",
			price=500,
			func=function(player)player:SetUserGroup("admin")end
		},
		["SuperAdmin"]={
			desc="superadmin",
			fulldesc="",
			price=1000,
			func=function(player)player:SetUserGroup("superadmin")end
		}
	},
	[2]={--Money 2
		["100,000$"]={
			desc="100,000$ money",
			fulldesc="darkrp",
			price=100,
			func=function(player)player:addMoney(100000)end
		},
		["500,000$"]={
			desc="500,000$ money",
			fulldesc="darkrp",
			price=150,
			func=function(player)player:addMoney(500000)end
		},
		["1,000,000$"]={
			desc="1,000,000$ money",
			fulldesc="darkrp",
			price=200,
			func=function(player)player:addMoney(1000000)end
		}
	},
	[3]={--Boosting 3
		["+25 health"]={
			desc="+25 health on spawn",
			fulldesc="",
			price=100,
			func=function(player)autodonate.addhealth(player,25)end
		},
		["+10 armor"]={
			desc="+10 armor on spawn",
			fulldesc="",
			price=50,
			func=function(player)autodonate.addarmor(player,10)end
		}
	},
	[4]={--Weapons 4
		["Ak-47"]={
			desc="Ak-47",
			fulldesc="",
			price=150,
			func=function(player)autodonate.addweapon(player,"m9k_ak47")end
		},
		["Aug a3"]={
			desc="Aug a3",
			fulldesc="",
			price=130,
			func=function(player)autodonate.addweapon(player,"m9k_auga3")end
		}
	}
}
