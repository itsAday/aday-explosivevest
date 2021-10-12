-- HECHO POR ADAY
ESX = nil

-- COSAS MODIFICABLES PARA LA BOMBA --
numExplosiones = 10 -- Numero de explosiones que hace el chaleco
intervaloSegundos = 300  --En milisegundos (300 milisegundos recomendados) 1 segundo = 1000 milisegundos
tipoExplosion = 32 -- Tipo de explosion para el chaleco. 
tiempoExplotar = 60 -- Numero de segundos para el temporizador del jugador.


-- VALORES QUE NO SE TOCAN -----------
activado = false                    --
detonador = false                   --
haMuerto = false                    --
activated = true                    --
--------------------------------------

-- ESTO ES PARA PERSONALIZAR EL DRAWTXT QUE APARECE EN LA PANTALLA --
x = 0.800
y = 1.235
tamano = 1.50


-- Chaleco Hombre
ChalecoHombre = {
    bproof_1 = 16,  bproof_2 = 2
}

-- Chaleco Mujer
ChalecoMujer = {
    bproof_1 = 18,  bproof_2 = 2
}

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
end
end)

function drwChaleco(x,y ,width,height,scale, text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour( 0, 255, 68, 255 )
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

RegisterNetEvent('chalecobomba')
AddEventHandler('chalecobomba', function() 
    TriggerEvent('skinchanger:getSkin', function(skin)
        detonador = true
        activated = true
        local uniformeVivo
        if skin.sex == 0 then
            uniformeVivo = ChalecoHombre
        else
            uniformeVivo = ChalecoMujer
        end
        TriggerEvent('skinchanger:loadClothes', skin, uniformeVivo)
        local contador = tiempoExplotar
        while (contador ~= 0) do 
            if activated then
                Wait( 1000 ) 
                contador = contador - 1
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"INMOLACION | ", "Tiempo Para Explotar : " ..contador.. " segundos!"}
                })
            else
                TriggerEvent('chat:addMessage', {
                    color = { 255, 0, 0},
                    multiline = true,
                    args = {"INMOLACION | ", "BOOOM! Has explotado primo"}
                })
                break
            end
        end
        if haMuerto == false then 
            loop = false
            TriggerEvent('explotar', source)
        end
    end)
end)


RegisterNetEvent('explotar')
AddEventHandler('explotar', function()
    detonador = false
    TriggerEvent('skinchanger:getSkin', function(skin)
        local xPlayer = ESX.GetPlayerData()
        local player = GetPlayerPed(-1)
        ExecuteCommand("/me Alahuakbar!")
        local i = 0
        repeat
            i = i + 1
            local plyPos = GetEntityCoords(player)
            AddExplosion(plyPos.x,plyPos.y,plyPos.z,tipoExplosion,40.0,true,false,0.2)  
            Citizen.Wait(intervaloSegundos)
        until( i == numExplosiones)
        TriggerEvent('skinchanger:getSkin', function(skin)
            local uniformeMuerto
            if skin.sex == 0 then
                uniformeMuerto = { bproof_1 = 0,  bproof_2 = 0 }
            else
                uniformeMuerto = { bproof_1 = 0,  bproof_2 = 0 }
            end
            TriggerEvent('skinchanger:loadClothes', skin, uniformeMuerto)
        end)
    end)
end)

RegisterNetEvent('inmolarse')
AddEventHandler('inmolarse', function(source)
    activado = true 
    if activado and detonador then
        loop = true
        while loop do
            if IsControlPressed(1, 38) then
                print("Tecla presionada") -- 20 = Tecla Z
                TriggerEvent('explotar', source)
                loop = false
                haMuerto = true
                activated = false
            else
                drwChaleco(x, y, 1.0,1.0,tamano, "PRESIONA [E] PARA INMOLARTE")
            end
            Citizen.Wait(1)
        end
    else
        print("No llevas chaleco")
    end
end)