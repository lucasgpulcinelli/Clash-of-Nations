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

--Alianca
--Compra com doacao
--Venda
--Personagem possui itens
--Vota em alianca