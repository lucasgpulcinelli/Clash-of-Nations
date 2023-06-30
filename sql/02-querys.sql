-- Pega todos os consumiveis de um determinado personagem e pega o tempo total de duração de todos eles separando por raridade 
SELECT I.RARIDADE, SUM(C.TEMPO_DURACAO*PPI.QUANTIDADE) AS TEMPO_TOTAL
FROM item I 
    JOIN PERSONAGEM_POSSUI_ITENS PPI
    ON I.NOME = PPI.ITEM

    JOIN CONSUMIVEL C
    ON PPI.ITEM = C.ITEM
WHERE PPI.PERSONAGEM = 2
GROUP BY I.RARIDADE;


-- Pega a soma de todos monstros e de todos os espólios de monstros dropados para cada masmorra que
-- possui 5 missoes relacionas
SELECT MM.MASMORRA, SUM(MM.QUANTIDADE), SUM(EM.QUANTIDADE*MM.QUANTIDADE)
FROM MISSAO MS
    JOIN MASMORRA M
    ON MS.MASMORRA = M.NOME
    JOIN MONSTRO_MASMORRA MM
    ON M.NOME = MM.MASMORRA

    JOIN ESPOLIO_MONSTRO EM
    ON MM.MONSTRO = EM.MONSTRO
GROUP BY MM.MASMORRA
HAVING COUNT(*) >= 5;

--Pega a média das curtidas das mensagens de cada usuário
SELECT U.NOME, AVG(M.NUMERO_DE_CURTIDAS) AS MEDIA_CURTIDAS
FROM USUARIO U
    LEFT JOIN MENSAGEM M
    ON U.NOME = M.CRIADOR
GROUP BY U.NOME;


-- Buscar por todas as masmorras que o clã do personagem finalizou e a quantidade de vezes que isso aconteceu. Visto que duas missões diferentes podem ir para a mesma masmorra. E na mesma tabela, mostrar quantas missões existem com aquela masmorra. Desta forma a gente pode ver se o clã já fez tudo que podia ser feito com a masmorra.
SELECT M.MASMORRA, COUNT(*) AS TOTAL_MISSOES, SUM(CASE WHEN PM.FINALIZOU = TRUE THEN 1 ELSE 0 END) AS MISSOES_FINALIZADAS
FROM PARTICIPACAO_MISSAO PM 
    JOIN MISSAO M
    ON PM.MISSAO = M.NOME
WHERE PM.CLA = 'Paladinos de Montfort'
GROUP BY M.MASMORRA;


-- Pega o nome dos personagens que possuem os memos itens que o personagem 'Angelob' DIVISAO RELACIONAL
SELECT P.NOME
FROM PERSONAGEM P 
WHERE NOT EXISTS (
    (SELECT PPI1.ITEM
    FROM PERSONAGEM P1 JOIN PERSONAGEM_POSSUI_ITENS PPI1
    ON PPI1.PERSONAGEM = P1.ID
    WHERE P1.NOME='Angelob')

    EXCEPT

    (SELECT PPI2.ITEM
    FROM PERSONAGEM_POSSUI_ITENS PPI2
    WHERE PPI2.PERSONAGEM = P.ID)
);
