CREATE TABLE time (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE partida (
    id INTEGER PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES time(id),
    FOREIGN KEY(time_2) REFERENCES time(id)
);

INSERT INTO time(id, nome)
VALUES (1, 'CORINTHIANS'),
    (2, 'SÃO PAULO'),
    (3, 'CRUZEIRO'),
    (4, 'ATLETICO MINEIRO'),
    (5, 'PALMEIRAS');

INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES (1, 4, 1, 0, 4),
    (2, 3, 2, 0, 1),
    (3, 1, 3, 3, 0),
    (4, 3, 4, 0, 1),
    (5, 1, 2, 0, 0),
    (6, 2, 4, 2, 2),
    (7, 1, 5, 1, 2),
    (8, 5, 2, 1, 2);

-- Procedure é um conjunto de instruções SQL que podem ser executadas em conjunto.

-- Criando procedure no postgresql
CREATE OR REPLACE PROCEDURE inserir_partida(id integer, time_1 integer, time_2 integer, time_1_gols integer, time_2_gols integer) AS $$
BEGIN
    INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols)
    VALUES (id, time_1, time_2, time_1_gols, time_2_gols);
END;
$$ LANGUAGE plpgsql;

-- Updateando nome do time procedure
CREATE OR REPLACE PROCEDURE update_time(id_p INTEGER, nome_p VARCHAR(50) ) AS $$
BEGIN
    UPDATE time SET nome = nome_p WHERE id = id_p;
    IF NOT FOUND id THEN
        RAISE EXCEPTION 'Time nao encontrado';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Executando procedure
CALL inserir_partida(9,1,2,2,1);

-- Atualizando nome do time
CALL update_time(50, 'Vapo');

-- Excluindo procedure
DROP PROCEDURE update_time;

-- Faça uma procedure de excluir partida com exceção caso não encontre a partida
CREATE OR REPLACE PROCEDURE excluir_partida(id_p INTEGER) AS $$
BEGIN
    DELETE FROM partida WHERE id = id_p;
    IF NOT FOUND id THEN
        RAISE EXCEPTION 'Partida nao encontrada';
    END IF;
END;
$$ LANGUAGE plpgsql;