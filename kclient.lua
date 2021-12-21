-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --       CONEXÃO PROXY & TUNNEL          -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
kinG = Tunnel.getInterface("king_desmanche")

-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --              VARIÁVEIS                -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------
local veh = nil

local trabalhoIniciado = false
local pegouFerramentas = false
local desmanchando = false
local pegou_peca = false
local pegou_item = false

local index = 0
local modelHash = 0
local quantidade_de_pecas_do_veiculo = 0
local quantidade_pecas_removidas = 0

local coordenadasPartes_Veiculo = {}
local PecasRemovidas = {}

local itemNaMao = ''
local placa = ''
local nomeCarro = ''
local modeloCarro = ''


-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --               FUNÇÕES                 -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------

------------------------
-- Iniciar Desmanche --
------------------------
Citizen.CreateThread(function()
    while true do
        local king = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        
        if not trabalhoIniciado then 
            for k,v in pairs(Config.coordenadas_locais_desmanche) do 
                if Vdist(x, y, z, v.x, v.y, v.z) <= 10 then
                    king = 1
                    index = k 
                    iniciarDesmanche(index) 
                end
            end
        end

        Citizen.Wait(king)
    end
end)

function iniciarDesmanche(index)

    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))

    if IsPedInAnyVehicle(ped, true) then
        DrawMarker(27,Config.coordenadas_locais_desmanche[index].x,Config.coordenadas_locais_desmanche[index].y,Config.coordenadas_locais_desmanche[index].z-0.96,0,0,0,0,0,0,4.1,4.1,0.5,255,255,255,100,0,0,0,1)
        
        if Vdist(x, y, z, Config.coordenadas_locais_desmanche[index].x, Config.coordenadas_locais_desmanche[index].y,Config.coordenadas_locais_desmanche[index].z) <= 2 then 
            drawText(Config.desmancharText) 
            
            if IsControlJustPressed(0, 38) then 

                veh = GetVehiclePedIsIn(ped, false)
                placa = GetVehicleNumberPlateText(veh)
                nomeCarro = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                modeloCarro = GetLabelText(nomeCarro)
                modelHash = GetEntityModel(veh)

                if kinG.checkPermission(Config.permissao) then 
                    if GetPedInVehicleSeat(veh, -1) == ped then 
                        if kinG.checkVeh(modelHash) then 
                            FreezeEntityPosition(veh, true) 
                            TriggerEvent(Config.notifyEvent, 'importante', Config.notifyMsgs['comecar_desmanche'])
                            trabalhoIniciado = true 
                        else
                            TriggerEvent(Config.notifyEvent, 'negado', Config.notifyMsgs['carro_invalido'])
                        end
                    else
                        TriggerEvent(Config.notifyEvent, 'negado', Config.notifyMsgs['assento_invalido'])
                    end
                else
                    TriggerEvent(Config.notifyEvent, 'negado', Config.notifyMsgs['sem_permissao'])
                end
            end
        end
    end
end

------------------------
-- Pegar Ferramentas --
------------------------
Citizen.CreateThread(function()
    while true do
        local king = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        if trabalhoIniciado and not pegouFerramentas then
            king = 1

            for k,v in pairs(Config.coordenadas_locais_ferramentas) do
                if Vdist(x, y, z, v.x, v.y, v.z) <= 10 then 
                    
                    
                    DrawMarker(27,Config.coordenadas_locais_ferramentas[k].x,Config.coordenadas_locais_ferramentas[k].y,Config.coordenadas_locais_ferramentas[k].z-0.9,0,0,0,0.0,0,0,0.9,0.9,0.8,255,0,0,70,0,1,0,1)
                    DrawMarker(2,Config.coordenadas_locais_ferramentas[k].x,Config.coordenadas_locais_ferramentas[k].y,Config.coordenadas_locais_ferramentas[k].z-0.4,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,70,1,1,0,0)
                    DrawText3D(Config.coordenadas_locais_ferramentas[k].x,Config.coordenadas_locais_ferramentas[k].y,Config.coordenadas_locais_ferramentas[k].z+0.12, "~b~[E] ~w~Pegar Ferramentas", 1.3, 1)
                    
                    if Vdist(x, y, z, Config.coordenadas_locais_ferramentas[k].x,Config.coordenadas_locais_ferramentas[k].y,Config.coordenadas_locais_ferramentas[k].z) <= 1 then 
                        if IsControlJustPressed(0, 38) then
        
                            TriggerEvent(Config.notifyEvent, 'importante', Config.notifyMsgs['pegando_ferramentas'])
                            FreezeEntityPosition(ped, true) 
                            SetEntityHeading(ped, Config.coordenadas_locais_ferramentas[k].h) 
                            vRP.playAnim(false, {{"amb@medic@standing@kneel@idle_a", "idle_a"}}, true) 
                            TriggerEvent(Config.progressEvent, 5000, 'PEGANDO FERRAMENTAS')
        
                            Wait(Config.tempo_coletar_ferramentas)
        
                            pegouFerramentas = true
                            TriggerEvent(Config.notifyEvent, 'sucesso', Config.notifyMsgs['pegou_ferramentas']) 
                            FreezeEntityPosition(ped, false) 
                            ClearPedTasks(ped) 
                        end
                    end
                end
            end
        end

        Citizen.Wait(king)
    end
end)

------------------------
-- Desmanchar Veiculo --
------------------------
Citizen.CreateThread(function()
    while true do
        local king = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        if trabalhoIniciado and pegouFerramentas and not desmanchando then 
            king = 1

            local classe = GetVehicleClass(veh)

            if classe ~= 8 then 
                
                local pD = GetEntityBoneIndexByName(veh,"handle_dside_f")
                coordenadasPartes_Veiculo['Porta_Direita'] = GetWorldPositionOfEntityBone(veh, pD)
                local pE = GetEntityBoneIndexByName(veh,"handle_pside_f")
                coordenadasPartes_Veiculo['Porta_Esquerda'] = GetWorldPositionOfEntityBone(veh, pE )
                coordenadasPartes_Veiculo['Roda_EsquerdaFrente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lf"))
                coordenadasPartes_Veiculo['Roda_DireitaFrente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_rf"))
                coordenadasPartes_Veiculo['Roda_EsquerdaTras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lr"))
                coordenadasPartes_Veiculo['Roda_DireitaTras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_rr"))
                if pD == -1 and pE == -1 then
                    quantidade_de_pecas_do_veiculo = 4
                else
                    quantidade_de_pecas_do_veiculo = 6
                end
            else 
                coordenadasPartes_Veiculo['Roda_Frente'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lf"))
                coordenadasPartes_Veiculo['Roda_Tras'] = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh,"wheel_lr"))
                quantidade_de_pecas_do_veiculo = 2
            end

            for k,v in pairs(coordenadasPartes_Veiculo) do
                local xVeh, yVeh, zVeh = table.unpack(v)
                local dist = Vdist(x, y, z, xVeh, yVeh, zVeh)

                if not PecasRemovidas[k] and not pegou_peca then
                    if dist <= 8 then
                        DrawMarker(21, xVeh,yVeh,zVeh+1, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, Config.rgbRemoverPecas1, Config.rgbRemoverPecas2, Config.rgbRemoverPecas3, 150, 0, 0, 0, 1)

                        if dist <= 2.5 then
                            drawText(Config.removerPecasText)

                            if dist < 1.1 then
                                if IsControlJustPressed(0, 38) then

                                    if k == 'Capo' or k == 'pMalas' then
                                        vRP.playAnim(false, {{"mini@repair" , "fixing_a_player"}}, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(ped)

                                    elseif k == 'Porta_Direita' or k == 'Porta_Esquerda' then

                                        vRP._playAnim(false,{task='WORLD_HUMAN_WELDING'},true)

                                        Citizen.Wait(Config.tempo_remover_pecas)
                                        ClearPedTasks(ped)

                                        vRP._CarregarObjeto("anim@heists@box_carry@","idle",Config.props['portas'],50,28422)

                                        pegou_item = kinG.entregaItem(Config.itens['portaDeCarro'])

                                        itemNaMao = Config.itens['portaDeCarro']
                                        pegou_peca = true

                                        if k == 'Porta_Direita' then
                                            SetVehicleDoorBroken(veh, 0, true)
                                        elseif k == 'Porta_Esquerda' then
                                            SetVehicleDoorBroken(veh, 1, true)
                                        end
                                    
                                    elseif k == 'Roda_DireitaFrente' or k == 'Roda_EsquerdaFrente' or k == 'Roda_DireitaTras' or k == 'Roda_EsquerdaTras' or k == 'Roda_Frente' or k == 'Roda_Tras' then

                                        vRP.playAnim(false, {{"amb@medic@standing@tendtodead@idle_a" , "idle_a"}}, true)

                                        Citizen.Wait(Config.tempo_remover_pecas)
                                        ClearPedTasks(ped)

                                        vRP._CarregarObjeto("anim@heists@box_carry@","idle",Config.props['rodas'],50,28422)

                                        if k == 'Roda_Frente' or k == 'Roda_Tras' then
                                            pegou_item = kinG.entregaItem(Config.itens['rodaDeMoto'])
                                            itemNaMao = Config.itens['rodaDeMoto']
                                        else
                                            pegou_item = kinG.entregaItem(Config.itens['rodaDeCarro'])
                                            itemNaMao = Config.itens['rodaDeCarro']
                                        end

                                        pegou_peca = true

                                        if classe ~= 8 then
                                            if k == 'Roda_EsquerdaFrente' then
                                                SetVehicleTyreBurst(veh, 0, true, 1000)
                                            elseif k == 'Roda_DireitaFrente' then
                                                SetVehicleTyreBurst(veh, 1, true, 1000)
                                            elseif k == 'Roda_EsquerdaTras' then
                                                SetVehicleTyreBurst(veh, 4, true, 1000)
                                            elseif k == 'Roda_DireitaTras' then
                                                SetVehicleTyreBurst(veh, 5, true, 1000)
                                            end
                                        else
                                            if k == 'Roda_Frente' then
                                                SetVehicleTyreBurst(veh, 0, true, 1000)
                                            elseif k == 'Roda_Tras' then
                                                SetVehicleTyreBurst(veh, 4, true, 1000)
                                            end
                                        end

                                    else
                                        vRP.playAnim(false, {{"amb@medic@standing@tendtodead@idle_a" , "idle_a"}}, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(ped)
                                    end

                                    if k == 'Capo' then
                                        SetVehicleDoorBroken(veh, 4, true)
                                    end
                                    Wait(5000)
                                    PecasRemovidas[k] = true
                                    quantidade_pecas_removidas = quantidade_pecas_removidas + 1
                                    if quantidade_pecas_removidas == quantidade_de_pecas_do_veiculo and not pegou_peca then
                                        TriggerEvent(Config.notifyEvent, 'importante', Config.notifyMsgs['desmanchou_veiculo'])
                                        desmanchando = true
                                        coordenadasPartes_Veiculo = {}
                                        PecasRemovidas = {}
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(king)
    end
end)

-------------------
-- Guardar Peças --
-------------------
Citizen.CreateThread(function ()
    while true do
        local king = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        if pegou_peca and not desmanchando then
            king = 1

            for k,v in pairs(Config.coordenadas_locais_guardarPecas) do
                local dist = Vdist(x, y, z, v.x, v.y, v.z)

                if dist <= 20 then
                    DrawMarker(21,v.x,v.y,v.z-0.25,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,100,1,1,0,0)
                    DrawMarker(27,v.x,v.y,v.z-0.9,0,0,0,0.0,0,0,0.7,0.7,0.4,255, 0, 0,150,0,1,0,1)
                    DrawText3D(v.x,v.y,v.z+0.12, "~b~[E] ~w~Guardar Peças", 1.3, 1)

                    if dist <= 1 then
                        if IsControlJustPressed(0, 38) then

                            if itemNaMao ~= 'portacarro' then
                                RequestAnimDict("anim@heists@money_grab@briefcase")
                                while not HasAnimDictLoaded("anim@heists@money_grab@briefcase") do
                                    Citizen.Wait(0) 
                                end
                                TaskPlayAnim(ped,"anim@heists@money_grab@briefcase","put_down_case",100.0,200.0,0.3,120,0.2,0,0,0)
                                Wait(800)
                            end

                            vRP._DeletarObjeto()

                            ClearPedTasks(ped)
                            pegou_peca = false
                            if pegou_item then
                                kinG.removeItem(itemNaMao)
                                pegou_peca = false
                            end

                        end
                    end
                end
            end
        end
        Citizen.Wait(king)
    end
end)

-------------------
-- Vender  Peças --
-------------------
Citizen.CreateThread(function()
    while true do
        local king = 1000
        local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))

        if trabalhoIniciado and not pegou_peca and quantidade_pecas_removidas == quantidade_de_pecas_do_veiculo and index ~= 0 and desmanchando then
            king = 1

            xVenda = Config.coordenadas_locais_venda[index].x
            yVenda = Config.coordenadas_locais_venda[index].y
            zVenda = Config.coordenadas_locais_venda[index].z

            local dist = Vdist(x, y, z, xVenda, yVenda, zVenda)

            if dist <= 10 then
                DrawMarker(21,xVenda,yVenda,zVenda-0.25,0,0,0,0.0,0,0,0.4,0.4,0.4,255,255,255,100,1,1,0,0)
                DrawMarker(27,xVenda,yVenda,zVenda-0.9,0,0,0,0.0,0,0,0.7,0.7,0.4,255, 0, 0,150,0,1,0,1)

                if dist <= 1 then
                    if IsControlJustPressed(0, 38) then
                        vRP.playAnim(false, {{"anim@heists@prison_heistig1_p1_guard_checks_bus", "loop"}}, true)

                        TriggerEvent('progress', 5000, 'Anunciando Peças')
                        Wait(5000)

                        ClearPedTasks(ped)

                        TriggerEvent(Config.notifyEvent,'sucesso',Config.notifyMsgs['trabalho_concluido'])

                        kinG.GerarPagamento(placa, modelHash)

                        local classe = GetVehicleClass(veh)
                        
                        DeleteVehicle(veh)

                        Wait(8000)
                
                        desmanchando = false
                        reseta()
                    end
                end
            end
        end

        Citizen.Wait(king)
    end
end)

------------------------
-- Cancelar Desmanche --
------------------------
Citizen.CreateThread(function()
    while true do
        local king = 1000

        if trabalhoIniciado then
            king = 1

            if IsControlJustPressed(0, 168) then
                if veh then
                    FreezeEntityPosition(veh,false)
                end
                desmanchando = false
                reseta()
                TriggerEvent(Config.notifyEvent,'importante',Config.notifyMsgs['cancelar_trabalho'])
            end
        end

        Citizen.Wait(king)
    end
end)

-------------------------------------------------------------------------------------
-- CREDITS 𝐾𝑖𝑛𝑔#8563 --           FUNÇÕES ADICIONAIS          -- CREDITS 𝐾𝑖𝑛𝑔#8563 --
-------------------------------------------------------------------------------------

function drawText(texto)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextColour(128, 128, 128, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(0, 0, 0, 1, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(texto)
    DrawText(0.36, 0.90)
end

function DrawText3D(x,y,z, text, scl, font) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

	local scale = (1/dist)*scl
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov
	if onScreen then
		SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end

function reseta()

    veh = nil

    trabalhoIniciado = false
    pegouFerramentas = false
    pegou_peca = false
    pegou_item = false

    quantidade_de_pecas_do_veiculo = 0
    quantidade_pecas_removidas = 0
    modelHash = 0


    PecasRemovidas = {}

    itemNaMao = ''
    placa = ''
    nomeCarro = ''
    modeloCarro = ''

end
