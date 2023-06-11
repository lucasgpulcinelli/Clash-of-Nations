CREATE TYPE ClassePersonagem AS ENUM ('mago', 'guerreiro', 'atirador', 'curandeiro');
CREATE TYPE EspecializacaoPersonagem AS ENUM ('comerciante', 'diplomata');

CREATE TABLE usuario (
  nome VARCHAR(50),
  email VARCHAR(50) UNIQUE NOT NULL,
  data_de_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
  senha VARCHAR(50) NOT NULL,
  moderador BOOLEAN NOT NULL DEFAULT false,
  aconselhador VARCHAR(50),

  PRIMARY KEY (nome),
  FOREIGN KEY (aconselhador) REFERENCES usuario(nome)
);

CREATE TABLE Personagem (
  ID INT GENERATED ALWAYS AS IDENTITY,
  nome VARCHAR(32) NOT NULL,
  nacao VARCHAR(32) NOT NULL,
  usuario VARCHAR(50) NOT NULL,
  pontos_de_poder INT NOT NULL,
  vida_maxima, INT NOT NULL DEFAULT 100,
  dinheiro INT NOT NULL DEFAULT 0,
  classe ClassePersonagem NOT NULL,
  historia VARCHAR(100),
  experiencia INT NOT NULL DEFAULT 0,
  nacao_do_clan VARCHAR(32),
  nome_do_clan VARCHAR(32),
  especializacao EspecializacaoPersonagem,

  CONSTRAINT PK_Personagem PRIMARY KEY (ID),
  CONSTRAINT SK_Personagem UNIQUE (nome, usuario),
  CONSTRAINT FK_Personagem_Clan FOREIGN KEY (nacao_do_clan, nome_do_clan)
    REFERENCES Cla(nacao, nome)

);

CREATE TABLE Nacao (
  nome VARCHAR(32),

  CONSTRAINT PK_Nacao PRIMARY KEY (nome)
);

CREATE TABLE Cla (
  nacao VARCHAR(32),
  nome VARCHAR(32),

  CONSTRAINT PK_Clan PRIMARY KEY (nacao, nome)
  CONSTRAINT FK_Clan_Nacao FOREIGN KEY (nacao)
    REFERENCES Nacao(nome)
);

CREATE TABLE Alianca (
  nacao1 VARCHAR(32),
  nacao2 VARCHAR(32),

  CONSTRAINT PK_Alianca PRIMARY KEY (nacao1, nacao2),
  CONSTRAINT FK_Alianca_nacao1 FOREIGN KEY(nacao1)
    REFERENCES Nacao(nome),
  CONSTRAINT FK_Alianca_nacao2 FOREIGN KEY(nacao2)
    REFERENCES Nacao(nome),
  CONSTRAINT CHECK_Alianca_Nacao_Igual CHECK (nacao1 != nacao2)
);

CREATE TABLE Compra_Com_Doacao(
  personagem INT,
--  item VARCHAR(32),
  data TIMESTAMP DEFAULT NOW(),
  quantidade INT NOT NULL DEFAULT 1,

  CONSTRAINT PK_Compra_Com_Doacao PRIMARY KEY (personagem, item, data),
  CONSTRAINT FK_Compra_Com_Doacao_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID),
  
--  CONSTRAINT FK_Compra_Com_Doacao_item FOREIGN KEY (item)
--    REFERENCES Item(nome),
    

);

CREATE TABLE Venda(
  --item VARCHAR(32),
  vendedor INT,
  comprador INT,
  data TIMESTAMP NOT NULL DEFAULT NOW(),
  valor_total NOT NULL,
  quantidade NOT NULL DEFAULT 1,

  CONSTRAINT PK_Venda PRIMARY KEY (item, vendedor, comprador),
  CONSTRAINT FK_Venda_vendedor FOREIGN KEY (vendedor)
    REFERENCES Personagem(ID),
  CONSTRAINT FK_Venda_comprador FOREIGN KEY (comprador)
    REFERENCES Personagem(ID),
  -- CONSTRAINT FK_Venda_item FOREIGN KEY (item)
  --   REFERENCES Item(nome),
  
  CONSTRAINT Check_Venda_vendedor CHECK('comerciante' IN (SELECT especializacao FROM Personagem P WHERE vendedor=P.ID))
);

CREATE TABLE Personagem_Possui_Itens(
  personagem INT,
  --item VARCHAR(32),
  quantidade INT NOT NULL DEFAULT 1,
  equipado BOOLEAN NOT NULL DEFAULT false,

  CONSTRAINT PK_Personagem_Possui_Itens PRIMARY KEY (personagem, item)
  -- CONSTRAINT FK_Personagem_Possui_Itens_item FOREIGN KEY (item)
  --   REFERENCES Item(nome),
  CONSTRAINT FK_Personagem_Possui_Itens_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID),
  --(CHECAR SE ITEM EH EQUIPAVEL) CONSTRAINT Check_Personagem_Possui_Itens_equipado CHECK(equipado AND () )

);

CREATE TABLE Vota_Em_Alianca(
  personagem INT,
  nacao VARCHAR(32),
  favoravel BOOLEAN NOT NULL DEFAULT false,

  CONSTRAINT PK_Vota_Em_Alianca PRIMARY KEY (personagem, nacao), 
  CONSTRAINT FK_Vota_Em_Alianca_personagem FOREIGN KEY (personagem)
    REFERENCES Personagem(ID),
  
  CONSTRAINT Check_Vota_Em_Alianca_diplomata CHECK ('diplomata' IN (SELECT especializacao FROM Personagem P WHERE personagem=P.ID))

);