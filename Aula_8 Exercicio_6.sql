create table if not exists aula8.Empregado (
Nome varchar(50),
Endereco varchar(500),
CPF int primary key not null,
DataNasc date,
Sexo char(10),
CartTrab int,
Salario float,
NumDep int,
CPFSup int
);

create table if not exists aula8.Departamento (
NomeDep varchar(50),
NumDep int primary key not null,
CPFGer int,
DataInicioGer date
-- FOREIGN KEY (CPFGer) REFERENCES aula8.Empregado(CPF)
);
ALTER TABLE aula8.empregado ADD FOREIGN KEY (NumDep) REFERENCES aula8.Departamento(NumDep)
ALTER TABLE aula8.departamento ADD FOREIGN KEY (CPFGer) REFERENCES aula8.Empregado(CPF)

create table if not exists aula8.Projeto (
NomeProj varchar(50),
NumProj int primary key not null,
Localizacao varchar(50),
NumDep int,
FOREIGN KEY (NumDep) REFERENCES aula8.Departamento(NumDep)
);

create table if not exists aula8.Dependente (
idDependente int primary key not null,
CPFE int,
NomeDep varchar(50),
Sexo char(10),
Parentesco varchar(50),
FOREIGN KEY (CPFE) REFERENCES aula8.Empregado(CPF)
);

create table if not exists aula8.Trabalha_Em (
CPF int,
NumProj int,
HorasSemana int,
FOREIGN KEY (CPF) REFERENCES aula8.Empregado(CPF),
FOREIGN KEY (NumProj) REFERENCES aula8.Projeto(NumProj)
);

-- Inserir os dados
INSERT INTO aula8.Departamento VALUES ('Dep1', 1, null, '1990-01-01');
INSERT INTO aula8.Departamento VALUES ('Dep2', 2, null, '1990-01-01');
INSERT INTO aula8.Departamento VALUES ('Dep3', 3, null, '1990-01-01');
INSERT INTO aula8.Empregado VALUES ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000, 1, null);
INSERT INTO aula8.Empregado VALUES ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000, 2, null);
INSERT INTO aula8.Empregado VALUES ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000, 3, null);
UPDATE aula8.Departamento SET CPFGer = 123 WHERE NumDep = 1;
UPDATE aula8.Departamento SET CPFGer = 456 WHERE NumDep = 2;
UPDATE aula8.Departamento SET CPFGer = 789 WHERE NumDep = 3;
INSERT INTO aula8.Projeto VALUES ('Proj1', 1, 'Local1', 1);
INSERT INTO aula8.Projeto VALUES ('Proj2', 2, 'Local2', 2);
INSERT INTO aula8.Projeto VALUES ('Proj3', 3, 'Local3', 3);
INSERT INTO aula8.Dependente VALUES (1, 123, 'Dep1', 'M', 'Filho');
INSERT INTO aula8.Dependente VALUES (2, 456, 'Dep2', 'F', 'Filha');
INSERT INTO aula8.Dependente VALUES (3, 789, 'Dep3', 'M', 'Filho');
INSERT INTO aula8.Trabalha_Em VALUES (123, 1, 40);
INSERT INTO aula8.Trabalha_Em VALUES (456, 2, 40);
INSERT INTO aula8.Trabalha_Em VALUES (789, 3, 40);

SELECT * FROM aula8.Empregado;
SELECT * FROM aula8.Departamento;
SELECT * FROM aula8.Projeto;
SELECT * FROM aula8.Dependente;
SELECT * FROM aula8.Trabalha_Em;

-- 1. Função que retorna o salário de um empregado dado o CPF
CREATE OR REPLACE FUNCTION obter_salario(p_cpf integer) RETURNS FLOAT AS $$
DECLARE
    v_salario FLOAT;
BEGIN
    SELECT salario INTO v_salario FROM aula8.Empregado WHERE CPF = p_cpf;
    RETURN v_salario;
END;
$$ LANGUAGE plpgsql;

-- Chamada
SELECT * FROM obter_salario(789);

-- 2. Função que retorna o nome do departamento de um empregado dado o CPF
CREATE OR REPLACE FUNCTION obter_departamento(p_cpf integer) RETURNS VARCHAR(50) AS $$
DECLARE
    v_departamento VARCHAR(50);
BEGIN
    SELECT aula8.Departamento.NomeDep INTO v_departamento FROM aula8.Empregado, aula8.Departamento WHERE aula8.Empregado.NumDep = aula8.Departamento.NumDep AND aula8.Empregado.CPF = p_cpf;
    RETURN v_departamento;
END;
$$ LANGUAGE plpgsql;

-- Chamada
SELECT * FROM obter_departamento(789);

-- 3. Função que retorna o nome do gerente de um departamento dado o NumDep
CREATE OR REPLACE FUNCTION obter_gerente(p_numdep integer) RETURNS VARCHAR(50) AS $$
DECLARE
    v_gerente VARCHAR(50);
BEGIN 
    SELECT aula8.Empregado.Nome INTO v_gerente FROM aula8.Departamento, aula8.Empregado WHERE aula8.Departamento.CPFGer = aula8.Empregado.CPF AND aula8.Departamento.NumDep = p_numdep;
    RETURN v_gerente;
END;
$$ LANGUAGE plpgsql;

-- Chamada
SELECT * FROM obter_gerente(2);

-- 4. Função que retorna o nome do projeto de um empregado dado o CPF
CREATE OR REPLACE FUNCTION obter_projeto(p_cpf integer) RETURNS VARCHAR(50) AS $$
DECLARE
    v_projeto VARCHAR(50);
BEGIN
    SELECT aula8.Projeto.NomeProj INTO v_projeto FROM aula8.Empregado, aula8.Projeto WHERE aula8.Empregado.NumDep = aula8.Projeto.NumDep AND aula8.Empregado.CPF = p_cpf;
    RETURN v_projeto;
END;
$$ LANGUAGE plpgsql;

-- Chamada
SELECT * FROM obter_projeto(789);

-- 5. Função que retorna o nome do dependente de um empregado dado o CPF
CREATE OR REPLACE FUNCTION obter_dependente(p_cpf integer) RETURNS VARCHAR(50) AS $$
DECLARE
    

-- 6. Função que retorna o nome do gerente de um empregado dado o CPF

-- 7. Função que retorna a quantidade de horas que um empregado trabalha em um projeto dado o CPF

-- 8. Função com Exception que retorna o salário de um empregado dado o CPF