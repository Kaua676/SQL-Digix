CREATE TABLE aula4.horario (
    idhorario SERIAL PRIMARY KEY,
    horario TIME        
);

CREATE TABLE aula4.sala (
    idsala SERIAL PRIMARY KEY,
    capacidade INT,
    nome VARCHAR(255)
);

CREATE TABLE aula4.premiacao (
    idpremiacao SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    ano INT
);

CREATE TABLE aula4.diretor (
    iddiretor SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE aula4.genero (
    idgenero SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE aula4.funcao (
    idfuncao SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE aula4.funcionario (
    idfuncionario SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    carteiratrabalho INT UNIQUE,
    datacontratacao DATE,
    salario FLOAT
);

CREATE TABLE aula4.filme (
    idfilme SERIAL PRIMARY KEY,
    nomeBR VARCHAR(255),
    nomeEN VARCHAR(255),
    anoLancamento INT,
    iddiretor INT NOT NULL,
    idgenero INT NOT NULL,
    sinopse TEXT,
    FOREIGN KEY (iddiretor) REFERENCES aula4.diretor(iddiretor) ON DELETE CASCADE,
    FOREIGN KEY (idgenero) REFERENCES aula4.genero(idgenero) ON DELETE CASCADE
);

CREATE TABLE aula4.horario_trabalho_funcionario (
    id SERIAL PRIMARY KEY, 
    horario_idhorario INT NOT NULL,
    funcionario_idfuncionario INT NOT NULL,
    funcao_idfuncao INT NOT NULL,
    FOREIGN KEY (horario_idhorario) REFERENCES aula4.horario(idhorario) ON DELETE CASCADE,
    FOREIGN KEY (funcionario_idfuncionario) REFERENCES aula4.funcionario(idfuncionario) ON DELETE CASCADE,
    FOREIGN KEY (funcao_idfuncao) REFERENCES aula4.funcao(idfuncao) ON DELETE CASCADE
);

CREATE TABLE aula4.filme_exibido_sala (
    id SERIAL PRIMARY KEY,  
    filme_idfilme INT NOT NULL,
    sala_idsala INT NOT NULL,
    horario_idhorario INT NOT NULL,
    FOREIGN KEY (filme_idfilme) REFERENCES aula4.filme(idfilme) ON DELETE CASCADE,
    FOREIGN KEY (sala_idsala) REFERENCES aula4.sala(idsala) ON DELETE CASCADE,
    FOREIGN KEY (horario_idhorario) REFERENCES aula4.horario(idhorario)ON DELETE CASCADE
);

CREATE TABLE aula4.filme_has_premiacao (
    id SERIAL PRIMARY KEY,  
    filme_idfilme INT NOT NULL,
    premiacao_idpremiacao INT NOT NULL,
    ganhou BOOLEAN,
    FOREIGN KEY (filme_idfilme) REFERENCES aula4.filme(idfilme) ON DELETE CASCADE,
    FOREIGN KEY (premiacao_idpremiacao) REFERENCES aula4.premiacao(idpremiacao) ON DELETE CASCADE
);

-- Inserindo horários
INSERT INTO aula4.horario (horario) VALUES 
    ('08:00:00'),
    ('09:00:00'),
    ('10:00:00'),
    ('11:00:00'),
    ('12:00:00');

-- Inserindo salas
INSERT INTO aula4.sala (capacidade, nome) VALUES 
    (100, 'Sala 1'),
    (200, 'Sala 2'),
    (300, 'Sala 3'),
    (400, 'Sala 4'),
    (500, 'Sala 5');

-- Inserindo premiações
INSERT INTO aula4.premiacao (nome, ano) VALUES 
    ('Oscar', 2023),
    ('Golden Globes', 2023),
    ('BAFTA', 2023),
    ('Cannes', 2022),
    ('Emmy', 2021);

-- Inserindo diretores
INSERT INTO aula4.diretor (nome) VALUES 
    ('Quentin Tarantino'),
    ('Steven Spielberg'),
    ('Martin Scorsese'),
    ('Christopher Nolan'),
    ('James Cameron');

-- Inserindo gêneros
INSERT INTO aula4.genero (nome) VALUES 
    ('Aventura'),
    ('Drama'),
    ('Comédia'),
    ('Ação'),
    ('Ficção Científica');

-- Inserindo funções
INSERT INTO aula4.funcao (nome) VALUES 
    ('Diretor'),
    ('Ator'),
    ('Atriz'),
    ('Produtor'),
    ('Roteirista');

-- Inserindo funcionários
INSERT INTO aula4.funcionario (nome, carteiratrabalho, datacontratacao, salario) VALUES 
    ('John Doe', 123456789, '2023-01-01', 5000.00),
    ('Jane Doe', 987654321, '2023-02-01', 6000.00),
    ('Bob Smith', 555555555, '2023-03-01', 7000.00),
    ('Alice Brown', 444444444, '2023-04-01', 5500.00),
    ('Charlie White', 333333333, '2023-05-01', 6500.00);

-- Inserindo filmes
INSERT INTO aula4.filme (nomeBR, nomeEN, anoLancamento, iddiretor, idgenero, sinopse) VALUES
    ('Pulp Fiction', 'Pulp Fiction', 1994, 1, 1, 'Um filme de ação e suspense.'),
    ('The Shawshank Redemption', 'The Shawshank Redemption', 1994, 2, 2, 'Um drama emocionante.'),
    ('The Matrix', 'The Matrix', 1999, 3, 5, 'Um filme de ficção científica revolucionário.'),
    ('Inception', 'Inception', 2010, 4, 4, 'Um thriller psicológico sobre sonhos.'),
    ('Avatar', 'Avatar', 2009, 5, 1, 'Uma aventura épica em um mundo alienígena.');

-- Associando filmes a salas e horários
INSERT INTO aula4.filme_exibido_sala (filme_idfilme, sala_idsala, horario_idhorario) VALUES 
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 3),
    (4, 4, 4),
    (5, 5, 5);

-- Associando filmes a premiações
INSERT INTO aula4.filme_has_premiacao (filme_idfilme, premiacao_idpremiacao, ganhou) VALUES 
    (1, 1, true),
    (2, 2, false),
    (3, 3, true),
    (4, 4, false),
    (5, 5, true);

-- Desativar temporariamente as restrições de chave estrangeira
ALTER TABLE aula4.filme_has_premiacao DISABLE TRIGGER ALL;
ALTER TABLE aula4.filme_exibido_sala DISABLE TRIGGER ALL;
ALTER TABLE aula4.horario_trabalho_funcionario DISABLE TRIGGER ALL;
ALTER TABLE aula4.filme DISABLE TRIGGER ALL;
ALTER TABLE aula4.funcionario DISABLE TRIGGER ALL;
ALTER TABLE aula4.funcao DISABLE TRIGGER ALL;
ALTER TABLE aula4.genero DISABLE TRIGGER ALL;
ALTER TABLE aula4.diretor DISABLE TRIGGER ALL;
ALTER TABLE aula4.premiacao DISABLE TRIGGER ALL;
ALTER TABLE aula4.sala DISABLE TRIGGER ALL;
ALTER TABLE aula4.horario DISABLE TRIGGER ALL;

-- Apagar os dados das tabelas e resetar os IDs
TRUNCATE TABLE aula4.filme_has_premiacao RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.filme_exibido_sala RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.horario_trabalho_funcionario RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.filme RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.funcionario RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.funcao RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.genero RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.diretor RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.premiacao RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.sala RESTART IDENTITY CASCADE;
TRUNCATE TABLE aula4.horario RESTART IDENTITY CASCADE;

-- Reativar as restrições de chave estrangeira
ALTER TABLE aula4.filme_has_premiacao ENABLE TRIGGER ALL;
ALTER TABLE aula4.filme_exibido_sala ENABLE TRIGGER ALL;
ALTER TABLE aula4.horario_trabalho_funcionario ENABLE TRIGGER ALL;
ALTER TABLE aula4.filme ENABLE TRIGGER ALL;
ALTER TABLE aula4.funcionario ENABLE TRIGGER ALL;
ALTER TABLE aula4.funcao ENABLE TRIGGER ALL;
ALTER TABLE aula4.genero ENABLE TRIGGER ALL;
ALTER TABLE aula4.diretor ENABLE TRIGGER ALL;
ALTER TABLE aula4.premiacao ENABLE TRIGGER ALL;
ALTER TABLE aula4.sala ENABLE TRIGGER ALL;
ALTER TABLE aula4.horario ENABLE TRIGGER ALL;

SELECT * FROM aula4.funcionario;
SELECT * FROM aula4.horario_trabalho_funcionario;
SELECT * FROM aula4.filme_exibido_sala;
SELECT * FROM aula4.filme_has_premiacao;
SELECT * FROM aula4.filme;
SELECT * FROM aula4.genero;
SELECT * FROM aula4.diretor;
SELECT * FROM aula4.premiacao;
SELECT * FROM aula4.sala;
SELECT * FROM aula4.horario;


-- Consultas

-- 1. Retornar a média dos salários dos funcionários.
SELECT avg(salario)
FROM aula4.funcionario;

-- 2. Listar os funcionários e suas funções, incluindo aqueles sem função definida.
SELECT f.nome AS funcionario, COALESCE(fun.nome, 'Sem Função') AS funcao
FROM aula4.funcionario f
LEFT JOIN aula4.funcao fun ON f.idfuncionario = fun.idfuncao;

-- 3. Retornar o nome de todos os funcionários que possuem o mesmo horário de trabalho que algum outro funcionário.
SELECT DISTINCT f1.nome AS funcionario1, f2.nome AS funcionario2, h.horario
FROM aula4.horario_trabalho_funcionario ht1
JOIN aula4.horario_trabalho_funcionario ht2 ON ht1.horario_idhorario = ht2.horario_idhorario AND ht1.funcionario_idfuncionario <> ht2.funcionario_idfuncionario
JOIN aula4.funcionario f1 ON ht1.funcionario_idfuncionario = f1.idfuncionario
JOIN aula4.funcionario f2 ON ht2.funcionario_idfuncionario = f2.idfuncionario
JOIN aula4.horario h ON ht1.horario_idhorario = h.idhorario;

-- 4. Encontrar filmes que foram exibidos em pelo menos duas salas diferentes.
SELECT f.nomeBR
FROM aula4.filme f
JOIN aula4.filme_exibido_sala fes ON f.idfilme = fes.filme_idfilme
GROUP BY f.idfilme
HAVING COUNT(fes.sala_idsala) > 1;

-- 5. Listar os filmes e seus respectivos gêneros, garantindo que não haja duplicatas.
SELECT f.nomeBR, g.nome
FROM aula4.filme f
JOIN aula4.genero g ON f.idgenero = g.idgenero;

-- 6. Encontrar os filmes que receberam prêmios e que tiveram exibição em pelo menos uma sala.
SELECT f.nomeBR
FROM aula4.filme f
JOIN aula4.filme_has_premiacao fhp ON f.idfilme = fhp.filme_idfilme
WHERE fhp.ganhou = true;

-- 7. Listar os filmes que não receberam nenhum prêmio.
SELECT f.nomeBR
FROM aula4.filme f
LEFT JOIN aula4.filme_has_premiacao fhp ON f.idfilme = fhp.filme_idfilme
WHERE fhp.filme_idfilme IS NULL;

-- 8. Exibir os diretores que dirigiram pelo menos dois filmes.
SELECT d.nome
FROM aula4.diretor d
JOIN aula4.filme f ON d.iddiretor = f.iddiretor
GROUP BY d.iddiretor
HAVING COUNT(f.idfilme) > 1;

--9. Listar os funcionários e os horários que trabalham, ordenados pelo horário mais cedo.
SELECT f.nome, h.horario
FROM aula4.funcionario f
JOIN aula4.horario_trabalho_funcionario ht ON f.idfuncionario = ht.funcionario_idfuncionario
JOIN aula4.horario h ON ht.horario_idhorario = h.idhorario
ORDER BY h.horario;

-- 10. Listar os filmes que foram exibidos na mesma sala em horários diferentes.
SELECT f.nomeBR, s.nome as sala
FROM aula4.filme_exibido_sala fs1
JOIN aula4.filme_exibido_sala fs2 ON fs1.sala_idsala = fs2.sala_idsala AND fs1.filme_idfilme <> fs2.filme_idfilme AND fs1.horario_idhorario <> fs2.horario_idhorario
JOIN aula4.filme f ON fs1.filme_idfilme = f.idfilme
JOIN aula4.sala s ON fs1.sala_idsala = s.idsala;

-- 11. Unir os diretores e os funcionários em uma única lista de pessoas.
(SELECT d.nome
FROM aula4.diretor d)
UNION
(SELECT f.nome
FROM aula4.funcionario f)
ORDER BY nome;

-- 12. Exibir todas as funções diferentes que os funcionários exercem e a quantidade de funcionários em cada uma.
SELECT funcao.nome AS funcao, COUNT(f.idfuncionario) AS total_funcionarios
FROM aula4.funcionario f
JOIN aula4.funcao on f.idfuncionario = funcao.idfuncao
GROUP BY funcao.nome; -- Group By é usado para agrupar linhas com base em uma ou mais colunas

-- 13. Encontrar os filmes que foram exibidos em salas com capacidade superior à média de todas as salas.
SELECT f.nomeBR
FROM aula4.filme f
JOIN aula4.filme_exibido_sala fes ON f.idfilme = fes.filme_idfilme
JOIN aula4.sala s ON fes.sala_idsala = s.idsala
WHERE s.capacidade > (SELECT AVG(capacidade) FROM aula4.sala);

SELECT f.nomeBR, s.nome as sala, s.capacidade
FROM aula4.filme_exibido_sala fs
JOIN aula4.sala s ON fs.sala_idsala = s.idsala
JOIN aula4.filme f on fs.filme_idfilme = f.idfilme
WHERE s.capacidade > (SELECT AVG (capacidade) from aula4.sala);

-- 14. Calcular o salário anual dos funcionários (considerando 12 meses).
SELECT f.nome, f.salario * 12 AS salario_anual
FROM aula4.funcionario f;

-- 15. Exibir a relação entre a capacidade da sala e o número total de filmes exibidos nela
SELECT s.nome as sala, s.capacidade, COUNT(fs.filme_idfilme) AS total_filmes,(COUNT(fs.filme_idfilme)/nullif(s.capacidade, 0)) as filmes_por_assento
FROM aula4.sala s
LEFT JOIN aula4.filme_exibido_sala fs ON s.idsala = fs.sala_idsala
GROUP BY s.idsala, s.capacidade;

