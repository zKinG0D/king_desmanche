-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --       CONEXÃO PROXY & TUNNEL          -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

kinG = {}
Tunnel.bindInterface("king_desmanche",kinG)

-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --               FUNÇÕES                 -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------

function kinG.checkVeh(vehicles)
    for k,v in pairs(vehConfig.listaVeiculos) do
        if v.hash == vehicles then
        else
        end
    end
    return true
end

function kinG.checkPermission(permission)
    local source = source
    local user_id = vRP.getUserId(source)
    
    return vRP.hasPermission(user_id, permission)
end

function kinG.entregaItem(item)
    if vRP.getUserId(source) and vRP.getInventoryWeight((vRP.getUserId(source))) + vRP.getItemWeight(item) <= vRP.getInventoryMaxWeight((vRP.getUserId(source))) then
      vRP.giveInventoryItem(vRP.getUserId(source), item, 1)
      return true
    end
end

function kinG.removeItem(item)
    if vRP.getUserId(source) then
      vRP.tryGetInventoryItem(vRP.getUserId(source), item, 1)
    end
end

function kinG.GerarPagamento(a, b)
  for fm, fo in pairs(vehConfig.listaVeiculos) do
    if fo.hash == b then
      print(fo.name)
      vRP.giveInventoryItem(vRP.getUserId(source), "dinheirosujo", fo.valor)
    else
    end
  end
  TriggerClientEvent("vrp_sound:source", source, "coins", 0,3)
end
