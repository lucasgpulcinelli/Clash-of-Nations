CREATE TYPE ClassePersonagem AS ENUM ('mago', 'guerreiro', 'atirador', 'curandeiro');
CREATE TYPE EspecializacaoPersonagem AS ENUM ('comerciante', 'diplomata');

CREATE TABLE usuario (
  nome VARCHAR(64),
  email VARCHAR(64) UNIQUE NOT NULL,
  data_de_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  senha VARCHAR(64) NOT NULL,
  moderador BOOLEAN NOT NULL DEFAULT false,
  aconselhador VARCHAR(64),

  CONSTRAINT pk_usuario PRIMARY KEY (nome),
  CONSTRAINT fk_usuario_usuario
    FOREIGN KEY (aconselhador) REFERENCES usuario(nome) ON DELETE RESTRICT,

  CONSTRAINT ck_usuario_email CHECK (email ~ '\w+@(\w+.?)+' ),
  CONSTRAINT ck_usuario_nome_aconselhador CHECK (nome <> aconselhador)
);

CREATE TABLE Nacao (
  nome VARCHAR(32),

  CONSTRAINT PK_Nacao PRIMARY KEY (nome)
);

CREATE TABLE Cla (
  nacao VARCHAR(32),
  nome VARCHAR(32),

  CONSTRAINT PK_Cla PRIMARY KEY (nacao, nome),
  CONSTRAINT FK_Cla_Nacao FOREIGN KEY (nacao)
    REFERENCES Nacao(nome) ON DELETE CASCADE
);

CREATE TABLE Personagem (
  ID SERIAL,
  nome VARCHAR(32) NOT NULL,
  nacao VARCHAR(32) NOT NULL,
  usuario VARCHAR(50) NOT NULL,
  pontos_de_poder NUMERIC NOT NULL,
  vida_maxima NUMERIC NOT NULL DEFAULT 100,
  dinheiro NUMERIC NOT NULL DEFAULT 0,
  classe ClassePersonagem NOT NULL,
  historia VARCHAR(100),
  experiencia NUMERIC NOT NULL DEFAULT 0,
  nacao_do_clan VARCHAR(32),
  nome_do_clan VARCHAR(32),
  especializacao EspecializacaoPersonagem,

  CONSTRAINT PK_Personagem PRIMARY KEY (ID),
  CONSTRAINT SK_Personagem UNIQUE (nome, usuario),
  CONSTRAINT FK_Personagem_clan FOREIGN KEY (nacao_do_clan, nome_do_clan)
    REFERENCES Cla(nacao, nome) ON DELETE SET NULL,
  CONSTRAINT FK_Personagem_nacao FOREIGN KEY (nacao)
    REFERENCES Nacao(nome) ON DELETE CASCADE,
  CONSTRAINT FK_Personagem_usuario FOREIGN KEY (usuario)
    REFERENCES usuario(nome) ON DELETE CASCADE

);

CREATE TABLE item (
  nome VARCHAR(64) NOT NULL,
  descricao VARCHAR(128) DEFAULT '',
  raridade VARCHAR(16) DEFAULT 'COMUM',
  valor_real NUMERIC NOT NULL,
  tipo VARCHAR(16),
  
  CONSTRAINT PK_ITEM PRIMARY KEY(nome),
  CONSTRAINT CK_ITEM_VALOR CHECK(valor_real >= 0),
  CONSTRAINT CK_ITEM_TIPO CHECK(UPPER(tipo) IN ('EQUIPAMENTO', 'CONSUMIVEL'))
);

CREATE TABLE monstro (
  nome VARCHAR(64) NOT NULL,
  vida_maxima NUMERIC NOT NULL,
  pontos_poder NUMERIC NOT NULL,
  raridade VARCHAR(16) DEFAULT 'COMUM',
  habilidade VARCHAR(16) DEFAULT 'NENHUMA',
  exp_gerado NUMERIC NOT NULL,

  CONSTRAINT PK_MONSTRO PRIMARY KEY(nome),
  
  CONSTRAINT CK_MONSTRO_VIDA CHECK (vida_maxima >= 0),
  CONSTRAINT CK_MONSTRO_PONTOS_PODER CHECK (pontos_poder >= 0),
  CONSTRAINT CK_MONSTRO_EXP_GERADO CHECK (exp_gerado >= 0)
);

CREATE TABLE masmorra (
  nome VARCHAR(64) NOT NULL,
  local VARCHAR(64),

  CONSTRAINT PK_MASMORRA PRIMARY KEY(nome)
);

CREATE TABLE missao (
  nome VARCHAR(64) NOT NULL,
  dificuldade VARCHAR(16) NOT NULL,
  exp_gerado NUMERIC NOT NULL,
  tempo_finalizar NUMERIC DEFAULT 60, -- EM SEGUNDOS
  masmorra VARCHAR(64) NOT NULL,

  CONSTRAINT PK_MISSAO PRIMARY KEY(nome),
  CONSTRAINT FK_MISSAO_MASMORRA FOREIGN KEY(masmorra) REFERENCES masmorra(nome) ON DELETE CASCADE,

  CONSTRAINT CK_MISSAO_EXP_GERADO CHECK (exp_gerado >= 0),
  CONSTRAINT CK_MISSAO_TEMPO CHECK (tempo_finalizar >= 0)
);

CREATE TABLE espolio_monstro(
  item VARCHAR(64) NOT NULL,
  monstro VARCHAR(64) NOT NULL,
  quantidade NUMERIC NOT NULL,
  
  CONSTRAINT PK_ESPOLIO_MONSTRO PRIMARY KEY(item, monstro),
  CONSTRAINT FK_ESPOLIO_MONSTRO_ITEM FOREIGN KEY (item) REFERENCES item(nome) ON DELETE CASCADE,
  CONSTRAINT FK_ESPOLIO_MONSTRO_MONSTRO FOREIGN KEY (monstro) REFERENCES monstro(nome) ON DELETE CASCADE,

  CONSTRAINT CK_ESPOLIO_QTT CHECK (quantidade >= 0)
);

CREATE TABLE monstro_masmorra (
  monstro VARCHAR(64) NOT NULL,
  masmorra VARCHAR(64) NOT NULL,
  quantidade NUMERIC NOT NULL,
  
  CONSTRAINT PK_MONSTRO_MASMORRA PRIMARY KEY (monstro, masmorra),
  CONSTRAINT FK_MONSTRO_MASMORRA_MONSTRO FOREIGN KEY (monstro) REFERENCES monstro(nome) ON DELETE CASCADE,
  CONSTRAINT FK_MONSTRO_MASMORRA_MASMORRA FOREIGN KEY (masmorra) REFERENCES masmorra(nome) ON DELETE CASCADE,

  CONSTRAINT CK_MONSTRO_MASMORRA_QTT CHECK (quantidade >= 0)
);

CREATE TABLE itens_gerados_missao (
  item VARCHAR(64) NOT NULL,
  missao VARCHAR(64) NOT NULL,
  quantidade NUMERIC NOT NULL,

  CONSTRAINT PK_ITENS_GERADOS_MISSAO PRIMARY KEY(item, missao),
  CONSTRAINT FK_ITENS_GERADOS_ITEM FOREIGN KEY(item) REFERENCES item(nome) ON DELETE CASCADE,
  CONSTRAINT FK_ITENS_GERADOS_MISSAO FOREIGN KEY(missao) REFERENCES missao(nome) ON DELETE CASCADE, 

  CONSTRAINT CK_ITENS_GERADOS_QTT CHECK (quantidade >= 0)
);

CREATE TABLE comunidade_carente (
  nome VARCHAR(64),
  local VARCHAR(256) NOT NULL,
  pontuação_total NUMERIC NOT NULL DEFAULT 0,

  CONSTRAINT pk_comunidade_carente PRIMARY KEY (nome)
);


CREATE TABLE criacao_comunidade (
  missao VARCHAR(64) NOT NULL,
  comunidade VARCHAR(64) NOT NULL,
  pontuacao NUMERIC NOT NULL,

  CONSTRAINT PK_CRIACAO_COMUNIDADE PRIMARY KEY(missao),
  CONSTRAINT FK_CRIACAO_COMUNIDADE_MISSAO FOREIGN KEY(missao) REFERENCES missao(nome) ON DELETE CASCADE,
  CONSTRAINT FK_CRIACAO_COMUNIDADE_COMUNIDADE FOREIGN KEY(comunidade) REFERENCES comunidade_carente(nome) ON DELETE CASCADE,

  CONSTRAINT CK_PONTUACAO CHECK (pontuacao >= 0)
);

CREATE TABLE participacao_missao (
  missao VARCHAR(64) NOT NULL,
  nacao VARCHAR(32) NOT NULL,
  cla VARCHAR(32) NOT NULL,
  data_termino TIMESTAMP NOT NULL,
  finalizaou BOOLEAN DEFAULT false,

  CONSTRAINT PK_PARTICIPACAO_MISSAO PRIMARY KEY(missao, nacao, cla, data_termino),
  CONSTRAINT FK_PARTICIPACAO_NACAO_CLA FOREIGN KEY(nacao, cla) REFERENCES Cla(nacao, nome) ON DELETE CASCADE
);

CREATE TABLE consumivel (
  item VARCHAR(64) NOT NULL,
  tempo_duracao NUMERIC NOT NULL, -- segundos

  CONSTRAINT PK_CONSUMIVEL PRIMARY KEY(item),
  CONSTRAINT FK_CONSUMIVEL_ITEM FOREIGN KEY(item) REFERENCES item(nome) ON DELETE CASCADE,

  CONSTRAINT CK_CONSUMIVEL_TEMPO CHECK (tempo_duracao >= 0)
);

CREATE TABLE efeito_consumivel (
  consumivel VARCHAR(64) NOT NULL,
  nome VArCHAR(64) NOT NULL,

  CONSTRAINT PK_EFEITO_CONSUMIVEL PRIMARY KEY(consumivel, nome),
  CONSTRAINT FK_EFEITO_CONSUMIVEL FOREIGN KEY(consumivel) REFERENCES consumivel(item) ON DELETE CASCADE
); 

CREATE TABLE equipamento (
  item VARCHAR(64) NOT NULL,
  nivel_permitido NUMERIC NOT NULL,
  pontos_poder NUMERIC NOT NULL,
  de_guerreiro BOOLEAN DEFAULT false,
  de_mago BOOLEAN DEFAULT false,
  de_atirador BOOLEAN DEFAULT false,
  de_curandeiro BOOLEAN DEFAULT false,

  CONSTRAINT PK_EQUIPAMENTO PRIMARY KEY(item),
  CONSTRAINT FK_EQUIPAMENTO_ITEM FOREIGN KEY(item) REFERENCES item(nome) ON DELETE CASCADE,

  CONSTRAINT CK_EQUIPAMENTO_PONTOS_PODER CHECK (pontos_poder >= 0)
);

CREATE TABLE habilidade_equipamento (
  equipamento VARCHAR(64) NOT NULL,
  nome VARCHAR(64) NOT NULL,

  CONSTRAINT PK_HABILIDADE_EQUIPAMENTO PRIMARY KEY(equipamento, nome),
  CONSTRAINT FK_HABILIDADE_EQUIPAMENTO FOREIGN KEY(equipamento) REFERENCES equipamento(item) ON DELETE CASCADE
);

CREATE TABLE Alianca (
  nacao1 VARCHAR(32),
  nacao2 VARCHAR(32),

  CONSTRAINT PK_Alianca PRIMARY KEY (nacao1, nacao2),
  CONSTRAINT FK_Alianca_nacao1 FOREIGN KEY(nacao1)
    REFERENCES Nacao(nome) ON DELETE CASCADE,
  CONSTRAINT FK_Alianca_nacao2 FOREIGN KEY(nacao2)
    REFERENCES Nacao(nome) ON DELETE CASCADE,
  CONSTRAINT CK_Alianca_Nacao_Igual CHECK (nacao1 != nacao2)
);

CREATE TABLE Compra_Com_Doacao(
  personagem INTEGER,
  item VARCHAR(64),
  data TIMESTAMP DEFAULT NOW(),
  quantidade NUMERIC NOT NULL DEFAULT 1,

  CONSTRAINT PK_Compra_Com_Doacao PRIMARY KEY (personagem, item, data),
  CONSTRAINT FK_Compra_Com_Doacao_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID) ON DELETE CASCADE,
  
  CONSTRAINT FK_Compra_Com_Doacao_item FOREIGN KEY (item)
    REFERENCES item(nome) ON DELETE CASCADE
    
);

CREATE TABLE Venda(
  item VARCHAR(64),
  vendedor INTEGER,
  comprador INTEGER,
  data TIMESTAMP NOT NULL DEFAULT NOW(),
  valor_total NUMERIC NOT NULL,
  quantidade NUMERIC NOT NULL DEFAULT 1,

  CONSTRAINT PK_Venda PRIMARY KEY (item, vendedor, comprador),
  CONSTRAINT FK_Venda_vendedor FOREIGN KEY (vendedor)
    REFERENCES Personagem(ID) ON DELETE CASCADE,
  CONSTRAINT FK_Venda_comprador FOREIGN KEY (comprador)
    REFERENCES Personagem(ID) ON DELETE CASCADE,
  CONSTRAINT FK_Venda_item FOREIGN KEY (item)
    REFERENCES item(nome) ON DELETE CASCADE
  
  --CONSTRAINT CK_Venda_vendedor CHECK('comerciante' IN (SELECT especializacao FROM Personagem P WHERE vendedor=P.ID))
);

CREATE TABLE Personagem_Possui_Itens(
  personagem INTEGER,
  item VARCHAR(64),
  quantidade NUMERIC NOT NULL DEFAULT 1,
  equipado BOOLEAN NOT NULL DEFAULT false,

  CONSTRAINT PK_Personagem_Possui_Itens PRIMARY KEY (personagem, item),
  CONSTRAINT FK_Personagem_Possui_Itens_item FOREIGN KEY (item)
    REFERENCES item(nome),
  CONSTRAINT FK_Personagem_Possui_Itens_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID) ON DELETE CASCADE
  
  --CONSTRAINT CK_Personagem_Possui_Itens_equipado CHECK((equipado AND ('EQUIPAMENTO' IN UPPER(SELECT tipo FROM item WHERE item.nome = item))) OR (equipado = false) ) --Checar se o item equipado 'e um equipamento

);

CREATE TABLE Vota_Em_Alianca(
  personagem INTEGER,
  nacao VARCHAR(32),
  favoravel BOOLEAN NOT NULL DEFAULT false,

  CONSTRAINT PK_Vota_Em_Alianca PRIMARY KEY (personagem, nacao), 
  CONSTRAINT FK_Vota_Em_Alianca_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID)
  
  --CONSTRAINT CK_Vota_Em_Alianca_diplomata CHECK ('diplomata' IN (SELECT especializacao FROM Personagem P WHERE personagem=P.ID))
);

CREATE TABLE topico (
  id SERIAL,
  criador VARCHAR(64) NOT NULL,
  titulo VARCHAR(128) NOT NULL,
  data_de_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  assunto TEXT,

  CONSTRAINT pk_topico PRIMARY KEY (id),
  UNIQUE(criador, data_de_criacao),
  CONSTRAINT fk_topico_usuario FOREIGN KEY(criador) REFERENCES usuario(nome) ON DELETE RESTRICT
);

CREATE TABLE mensagem (
  id SERIAL,
  topico SERIAL NOT NULL,
  criador VARCHAR(64) NOT NULL,
  data_de_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  mensagem_respondida SERIAL,
  numero_de_curtidas NUMERIC NOT NULL DEFAULT 0,
  conteudo TEXT NOT NULL,

  CONSTRAINT pk_mensagem PRIMARY KEY (id),
  UNIQUE(topico, criador, data_de_criacao),
  CONSTRAINT fk_mensagem_topico FOREIGN KEY(topico) REFERENCES topico(id) ON DELETE RESTRICT,
  CONSTRAINT fk_mensagem_usuario FOREIGN KEY(criador) REFERENCES usuario(nome) ON DELETE RESTRICT,
  CONSTRAINT fk_mensagem_mensagem FOREIGN KEY(mensagem_respondida) REFERENCES mensagem(id),

  CONSTRAINT ck_mensagem_id_mensagem_respondida CHECK ( id <> mensagem_respondida )
);

CREATE TABLE moderador_oculta_mensagem (
  mensagem SERIAL,
  moderador VARCHAR(64) UNIQUE NOT NULL,

  CONSTRAINT pk_moderador_oculta_mensagem PRIMARY KEY (mensagem),
  CONSTRAINT fk_moderador_oculta_mensagem_mensagem
    FOREIGN KEY(mensagem) REFERENCES mensagem(id) ON DELETE RESTRICT,
  CONSTRAINT fk_moderador_oculta_mensagem_usuario
    FOREIGN KEY(moderador) REFERENCES usuario(nome) ON DELETE RESTRICT
);

CREATE TABLE doacao_para_comunidade (
  usuario VARCHAR(64),
  comunidade VARCHAR(64),
  data DATE NOT NULL DEFAULT NOW(),
  valor NUMERIC NOT NULL DEFAULT 0,

  CONSTRAINT pk_doacao_para_comunidade PRIMARY KEY(usuario, comunidade, data)
);

CREATE TABLE equipamento_doado (
  usuario VARCHAR(64),
  comunidade VARCHAR(64),
  data DATE NOT NULL DEFAULT NOW(),
  nome_do_equipamento VARCHAR(64),

  CONSTRAINT pk_equipamento_doado PRIMARY KEY(usuario, comunidade, data, nome_do_equipamento),
  CONSTRAINT fk_equipamento_doado_doacao_para_comunidade FOREIGN KEY(usuario, comunidade, data)
    REFERENCES doacao_para_comunidade(usuario, comunidade, data)
    ON DELETE CASCADE
);
