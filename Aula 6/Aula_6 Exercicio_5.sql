CREATE TABLE aula6.engenheiro (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    crea INT NOT NULL
);

CREATE TABLE aula6.pessoa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) NOT NULL
);

CREATE TABLE aula6.edificacao (
    id SERIAL PRIMARY KEY,
    metragem_total FLOAT NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    engenheiro_id INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    FOREIGN KEY (engenheiro_id) REFERENCES aula6.engenheiro(id)
);

CREATE TABLE aula6.predio (
    id SERIAL PRIMARY KEY,
    edificacao_id INT NOT NULL,
    nome VARCHAR(255) NOT NULL,
    num_andares INT NOT NULL,
    ap_por_andar INT NOT NULL,
    FOREIGN KEY (edificacao_id) REFERENCES aula6.edificacao(id) ON DELETE CASCADE
);

CREATE TABLE aula6.casa (
    id SERIAL PRIMARY KEY,
    edificacao_id INT NOT NULL,
    condominio BOOLEAN NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    FOREIGN KEY (edificacao_id) REFERENCES aula6.edificacao(id) ON DELETE CASCADE
);

CREATE TABLE aula6.casa_sobrado (
    id SERIAL PRIMARY KEY,
    casa_id INT NOT NULL,
    num_andares INT NOT NULL,
    FOREIGN KEY (casa_id) REFERENCES aula6.casa(id) ON DELETE CASCADE
);

CREATE TABLE aula6.unidade_residencial (
    id SERIAL PRIMARY KEY,
    edificacao_id INT NOT NULL,
    metragem_unidade FLOAT NOT NULL,
    num_quartos INT NOT NULL,
    num_banheiros INT NOT NULL,
    proprietario_id INT NOT NULL,
    FOREIGN KEY (edificacao_id) REFERENCES aula6.edificacao(id) ON DELETE CASCADE,
    FOREIGN KEY (proprietario_id) REFERENCES aula6.pessoa(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS aula6.engenheiro;
DROP TABLE IF EXISTS aula6.pessoa;
DROP TABLE IF EXISTS aula6.edificacao;
DROP TABLE IF EXISTS aula6.predio;
DROP TABLE IF EXISTS aula6.casa;
DROP TABLE IF EXISTS aula6.casa_sobrado;
DROP TABLE IF EXISTS aula6.unidade_residencial;


INSERT INTO aula6.engenheiro (id, nome, crea) VALUES
    (1, 'Engenheiro A', 1234),
    (2, 'Engenheiro B', 5678),
    (3, 'Engenheiro C', 9101),
    (4, 'Engenheiro D', 1213),
    (5, 'Engenheiro E', 1415),
    (6, 'Engenheiro F', 1617),
    (7, 'Engenheiro G', 1819),
    (8, 'Engenheiro H', 2021),
    (9, 'Engenheiro I', 2223),
    (10, 'Engenheiro J', 2425);

INSERT INTO aula6.pessoa (id, nome, cpf) VALUES
    (1, 'Pessoa 1', '111.111.111-11'),
    (2, 'Pessoa 2', '222.222.222-22'),
    (3, 'Pessoa 3', '333.333.333-33'),
    (4, 'Pessoa 4', '444.444.444-44'),
    (5, 'Pessoa 5', '555.555.555-55'),
    (6, 'Pessoa 6', '666.666.666-66'),
    (7, 'Pessoa 7', '777.777.777-77'),
    (8, 'Pessoa 8', '888.888.888-88'),
    (9, 'Pessoa 9', '999.999.999-99'),
    (10, 'Pessoa 10', '000.000.000-00');

INSERT INTO aula6.edificacao (id, metragem_total, endereco, engenheiro_id, tipo) VALUES
    (1, 100.0, 'Rua A, 123', 1, 'Apartamento'),
    (2, 200.0, 'Rua B, 456', 2, 'Casa'),
    (3, 300.0, 'Rua C, 789', 3, 'Casa'),
    (4, 400.0, 'Rua D, 012', 4, 'Apartamento'),
    (5, 500.0, 'Rua E, 345', 5, 'Casa'),
    (6, 600.0, 'Rua F, 678', 6, 'Apartamento'),
    (7, 700.0, 'Rua G, 901', 7, 'Casa'),
    (8, 800.0, 'Rua H, 234', 8, 'Casa'),
    (9, 900.0, 'Rua I, 567', 9, 'Apartamento'),
    (10, 1000.0, 'Rua J, 890', 10, 'Casa');

INSERT INTO aula6.predio (id, edificacao_id, nome, num_andares, ap_por_andar) VALUES
    (1, 1, 'Predio 1', 5, 10),
    (2, 2, 'Predio 2', 3, 8),
    (3, 3, 'Predio 3', 4, 12),
    (4, 4, 'Predio 4', 6, 6),
    (5, 5, 'Predio 5', 2, 20),
    (6, 6, 'Predio 6', 7, 4),
    (7, 7, 'Predio 7', 3, 15),
    (8, 8, 'Predio 8', 5, 10),
    (9, 9, 'Predio 9', 4, 8),
    (10, 10, 'Predio 10', 6, 6);

INSERT INTO aula6.casa (id, edificacao_id, condominio, tipo) VALUES
    (1, 1, true, 'Casa 1'),
    (2, 2, false, 'Casa 2'),
    (3, 3, true, 'Casa 3'),
    (4, 4, false, 'Casa 4'),
    (5, 5, true, 'Casa 5'),
    (6, 6, false, 'Casa 6'),
    (7, 7, true, 'Casa 7'),
    (8, 8, false, 'Casa 8'),
    (9, 9, true, 'Casa 9'),
    (10, 10, false, 'Casa 10');

INSERT INTO aula6.casa_sobrado (id, casa_id, num_andares) VALUES
    (1, 1, 2),
    (2, 2, 3),
    (3, 3, 4),
    (4, 4, 5),
    (5, 5, 6),
    (6, 6, 7),
    (7, 7, 8),
    (8, 8, 9),
    (9, 9, 10),
    (10, 10, 11);

INSERT INTO aula6.unidade_residencial (id, edificacao_id, metragem_unidade, num_quartos, num_banheiros, proprietario_id) VALUES
    (1, 1, 100.0, 2, 1, 1),
    (2, 2, 200.0, 3, 2, 2),
    (3, 3, 300.0, 4, 3, 3),
    (4, 4, 400.0, 5, 4, 4),
    (5, 5, 500.0, 6, 5, 5),
    (6, 6, 600.0, 7, 6, 6),
    (7, 7, 700.0, 8, 7, 7),
    (8, 8, 800.0, 9, 8, 8),
    (9, 9, 900.0, 10, 9, 9),
    (10, 10, 1000.0, 11, 10, 10);

-- Listar todas as unidades residenciais com seus proprietários e endereços
SELECT
    ur.id,
    ur.metragem_unidade,
    ur.num_quartos,
    ur.num_banheiros,
    p.nome AS proprietario,
    e.endereco
FROM aula6.unidade_residencial ur
JOIN aula6.pessoa p ON ur.proprietario_id = p.id
JOIN aula6.edificacao e ON ur.edificacao_id = e.id

-- Listar todas as unidades residenciais com seus proprietários e endereços , ordenando por metragem da unidade
SELECT
    ur.id,
    ur.metragem_unidade,
    ur.num_quartos,
    ur.num_banheiros,
    p.nome AS proprietario,
    e.endereco
FROM aula6.unidade_residencial ur
JOIN aula6.pessoa p ON ur.proprietario_id = p.id
JOIN aula6.edificacao e ON ur.edificacao_id = e.id
ORDER BY ur.metragem_unidade;