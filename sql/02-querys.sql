-- Pega todos os consumiveis de um determinado personagem e pega o tempo total de duração de todos eles separando por raridade 
SELECT I.RARIDADE, SUM(C.TEMPO_DURACAO*PPI.QUANTIDADE)
FROM item I 
    JOIN PERSONAGEM_POSSUI_ITENS PPI
    ON I.NOME = PPI.ITEM

    JOIN CONSUMIVEL C
    ON PPI.ITEM = C.ITEM
WHERE PPI.PERSONAGEM = 2
GROUP BY I.RARIDADE;


-- Pega a soma de todos monstros e de todos os espólios de monstros dropados em uma determinada masmorra
SELECT SUM(MM.QUANTIDADE), SUM(EM.QUANTIDADE*MM.QUANTIDADE)
FROM MASMORRA M
    JOIN MONSTRO_MASMORRA MM
    ON M.NOME = MM.MASMORRA

    JOIN ESPOLIO_MONSTRO EM
    ON MM.MONSTRO = EM.MONSTRO
WHERE MASMORRA = 'Abismo Profundo';


-- Pega a média das curtidas de todas mensagens de um determinado usuário em cada mês, excluindo as mensagens que tem 0 curtidas
SELECT EXTRACT(MONTH FROM M.DATA_DE_CRIACAO), AVG(M.NUMERO_DE_CURTIDAS)
FROM TOPICO T JOIN MENSAGEM M
    ON T.ID = M.TOPICO
WHERE M.CRIADOR = 'angelobguido' AND M.NUMERO_DE_CURTIDAS > 0
GROUP BY EXTRACT(MONTH FROM M.DATA_DE_CRIACAO);


-- Pega a média do valor de cada equipamento doado a uma comunidade determinada
SELECT ED.NOME_DO_EQUIPAMENTO, AVG(DC.VALOR)
FROM COMUNIDADE_CARENTE CC 
    JOIN DOACAO_PARA_COMUNIDADE DC
    ON CC.NOME = DC.COMUNIDADE

    JOIN EQUIPAMENTO_DOADO ED
    ON ED.USUARIO = DC.USUARIO AND ED.COMUNIDADE = DC.COMUNIDADE AND ED.DATA = DC.DATA
WHERE CC.NOME = 'Comunidade Esperança'
GROUP BY ED.NOME_DO_EQUIPAMENTO;


-- Pega o nome dos personagens que possuem os memos itens que o personagem 'Angelob' DIVISAO RELACIONAL
SELECT P.NOME
FROM PERSONAGEM P 
    JOIN PERSONAGEM_POSSUI_ITENS PPI
    ON P.ID = PPI.PERSONAGEM
WHERE PPI.ITEM = 'Armadura da Fênix' AND
NOT EXISTS (

    (SELECT PPI1.ITEM
    FROM PERSONAGEM P1 JOIN PERSONAGEM_POSSUI_ITENS PPI1
    ON PPI1.PERSONAGEM = P1.ID
    WHERE P1.NOME='Angelob')

    EXCEPT

    (SELECT PPI2.ITEM
    FROM PERSONAGEM_POSSUI_ITENS PPI2
    WHERE PPI2.PERSONAGEM = P.ID)
);
