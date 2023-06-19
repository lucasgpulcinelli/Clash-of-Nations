INSERT INTO usuario [(nome, email, data_de_criacao, senha, moderador, aconselhador)]
    VALUES
    ('angelobguido', 'angelo@gmail.com', NOW(), '123', true, NULL),
    ('guilhermeb', 'gui@gmail.com', NOW(), '1234', false, 'angelobguido'),
    ('lucagamer', 'lucas@gmail.com', NOW(), '1ab', true, NULL);

INSERT INTO Nacao [(nome)]
    VALUES
    ('Reino de Eldoria'),
    ('Principado de Astoria'),
    ('Ducado de Ravenshire');
    
INSERT INTO Cla [(nacao, nome)]
    VALUES
    ('Ducado de Ravenshire', 'Paladinos de Montfort'),
    ('Principado de Astoria', 'Clã Solaris'),
    ('Principado de Astoria', 'Clã Estrelado')
    ('Ducado de Ravenshire', 'Clã dos Corvos Negros');
    
INSERT INTO Personagem [(nome, nacao, usuario, pontos_de_poder, classe, nacao_do_clan, nome_do_clan, especializacao)]
    VALUES 
    ('Angelob', 'Ducado de Ravenshire', 'angelobguido', 50, 'curandeiro', 'Ducado de Ravenshire', 'Paladinos de Montfort', 'comerciante'),
    ('Lara Power', 'Principado de Astoria', 'guilhermeb', 75, 'mago', 'Principado de Astoria', 'Clã Solaris', 'comerciante'),
    ('Sieg Xoxana', 'Ducado de Ravenshire', 'lucagamer', 60, 'guerreiro', 'Ducado de Ravenshire', 'Clã dos Corvos Negros', 'diplomata');

INSERT INTO item [(nome, descricao, raridade, valor_real, tipo)]
    VALUES
    ('Espada das Sombras', 'Uma espada negra com lâmina reluzente. Ela consome a luz ao seu redor, deixando uma trilha de escuridão por onde passa. Aqueles atingidos por ela têm suas energias drenadas.', 'EPICO', 20, 'EQUIPAMENTO'),
    ('Pergaminho de Cura', 'Um pergaminho antigo e encantado contendo símbolos curativos. Quando ativado, ele emite uma aura radiante que cura ferimentos e restaura a vitalidade dos aliados próximos.', 'RARO', 5, 'CONSUMIVEL'),
    ('Armadura da Fênix', 'Uma armadura de placas douradas adornadas com penas de fênix. Quando o usuário está prestes a ser derrotado, a armadura emite uma chama sagrada que o envolve, concedendo imortalidade temporária.', 'LENDARIO', 100, 'EQUIPAMENTO'),
    ('Poção de Invisibilidade', 'Uma poção translúcida que, quando consumida, faz com que o usuário se torne invisível por um curto período. Permite a passagem despercebida por inimigos e facilita a realização de ataques furtivos.', 'COMUM', 1, 'CONSUMIVEL'),
    ('Amuleto da Sabedoria', 'Um amuleto cravejado de gemas brilhantes, emanando uma aura de conhecimento. Aqueles que o usam têm suas habilidades mentais aprimoradas, permitindo uma maior compreensão de feitiços e uma percepção mais aguçada do mundo ao seu redor.', 'INCOMUM', 15, 'EQUIPAMENTO');

INSERT INTO consumivel [(item, tempo_duracao)]
    VALUES 
    ('Pergaminho de Cura', 30),
    ('Poção de Invisibilidade', 60);

INSERT INTO efeito_consumivel [(consumivel, nome)]
    VALUES
    ('Pergaminho de Cura', 'Regeneração de Vida'),
    ('Poção de Invisibilidade', 'Invisibilidade');

INSERT INTO equipamento [(item, nivel_permitido, pontos_poder, de_guerreiro, de_mago, de_atirador, de_curandeiro)]
    VALUES
    ('Espada das Sombras', 15, 25, true, false, true, false),
    ('Armadura da Fênix', 20, 50, true, false, false, true),
    ('Amuleto da Sabedoria', 10, 15, false, true, false, true);
    
INSERT INTO habilidade_equipamento [(equipamento, nome)]
    VALUES
    ('Espada das Sombras', 'Drenar Vida'),
    ('Armadura da Fênix', 'Renascimento'),
    ('Amuleto da Sabedoria', 'Aumento da Sabedoria');
    
INSERT INTO monstro [(nome, vida_maxima, pontos_poder, raridade, habilidade, exp_gerado)]
    VALUES
    ('Dragão Sombrio', 1000, 150, 'LENDARIO', 'Sopro do Caos', 5000),
    ('Espírito das Trevas', 500, 75, 'EPICO', 'Drenar Alma', 2000),
    ('Gigante de Pedra', 1500, 100, 'RARO', 'Esmagar', 3000),
    ('Espreitador Sombrio', 800, 120, 'COMUM', 'Camuflagem das Sombras', 1500),
    ('Serpente Venenosa', 400, 50, 'INCOMUM', 'Mordida Tóxica', 1000);

INSERT INTO espolio_monstro [(item, monstro, quantidade)]
    VALUES 
    ('Espada das Sombras', 'Dragão Sombrio', 1),
    ('Amuleto da Sabedoria', 'Gigante de Pedra', 1),
    ('Poção de Invisibilidade', 'Espreitador Sombrio', 5);

INSERT INTO masmorra [(nome, local)]
    VALUES
    ('Abismo Profundo', 'Ruínas de Karnegar'),
    ('Cripta das Almas Perdidas', 'Cemitério de Somberville'),
    ('Covil do Dragão de Fogo', 'Montanhas Ardentes');

INSERT INTO monstro_masmorra [(monstro, masmorra, quantidade)]
    VALUES
    ('Espírito das Trevas', 'Cripta das Almas Perdidas', 10),
    ('Espreitador Sombrio', 'Abismo Profundo', 10),
    ('Dragão Sombrio', 'Covil do Dragão de Fogo', 3),
    ('Serpente Venenosa', 'Covil do Dragão de Fogo', 20)

INSERT INTO missao [(nome, dificuldade, exp_gerado, tempo_finalizar, masmorra)]
    VALUES
    ('O Tesouro das Profundezas', 'Facil', 1000, 180, 'Abismo Profundo'),
    ('O Segredo dos Espíritos Perdidos', 'MediA', 2500, 240, 'Cripta das Almas Perdidas'),
    ('A Ira do Dragão Flamejante', 'DIFicil', 5000, 200, 'Covil do Dragão de Fogo'),
    ('A Provação do Desafiante', 'ImpossIVEL', 10000, 40, 'Abismo Profundo');

INSERT INTO participacao_missao [(missao, nacao, cla, data_termino, finalizou)]
    VALUES
    ('O Tesouro das Profundezas', 'Ducado de Ravenshire', 'Paladinos de Montfort', '2021-06-01 00:00:00', true),
    ('O Segredo dos Espíritos Perdidos', 'Principado de Astoria', 'Clã Solaris', '2021-07-06 00:00:00', false),
    ('A Ira do Dragão Flamejante', 'Ducado de Ravenshire', 'Clã dos Corvos Negros', '2021-08-01 00:00:00', true),
    ('A Provação do Desafiante', 'Ducado de Ravenshire', 'Paladinos de Montfort', '2021-09-01 00:00:00', false);

INSERT INTO itens_gerados_missao [(item, missao, quantidade)]
    VALUES 
    ('Armadura da Fênix', 'A Provação do Desafiante', 1),
    ('Amuleto da Sabedoria', 'O Segredo dos Espíritos Perdidos', 10);

INSERT INTO comunidade_carente [(nome, local, pontuacao_total)]
    VALUES 
    ('Comunidade Esperança', 'Cidade da Paz', 250),
    ('Associação Renascer', 'Vila da Floresta', 180),
    ('Projeto União Fraterna', 'Bairro Novo Horizonte', 300);

INSERT INTO criacao_comunidade [(missao, comunidade, pontuacao)]
    VALUES 
    ('A Provação do Desafiante', 'Projeto União Fraterna', 100),
    ('O Tesouro das Profundezas', 'Associação Renascer', 20),
    ('A Ira do Dragão Flamejante', 'Comunidade Esperança', 50);

INSERT INTO Alianca [(nacao1, nacao2)]
    VALUES
    ('Reino de Eldoria', 'Principado de Astoria'),
    ('Reino de Eldoria', 'Ducado de Ravenshire');

INSERT INTO Compra_Com_Doacao [(personagem, item, quantidade)]
    VALUES
    (1, 'Armadura da Fênix', 10),
    (1, 'Espada das Sombras', 10);

INSERT INTO Venda [(item, vendedor, comprador, valor_total, quantidade)]
    VALUES
    ('Armadura da Fênix', 1, 2, 1000, 1),
    ('Espada das Sompras', 1, 2, 500, 1);

INSERT INTO Personagem_Possui_Itens [(personagem, item, quantidade, equipado)]
    VALUES
    (1, 'Armadura da Fênix', 10, true),
    (2, 'Poção de Invisibilidade', 50, false);

INSERT INTO Vota_Em_Alianca [(personagem, nacao, favoravel)]
    VALUES
    (3, 'Principado de Astoria', true),
    (3, 'Reino de Eldoria', true);

INSERT INTO topico [(criador, titulo, data_de_criacao, assunto)]
    VALUES
    ('angelobguido', 'Como obter a Armadura de fenix?', '2022-01-02 00:20:00', 'ajuda'),
    ('lucagamer', 'Como participar de um clã?', '2021-12-03 00:20:00', 'ajuda');

INSERT INTO mensagem [(topico, criador, data_de_criacao, mensagem_respondida, conteudo)]
    VALUES 
    (1, 'angelobguido', '2022-01-02 00:20:00', NULL, 'Como eu obtenho a lendária armadura de fenix??'),
    (1, 'lucagamer', '2022-01-03 00:20:00', 1, 'Mano, tu precisa fazer a missão A Provação Do Desafiante. É uma missão muito difícil, mas é a única forma que eu sei que é possível'),
    (2, 'lucasgamer', '2021-12-03 00:20:00', NULL, 'Galera, como eu entro em um clã? Tô meio perdido aqui.'),
    (2, 'angelobguido', '2021-12-07 00:20:00', 3, 'Deixa de ser mané, é mó fácil. Só precisa ir para o centro da nação(onde vc nasceu) clicar no clã que tu quer lá no grado dos clãs');

INSERT INTO moderador_oculta_mensagem [(mensagem, moderador)]
    VALUES
    (2, 'angelobguido'),
    (4, 'angelobguido');

INSERT INTO doacao_para_comunidade [(usuario, comunidade, data, valor)]
    VALUES
    ('angelobguido', 'Comunidade Esperança', '2022-01-09 00:20:00', 1000),
    ('angelobguido', 'Comunidade Esperança', '2022-01-04 00:20:00', 0);

INSERT INTO equipamento_doado [(usuario, comunidade, data, nome_do_equipamento)]
    VALUES
    ('angelobguido', 'Comunidade Esperança', '2022-01-04 00:20:00', 'dois Headset Gamer Dragon Fire')
    ('angelobguido', 'Comunidade Esperança', '2022-01-04 00:20:00', 'um Mouse Gamer Dragon Fire X')