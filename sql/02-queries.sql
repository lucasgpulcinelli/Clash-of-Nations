-- Pega todos os consumiveis de um determinado personagem e pega o tempo total de duração de todos eles separando por raridade 
SELECT I.RARIDADE, SUM(C.TEMPO_DURACAO*PPI.QUANTIDADE) AS TEMPO_TOTAL
FROM item I 
    JOIN PERSONAGEM_POSSUI_ITENS PPI
    ON I.NOME = PPI.ITEM

    JOIN CONSUMIVEL C
    ON PPI.ITEM = C.ITEM
WHERE PPI.PERSONAGEM = 2
GROUP BY I.RARIDADE;


-- Pega a quantidade de monstros e de espólios dropados para cada masmorra que
-- possui pelo menos duas missoes relacionas
SELECT M.NOME, SUM(MM.QUANTIDADE) AS MONSTROS, SUM(EM.QUANTIDADE*MM.QUANTIDADE) AS ESPOLIOS
FROM (
    SELECT M2.NOME
    FROM MASMORRA M2
        JOIN MISSAO MS
        ON M2.NOME = MS.MASMORRA
    GROUP BY M2.NOME
    HAVING COUNT(*) >= 2
) M
    LEFT JOIN MONSTRO_MASMORRA MM
    ON M.NOME = MM.MASMORRA
    LEFT JOIN ESPOLIO_MONSTRO EM
    ON MM.MONSTRO = EM.MONSTRO
GROUP BY M.NOME;

--Pega, para cada moderador, a quantidade de tópicos desse mês que tiveram mensagens ocultadas por ele
SELECT U.NOME, COUNT(T.ID) AS NRO_TOPICOS
FROM USUARIO U
    LEFT JOIN (
        SELECT T2.ID, MOM.MODERADOR
        FROM TOPICO T2
            JOIN MENSAGEM M
            ON T2.ID = M.TOPICO AND NOW() - T2.DATA_DE_CRIACAO <= '30d'
            JOIN MODERADOR_OCULTA_MENSAGEM MOM
            ON M.ID = MOM.MENSAGEM
        GROUP BY T2.ID, MOM.MODERADOR
    ) T
    ON U.NOME = T.MODERADOR
WHERE U.MODERADOR
GROUP BY U.NOME
ORDER BY NRO_TOPICOS;


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
