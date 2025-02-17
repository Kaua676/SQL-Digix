CREATE TABLE aula7.time (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE aula7.partida (
    id INTEGER PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES time(id),
    FOREIGN KEY(time_2) REFERENCES time(id)
);

INSERT INTO aula7.time(id, nome)
VALUES (1, 'CORINTHIANS'),
    (2, 'SÃO PAULO'),
    (3, 'CRUZEIRO'),
    (4, 'ATLETICO MINEIRO'),
    (5, 'PALMEIRAS');

INSERT INTO aula7.partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES (1, 4, 1, 0, 4),
    (2, 3, 2, 0, 1),
    (3, 1, 3, 3, 0),
    (4, 3, 4, 0, 1),
    (5, 1, 2, 0, 0),
    (6, 2, 4, 2, 2),
    (7, 1, 5, 1, 2),
    (8, 5, 2, 1, 2);

-- 1. Crie uma view vpartida que retorne a tabela de partida adicionando as colunas nome_time_1 e nome_time_2 com o nome dos times.
CREATE OR REPLACE VIEW aula7.vpartida AS
SELECT p.id, t1.nome as time_1, t2.nome as time_2, p.time_1_gols, p.time_2_gols
FROM aula7.partida p
JOIN aula7.time t1 ON p.time_1 = t1.id
JOIN aula7.time t2 ON p.time_2 = t2.id
ORDER BY p.id;

SELECT * FROM aula7.vpartida;

-- 2. Realize uma consulta em vpartida que retorne somente os jogos times que possuem nome que começam com A ou C participaram.
SELECT id, time_1, time_2
FROM aula7.vpartida
WHERE time_1 LIKE 'A%' OR time_1 LIKE 'C%'
   OR time_2 LIKE 'A%' OR time_2 LIKE 'C%';

-- 3. Crie uma view, utilizando a view vpartida que retorne uma coluna de classificacao com o nome do ganhador da partida, ou a palavra 'EMPATE' em caso de empate.
CREATE OR REPLACE VIEW aula7.vpartida_classificacao AS
SELECT p.id, t1.nome as time_1, t2.nome as time_2, p.time_1_gols, p.time_2_gols,
CASE
    WHEN p.time_1_gols > p.time_2_gols THEN t1.nome
    WHEN p.time_1_gols < p.time_2_gols THEN t2.nome
    ELSE 'EMPATE'
END AS classificacao
FROM aula7.partida p
JOIN aula7.time t1 ON p.time_1 = t1.id
JOIN aula7.time t2 ON p.time_2 = t2.id
ORDER BY classificacao DESC;

SELECT * FROM aula7.vpartida_classificacao;

-- 4. Crie uma view vtime que retorne a tabela de time adicionando as colunas partidas, vitorias, derrotas, empates e pontos.
CREATE OR REPLACE VIEW aula7.vtime AS
SELECT t.id, t.nome,
(SELECT COUNT(time_1) FROM aula7.partida WHERE time_1 = t.id) + (SELECT COUNT(time_2) FROM aula7.partida WHERE time_2 = t.id) AS partidas,
-- Vitorias
(SELECT SUM (CASE WHEN time_1_gols > time_2_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_1 = t.id) + 
(SELECT SUM (CASE WHEN time_2_gols > time_1_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_2 = t.id) AS vitorias,
-- Derrotas
(SELECT SUM (CASE WHEN time_1_gols < time_2_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_1 = t.id) + 
(SELECT SUM (CASE WHEN time_2_gols < time_1_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_2 = t.id) AS derrotas,
-- Empates
(SELECT SUM (CASE WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_1 = t.id) + 
(SELECT SUM (CASE WHEN time_2_gols = time_1_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_2 = t.id) AS empates,
-- Pontos
(SELECT SUM(CASE WHEN time_1_gols > time_2_gols THEN 3 WHEN time_1_gols = time_2_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_1 = t.id) +
(SELECT SUM(CASE WHEN time_2_gols > time_1_gols THEN 3 WHEN time_2_gols = time_1_gols THEN 1 ELSE 0 END) FROM aula7.partida WHERE time_2 = t.id) AS pontos
FROM aula7.time t
ORDER BY pontos DESC;

SELECT * FROM aula7.vtime;

-- 5. Realize uma consulta na view vpartida_classificacao
SELECT * FROM aula7.vpartida_classificacao;

-- 6 - Apague a view vpartida.
DROP VIEW aula7.vpartida;