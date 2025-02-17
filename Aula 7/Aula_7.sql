--- Função
--- Função são blocos de codigo que podem ser chamados para executar uma tarefa especifica.

-- Funções aceitam parâmetros e podem retornar valores.

-- Funções podem ser declaradas com ou sem retorno.

-- Funções podem ser definidas pelo usuario ou podem ser funções embutidas. (Nativa do Banco de Dados)

--- 3 tipos de funções embutidas: Matematica, Data e String

-- ================= FUNÇÕES MATEMÁTICAS ====================
SELECT ABS(-10); -- Retorna o valor absoluto de um numero
SELECT ROUND(10.5); -- Retorna o valor arredondado de um numero
SELECT TRUNCATE(10.5, 1); -- Retorna o valor truncado de um numero com casas decimais (truncado = arredondado para baixo)
SELECT POWER(2, 3); -- Retorna o valor de um numero elevado a um outro
SELECT LN(4); -- Retorna o logaritmo natural de um numero
SELECT COS(30); -- Retorna o cosseno de um angulo
SELECT ATAN(0.5); -- Retorna o arctangente de um numero
SELECT ASINH(0.5); -- Retorna o arco seccao hiperbolica de um numero
SELECT SIGN(-50); -- Retorna o sinal de um numero

-- ================= FUNÇÕES DE STRING ====================
SELECT CONCAT('Ola ', 'mundo!'); -- Concatena strings
SELECT REPLACE('Ola mundo!', 'mundo', 'galaxia'); -- Substitui uma string por outra
SELECT SUBSTRING('Ola mundo!', 1, 5); -- Retorna uma parte de uma string
SELECT UPPER('ola mundo!'); -- Converte uma string para maiuscula
SELECT LOWER('OLA MUNDO!'); -- Converte uma string para minuscula
SELECT LENGTH('ola mundo!'); -- Retorna o tamanho de uma string
SELECT TRIM('   Ola mundo!   '); -- Remove espacos em branco de uma string
SELECT LPAD('Ola mundo!', 20, '*'); -- Adiciona espacos em branco a esquerda de uma string
SELECT RPAD('Ola mundo!', 20, '*'); -- Adiciona espacos em branco a direita de uma string
SELECT REVERSE('Ola mundo!'); -- Inverte a ordem dos caracteres de uma string

-- ================= FUNÇÕES DE DATA ====================
SELECT CURRENT_DATE; -- Retorna a data atual
SELECT NOW(); -- Retorna a data e hora atual
SELECT EXTRACT(YEAR FROM '2023-01-01'); -- Retorna o ano de uma data
SELECT EXTRACT(MONTH FROM '2023-01-01'); -- Retorna o mes de uma data
SELECT EXTRACT(DAY FROM '2023-01-01'); -- Retorna o dia de uma data
SELECT EXTRACT(DAY FROM CURRENT_DATE); -- Retorna o dia da semana de uma data
SELECT AGE('2023-01-01', '2022-01-01'); -- Retorna a idade de uma data
SELECT INTERVAL '1' DAY; -- Retorna um intervalo de tempo em dias

-- ================= FUNÇÕES DE AGREGAÇÃO ====================
SELECT COUNT(*) FROM tabela; -- Retorna o numero de linhas de uma tabela
SELECT SUM(coluna) FROM tabela; -- Retorna a soma de uma coluna de uma tabela
SELECT AVG(coluna) FROM tabela; -- Retorna a media de uma coluna de uma tabela
SELECT MIN(coluna) FROM tabela; -- Retorna o menor valor de uma coluna de uma tabela
SELECT MAX(coluna) FROM tabela; -- Retorna o maior valor de uma coluna de uma tabela

-- ================= FUNÇÕES DO USUARIO ====================
-- Cria uma funcao
CREATE FUNCTION soma(a INT, b INT) RETURNS INT AS $$
    BEGIN -- Inicia a funcao
        -- Corpo da funcao
        RETURN a + b; 
    END; -- Finaliza a funcao
$$ LANGUAGE plpgsql; -- Define o tipo de linguagem da funcao

-- Chama a funcao
SELECT soma(2, 3);

-- Operação de Insert nas funções
CREATE OR REPLACE FUNCTION insere_partida(id INTEGER, time_1 INTEGER, time_2 INTEGER, time_1_gols INTEGER, time_2_gols INTEGER) RETURNS VOID AS $$
    BEGIN
        INSERT INTO aula7.partida(id, time_1, time_2, time_1_gols, time_2_gols) VALUES (id, time_1, time_2, time_1_gols, time_2_gols);
    END;
$$ LANGUAGE plpgsql;

-- Chama a funcao
SELECT insere_partida(9, 1, 2, 2, 1);

-- Função de consulta
CREATE OR REPLACE FUNCTION consulta_time() RETURNS SETOF aula7.time as $$
BEGIN
    RETURN QUERY SELECT * FROM aula7.time;
END;
$$ LANGUAGE plpgsql;

-- Chama a funcao
SELECT consulta_time();

-- Função com variavel interna
CREATE OR REPLACE FUNCTION consulta_vencedor_por_time(id_time INTEGER) RETURNS VARCHAR(50) AS $$
DECLARE
    vencedor VARCHAR(50);
BEGIN
    SELECT CASE 
        WHEN aula7.time_1_gols > time_2_gols THEN (SELECT nome FROM aula7.time WHERE id = time_1)
        WHEN aula7.time_1_gols < aula7.time_2_gols THEN (SELECT nome FROM aula7.time WHERE id = time_2)
        ELSE 'EMPATE'
    END INTO vencedor
    from aula7.partida where time_1 = id_time or time_2 = id_time;
    RETURN vencedor;
END;
$$ LANGUAGE plpgsql;

-- Chama a funcao
SELECT consulta_vencedor_por_time(1);