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

