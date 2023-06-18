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
    
INSERT INTO Personagem [(nome, nacao, usuario, pontos_de_poder, classe, nacao_do_clan, nome_do_clan)]
    VALUES 
    ('Angelob', 'Ducado de Ravenshire', 'angelobguido', 50, 'curandeiro', 'Ducado de Ravenshire', 'Paladinos de Montfort'),
    ('Lara Power', 'Principado de Astoria', 'guilhermeb', 75, 'mago', 'Principado de Astoria', 'Clã Solaris'),
    ('Sieg Xoxana', 'Ducado de Ravenshire', 'lucagamer', 60, 'guerreiro', 'Ducado de Ravenshire', 'Clã dos Corvos Negros');

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

--missao
--participacao_missao
--itens_gerados_missao
--comunidade_carente
--criacao_comunidade

--...