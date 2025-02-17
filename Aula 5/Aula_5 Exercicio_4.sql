CREATE TABLE aula5.telefone_instrutor(
    idtelefone SERIAL PRIMARY KEY,
    numero VARCHAR(255),
    tipo VARCHAR(255),
    idinstrutor INT,
    FOREIGN KEY (idinstrutor) REFERENCES aula5.instrutor(idinstrutor) ON DELETE CASCADE
);

CREATE TABLE aula5.instrutor(
    idinstrutor SERIAL PRIMARY KEY,
    rg VARCHAR(255),
    nome VARCHAR(255),
    nascimento DATE,
    titulacao INT
);

CREATE TABLE aula5.aluno(
    codmatricula SERIAL PRIMARY KEY,
    idturma INT,
    FOREIGN KEY (idturma) REFERENCES aula5.turma(idturma) ON DELETE CASCADE,
    datamatricula DATE,
    nome VARCHAR(255),
    endereco TEXT,
    telefone VARCHAR(255),
    datanascimento DATE,
    altura FLOAT,
    peso FLOAT
);

CREATE TABLE aula5.turma(
    idturma SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    horario TIME,
    duracao INT,
    datainicio DATE,
    datafim DATE,
    idinstrutor INT,
    idatividade INT,
    FOREIGN KEY (idinstrutor) REFERENCES aula5.instrutor(idinstrutor) ON DELETE CASCADE,
    FOREIGN KEY (idatividade) REFERENCES aula5.atividade(idatividade) ON DELETE CASCADE
);

CREATE TABLE aula5.atividade(
    idatividade SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE aula5.chamada(
    idchamada SERIAL PRIMARY KEY,
    data DATE,
    presente BOOLEAN,
    codmatricula INT,
    idturma INT,
    FOREIGN KEY (codmatricula) REFERENCES aula5.aluno(codmatricula) ON DELETE CASCADE,
    FOREIGN KEY (idturma) REFERENCES aula5.turma(idturma) ON DELETE CASCADE
);


DROP TABLE IF EXISTS aula5.telefone_instrutor CASCADE;
DROP TABLE IF EXISTS aula5.chamada CASCADE;
DROP TABLE IF EXISTS aula5.aluno CASCADE;
DROP TABLE IF EXISTS aula5.turma CASCADE;
DROP TABLE IF EXISTS aula5.instrutor CASCADE;
DROP TABLE IF EXISTS aula5.atividade CASCADE;


-- Inserindo 5 atividades
INSERT INTO aula5.atividade (nome) 
VALUES ('Musculação'), ('Natação'), ('Pilates'), ('Yoga'), ('Crossfit');

-- Inserindo 5 instrutores
INSERT INTO aula5.instrutor (rg, nome, nascimento, titulacao) 
VALUES ('123456789', 'Carlos Silva', '1985-07-12', 1),
       ('987654321', 'Mariana Souza', '1990-04-25', 2),
       ('456123789', 'José Santos', '1982-11-10', 3),
       ('741852963', 'Fernanda Lima', '1995-02-18', 1),
       ('852369741', 'Lucas Pereira', '1988-06-30', 2);

-- Inserindo 5 telefones dos instrutores
INSERT INTO aula5.telefone_instrutor (numero, tipo, idinstrutor) 
VALUES ('11987654321', 'Celular', 1),
       ('1123456789', 'Residencial', 1),
       ('11976543210', 'Celular', 2),
       ('11988887777', 'Celular', 3),
       ('1133334444', 'Comercial', 4);

-- Inserindo 5 turmas
INSERT INTO aula5.turma (nome, horario, duracao, datainicio, datafim, idinstrutor, idatividade) 
VALUES ('Turma A - Manhã', '08:00:00', 60, '2025-03-01', '2025-06-30', 1, 1),
       ('Turma B - Tarde', '15:00:00', 90, '2025-03-01', '2025-06-30', 2, 2),
       ('Turma C - Noite', '19:00:00', 75, '2025-03-01', '2025-06-30', 3, 3),
       ('Turma D - Manhã', '10:00:00', 60, '2025-03-01', '2025-06-30', 4, 4),
       ('Turma E - Tarde', '14:30:00', 80, '2025-03-01', '2025-06-30', 5, 5);

-- Inserindo 5 alunos
INSERT INTO aula5.aluno (idturma, datamatricula, nome, endereco, telefone, datanascimento, altura, peso) 
VALUES (1, '2025-02-10', 'João Pedro', 'Rua das Flores, 123', '11987654321', '2005-09-15', 1.75, 70.5),
       (2, '2025-02-11', 'Ana Clara', 'Av. Paulista, 456', '11976543210', '2006-06-20', 1.68, 60.2),
       (3, '2025-02-12', 'Bruno Fernandes', 'Rua das Palmeiras, 789', '11999887766', '2004-12-05', 1.80, 75.3),
       (4, '2025-02-13', 'Gabriela Souza', 'Av. Central, 987', '11977776655', '2003-08-30', 1.65, 55.7),
       (5, '2025-02-14', 'Lucas Mendes', 'Rua do Sol, 321', '11966665544', '2007-03-22', 1.72, 68.9),
       (6, '2025-02-10', 'Joao Batista Souza', 'Av. Central, 987', '11977776655', '2003-08-30', 1.65, 55.7);

-- Inserindo 5 chamadas (frequência dos alunos)
INSERT INTO aula5.chamada (data, presente, codmatricula, idturma) 
VALUES ('2025-03-02', TRUE, 1, 1),
       ('2025-03-02', FALSE, 2, 2),
       ('2025-03-02', TRUE, 3, 3),
       ('2025-03-02', TRUE, 4, 4),
       ('2025-03-02', FALSE, 5, 5);


--- 1️. Listar todos os alunos e os nomes das turmas em que estão matriculados 
-- (Usa JOIN para relacionar as tabelas aluno, matricula e turma.)
SELECT a.nome, t.nome
FROM aula5.aluno a
JOIN aula5.turma t ON a.idturma = t.idturma;

--- 2️. Contar quantos alunos estão matriculados em cada turma
-- ( Usa GROUP BY e COUNT() para contar os alunos por turma.)
SELECT t.nome AS turma, COUNT(t.nome) AS qtd_func
FROM aula5.turma t
JOIN aula5.aluno a ON t.idturma = a.idturma
GROUP BY t.nome;

--- 3️. Mostrar a média de idade dos alunos em cada turma
-- Usa AVG() e DATEDIFF() para calcular a idade média dos alunos.
SELECT t.idturma AS turma, ROUND(AVG(EXTRACT(YEAR FROM AGE(current_date, datanascimento)))) as idade
from aula5.aluno a 
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY t.idturma;

--- 4️. Encontrar as turmas com mais de 3️ alunos matriculados
--(Usa HAVING para filtrar apenas as turmas com mais de 3 alunos.)
SELECT t.nome
FROM aula5.turma t
JOIN aula5.aluno a ON t.idturma = a.idturma
GROUP BY t.idturma
HAVING COUNT(a.codmatricula) > 1;

--- 5️. Exibir os instrutores que orientam turmas e os que ainda não possuem turmas
SELECT i.nome AS instrutor, COALESCE(t.nome, 'Sem Turma') AS turma
FROM aula5.instrutor i
LEFT JOIN aula5.turma t ON i.idinstrutor = t.idinstrutor;

--- 6️. Encontrar alunos que frequentaram todas as aulas de sua turma
-- ( Usa COUNT() para comparar a quantidade de presenças com a quantidade de aulas.)
SELECT a.nome as ALUNO, t.idturma as TURMA
FROM aula5.aluno a
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY a.codmatricula, t.idturma
HAVING COUNT(case when c.presente = true then 1 end) = (SELECT COUNT(*) from aula5.chamada c2 where c2.idturma = t.idturma);

--- 7️. Mostrar os instrutores que ministram turmas de "Crossfit" ou "Yoga"
-- (Usa JOIN e WHERE para filtrar turmas com atividades específicas.)


--- 8️. Listar os alunos que estão matriculados em mais de uma turma
--(Usa HAVING COUNT() > 1️ para encontrar alunos matriculados em mais de uma turma.)
SELECT a.nome as ALUNO, t.idturma as TURMA
FROM aula5.aluno a
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY a.codmatricula, t.idturma
HAVING COUNT(t.idturma) > 1;

--- 9️. Encontrar as turmas que possuem a maior quantidade de alunos
-- (Usa ORDER BY e LIMIT para exibir apenas as turmas com mais alunos.)
SELECT t.nome as TURMA, COUNT(a.codmatricula) as QTD_ALUNOS
FROM aula5.turma t
JOIN aula5.aluno a ON t.idturma = a.idturma
GROUP BY t.idturma
ORDER BY QTD_ALUNOS DESC
LIMIT 1;

--- 10. Listar os alunos que não compareceram a nenhuma aula
-- (Usa NOT IN para encontrar alunos sem registros na tabela chamada.)


