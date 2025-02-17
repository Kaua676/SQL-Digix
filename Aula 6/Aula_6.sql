-- 1. Criar a tabela atividade primeiro
CREATE TABLE aula6.atividade(
    idatividade SERIAL PRIMARY KEY,
    nome VARCHAR(255)
);

-- 2. Criar a tabela instrutor antes de telefone_instrutor e turma
CREATE TABLE aula6.instrutor(
    idinstrutor SERIAL PRIMARY KEY,
    rg VARCHAR(255),
    nome VARCHAR(255),
    nascimento DATE,
    titulacao INT
);

-- 3. Criar a tabela telefone_instrutor (depende de instrutor)
CREATE TABLE aula6.telefone_instrutor(
    idtelefone SERIAL PRIMARY KEY,
    numero VARCHAR(255),
    tipo VARCHAR(255),
    idinstrutor INT,
    FOREIGN KEY (idinstrutor) REFERENCES aula6.instrutor(idinstrutor) ON DELETE CASCADE
);

-- 4. Criar a tabela turma (depende de instrutor e atividade)
CREATE TABLE aula6.turma(
    idturma SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    horario TIME,
    duracao INT,
    datainicio DATE,
    datafim DATE,
    idinstrutor INT,
    idatividade INT,
    FOREIGN KEY (idinstrutor) REFERENCES aula6.instrutor(idinstrutor) ON DELETE CASCADE,
    FOREIGN KEY (idatividade) REFERENCES aula6.atividade(idatividade) ON DELETE CASCADE
);

-- 5. Criar a tabela aluno (depende de turma)
CREATE TABLE aula6.aluno(
    codmatricula SERIAL PRIMARY KEY,
    idturma INT,
    FOREIGN KEY (idturma) REFERENCES aula6.turma(idturma) ON DELETE CASCADE,
    datamatricula DATE,
    nome VARCHAR(255),
    endereco TEXT,
    telefone VARCHAR(255),
    datanascimento DATE,
    altura FLOAT,
    peso FLOAT
);

-- 6. Criar a tabela chamada (depende de aluno e turma)
CREATE TABLE aula6.chamada(
    idchamada SERIAL PRIMARY KEY,
    data DATE,
    presente BOOLEAN,
    codmatricula INT,
    idturma INT,
    FOREIGN KEY (codmatricula) REFERENCES aula6.aluno(codmatricula) ON DELETE CASCADE,
    FOREIGN KEY (idturma) REFERENCES aula6.turma(idturma) ON DELETE CASCADE
);

-- 1. Inserindo 5 atividades
INSERT INTO aula6.atividade (nome) 
VALUES ('Musculação'), ('Natação'), ('Pilates'), ('Yoga'), ('Crossfit');

-- 2. Inserindo 5 instrutores
INSERT INTO aula6.instrutor (rg, nome, nascimento, titulacao) 
VALUES ('123456789', 'Carlos Silva', '1985-07-12', 1),
       ('987654321', 'Mariana Souza', '1990-04-25', 2),
       ('456123789', 'José Santos', '1982-11-10', 3),
       ('741852963', 'Fernanda Lima', '1995-02-18', 1),
       ('852369741', 'Lucas Pereira', '1988-06-30', 2);

-- 3. Inserindo 5 telefones dos instrutores
INSERT INTO aula6.telefone_instrutor (numero, tipo, idinstrutor) 
VALUES ('11987654321', 'Celular', 1),
       ('1123456789', 'Residencial', 1),
       ('11976543210', 'Celular', 2),
       ('11988887777', 'Celular', 3),
       ('1133334444', 'Comercial', 4);

-- 4. Inserindo 5 turmas
INSERT INTO aula6.turma (nome, horario, duracao, datainicio, datafim, idinstrutor, idatividade) 
VALUES ('Turma A - Manhã', '08:00:00', 60, '2025-03-01', '2025-06-30', 1, 1),
       ('Turma B - Tarde', '15:00:00', 90, '2025-03-01', '2025-06-30', 2, 2),
       ('Turma C - Noite', '19:00:00', 75, '2025-03-01', '2025-06-30', 3, 3),
       ('Turma D - Manhã', '10:00:00', 60, '2025-03-01', '2025-06-30', 4, 4),
       ('Turma E - Tarde', '14:30:00', 80, '2025-03-01', '2025-06-30', 5, 5);

-- 5. Inserindo 5 alunos
INSERT INTO aula6.aluno (idturma, datamatricula, nome, endereco, telefone, datanascimento, altura, peso) 
VALUES (1, '2025-02-10', 'João Pedro', 'Rua das Flores, 123', '11987654321', '2005-09-15', 1.75, 70.5),
       (2, '2025-02-11', 'Ana Clara', 'Av. Paulista, 456', '11976543210', '2006-06-20', 1.68, 60.2),
       (3, '2025-02-12', 'Bruno Fernandes', 'Rua das Palmeiras, 789', '11999887766', '2004-12-05', 1.80, 75.3),
       (4, '2025-02-13', 'Gabriela Souza', 'Av. Central, 987', '11977776655', '2003-08-30', 1.65, 55.7),
       (5, '2025-02-14', 'Lucas Mendes', 'Rua do Sol, 321', '11966665544', '2007-03-22', 1.72, 68.9);

-- 6. Inserindo 5 chamadas (frequência dos alunos)
INSERT INTO aula6.chamada (data, presente, codmatricula, idturma) 
VALUES ('2025-03-02', TRUE, 1, 1),
       ('2025-03-02', FALSE, 2, 2),
       ('2025-03-02', TRUE, 3, 3),
       ('2025-03-02', TRUE, 4, 4),
       ('2025-03-02', FALSE, 5, 5);



DROP TABLE IF EXISTS aula6.telefone_instrutor CASCADE;
DROP TABLE IF EXISTS aula6.chamada CASCADE;
DROP TABLE IF EXISTS aula6.aluno CASCADE;
DROP TABLE IF EXISTS aula6.turma CASCADE;
DROP TABLE IF EXISTS aula6.instrutor CASCADE;
DROP TABLE IF EXISTS aula6.atividade CASCADE;


-- Criando uma VIEW
CREATE OR REPLACE VIEW aula6.vw_alunos AS
SELECT a.nome as ALUNO, t.idturma as TURMA
FROM aula5.aluno a
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY a.codmatricula, t.idturma
HAVING COUNT(t.idturma) > 1;

-- Chamando uma VIEW
SELECT * FROM aula6.vw_alunos;
SELECT aluno from aluno_turma;

-- Excluindo uma VIEW
DROP VIEW aula6.vw_alunos;

-- Alterando uma VIEW
CREATE OR REPLACE VIEW aula6.vw_alunos AS
SELECT a.nome as ALUNO, t.idturma as TURMA
FROM aula5.aluno a
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY a.codmatricula, t.idturma
HAVING COUNT(t.idturma) > 1;

-- Criando a VIEW da 9.
CREATE OR REPLACE VIEW aula6.vw_9_alunos AS
SELECT t.nome as TURMA, COUNT(a.codmatricula) as QTD_ALUNOS
FROM aula5.turma t
JOIN aula5.aluno a ON t.idturma = a.idturma
GROUP BY t.idturma
ORDER BY QTD_ALUNOS DESC
LIMIT 1;

-- Chamando a VIEW da 9.
SELECT * FROM aula6.vw_9_alunos;

-- View materializada
CREATE MATERIALIZED VIEW aula6.mvw_9_alunos AS
SELECT t.idturma AS turma, ROUND(AVG(EXTRACT(YEAR FROM AGE(current_date, datanascimento)))) as idade
from aula5.aluno a 
JOIN aula5.chamada c ON a.codmatricula = c.codmatricula
JOIN aula5.turma t ON c.idturma = t.idturma
GROUP BY t.idturma;

REFRESH MATERIALIZED VIEW aula6.mvw_9_alunos;

