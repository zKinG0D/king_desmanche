Config = {}

-- Permissão para desmanchar --
Config.permissao = "dono.permissao"

-- Coordenadas de locais para desmanchar --
Config.coordenadas_locais_desmanche = {
    [1] = { ['x'] = 1541.94, ['y'] = 3532.31, ['z'] = 35.37 },
}

-- Coordenadas de locais para pegar ferramentas --
Config.coordenadas_locais_ferramentas = {
    [1] = { ['x'] = 1532.070, ['y'] = 3535.197, ['z'] = 35.362, ['h'] = 133.5 }, -- H é a direção para onde o player irá olhar
}

-- Coordenadas de locais para guardar peças --
Config.coordenadas_locais_guardarPecas = {
    [1] = { ['x'] = 1540.758, ['y'] = 3545.450, ['z'] = 35.362, ['h'] = 303 }, -- H é a direção para onde o player irá olhar
}

-- Coordenadas de locais para vender peças --
Config.coordenadas_locais_venda = {
    [1] = { ['x'] = 1556.260, ['y'] = 3523.321, ['z'] = 36.119 },
}

-- Tempo em milisegundos que o player leva para coletar as ferramentas --
Config.tempo_coletar_ferramentas = 500

-- Tempo em milisegundos que o player leva para remover as peças do veiculo --
Config.tempo_remover_pecas = 3000

-- Objetos que o player carrega na mão durante o processo de desmanche --
-- Existem diversos modelos de rodas/portas, etc que o player pode pegar. --
-- Se quiser alterar você pode encontrar os objetos em: https://gta-objects.xyz/objects --
-- No site acima pesquise por: door, wheel, etc para encontrar o prop desejado. --

Config.props = {
    ['portas'] = 'imp_prop_impexp_car_door_04a',
    ['rodas'] = 'prop_tornado_wheel',
}

-- Caso o nome dos itens em seu servidor esteja diferente basta alterar aqui. --
-- Obs: alteração no = "nomedoitem" --
Config.itens = {
    ['rodaDeCarro'] = "rodacarro",
    ['portaDeCarro'] = "portacarro",
    ['rodaDeMoto'] = "rodamoto",
}

-- Mensagens de Notificações
Config.notifyMsgs = {
    ['sem_permissao'] = 'Você não tem permissão para produzir veiculos!', -- Mensagem caso o player não tenha permissão.
    ['comecar_desmanche'] = 'Você iniciou o processo de desmanche, vá pegar as ferramentas!', -- Mensagem caso o player inicie o trabalho.
    ['carro_invalido'] = 'Você não pode desmanchar este veiculo!', -- Caso o veiculo não esteja na lista.
    ['assento_invalido'] = 'Você precisa estar no assento do motorista para iniciar o desmanche!', -- Caso o player não esteja no primeiro assento.
    ['pegando_ferramentas'] = 'Você está pegando as ferramentas!', -- Mensagem ao começar pegar as ferramentas.
    ['pegou_ferramentas'] = 'Você pegou as ferramentas, agora vá desmanchar o veiculo!', -- Mensagem ao coletar as ferramentas.
    ['desmanchou_veiculo'] = 'Você desmanchou o veículo! Venda as peças no computador.', -- Ao terminar o desmanche do veiculo.
    ['cancelar_trabalho'] = 'Você pressionou a tecla (<b>F7</b>). O trabalho foi cancelado.', -- Mensagem caso o player aperte F7.
    ['trabalho_concluido'] = 'Você finalizou o desmanche e suas peças foram vendidas!', -- Mensagem caso o player termine a produção do veiculo.
}

-- Obs: ~w~ para branco, ~g~ para verde, ~b~ para azul, ~r~ para vermelho, e assim por diante. --

-- Texto para Desmanchar o veiculo --
Config.desmancharText = '~w~Pressione ~g~[E] ~w~para ~r~DESMANCHAR ~w~o veículo.'

-- Texto de Remover Peças do veiculo --
Config.removerPecasText = '~w~Pressione ~g~[E] ~w~para remover as peças do veiculo.' 


---------------------------------------------------------------------------------------------------------
-- Configs desenvolvedor
-- Aviso: Só mude algo abaixo caso entenda do que se trata.
---------------------------------------------------------------------------------------------------------
Config.notifyEvent = 'Notify'
Config.progressEvent = 'progress'

Config.rgbRemoverPecas1 = 194
Config.rgbRemoverPecas2 = 93
Config.rgbRemoverPecas3 = 25
