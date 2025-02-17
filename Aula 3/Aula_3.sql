drop table public.cargo, public.departamento, public.dependente, public.empregado, public.projeto;

-- 1. Criar a tabela EMPREGADO primeiro
create table aula3.Empregado (
    Nome varchar(50),
    Endereco varchar(500),
    CPF int primary key not null,
    DataNasc date,
    Sexo char(10),
    CartTrab int,
    Salario float,
    NumDep int,
    CPFSup int,
    foreign key (CPFSup) references aula3.Empregado(CPF) -- Auto-relacionamento (supervisor)
);

-- 2. Criar a tabela DEPARTAMENTO
create table aula3.Departamento (
    NomeDep varchar(50),
    NumDep int primary key not null,
    CPFGer int,
    DataInicioGer date,
    foreign key (CPFGer) references aula3.Empregado(CPF) -- FK para o gerente do departamento
);

-- 3. Adicionar a FK em EMPREGADO para referenciar o Departamento
alter table aula3.Empregado 
    add constraint fk_numdep foreign key (NumDep) references aula3.Departamento(NumDep);

-- 4. Criar a tabela PROJETO (já pode ser criada porque Departamento já existe)
create table aula3.Projeto (
    NomeProj varchar(50),
    NumProj int primary key not null,
    Localizacao varchar(50),
    NumDep int,
    foreign key (NumDep) references aula3.Departamento(NumDep) -- FK para o departamento responsável pelo projeto
);

-- 5. Criar a tabela TRABALHA_EM (precisa de EMPREGADO e PROJETO)
create table aula3.Trabalha_Em (
    CPF int,
    NumProj int,
    HorasSemana int,
    foreign key (CPF) references aula3.Empregado(CPF),
    foreign key (NumProj) references aula3.Projeto(NumProj)
);

-- 6. Criar a tabela DEPENDENTE (precisa de EMPREGADO)
create table aula3.Dependente (
    idDependente int primary key not null,
    CPFE int,
    NomeDep varchar(50),
    Sexo char(10),
    Parentesco varchar(50),
    foreign key (CPFE) references aula3.Empregado(CPF) -- FK para o empregado responsável pelo dependente
);

-- Inseriri os dados
insert into Departamento values ('Dep1', 1, null, '1990-01-01'); 
insert into Departamento values ('Dep2', 2, null, '1990-01-01');
insert into Departamento values ('Dep3', 3, null, '1990-01-01');
insert into Departamento values ('Dep2', 4, null, '1990-01-01');

insert into Empregado values ('Joao', 'Rua 1', 123, '1990-01-01', 'M', 123, 1000, 1, null);
insert into Empregado values ('Maria', 'Rua 2', 456, '1990-01-01', 'F', 456, 2000, 2, null);
insert into Empregado values ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 3000, 3, null);
insert into Empregado values ('Jose', 'Rua 3', 789, '1990-01-01', 'M', 789, 5000, 4, null);

-- Fazer o update para atualizar o CPFGer dos departamentos
update Departamento set CPFGer = 123 where NumDep = 1;
update Departamento set CPFGer = 456 where NumDep = 2;
update Departamento set CPFGer = 789 where NumDep = 3;

insert into Projeto values ('Proj1', 1, 'Local1', 1);
insert into Projeto values ('Proj2', 2, 'Local2', 2);
insert into Projeto values ('Proj3', 3, 'Local3', 3);
insert into Projeto values ('Proj4', 4, 'Local4', 4);

insert into Dependente values (1, 123, 'Dep1', 'M', 'Filho');
insert into Dependente values (2, 456, 'Dep2', 'F', 'Filha');
insert into Dependente values (3, 789, 'Dep3', 'M', 'Filho');


insert into Trabalha_Em values (123, 1, 40);
insert into Trabalha_Em values (456, 2, 40);
insert into Trabalha_Em values (789, 3, 40);
INSERT INTO Trabalha_Em VALUES (999, 1, 40);
INSERT INTO Trabalha_Em VALUES (979, 2, 40);


-- Consulta tudo
select * from aula3.Empregado;
SELECT * FROM aula3.Departamento;
SELECT * FROM aula3.Projeto;
SELECT * FROM aula3.Dependente;
SELECT * FROM aula3.Trabalha_Em;

-- Substrings, com posições especificas de caracteres
select nomeproj from projeto where nomeproj like 'P____';

-- Diferença de aspas simples e duplas: as simples pegam strings. As duplas são para identificar o nome da tabela, coluna, etc...
select e.Nome from Empregado e where e.Nome like 'J%';
select "nome" from Empregado e where "nome" like 'J%';

-- Operadores na propria coluna
select e.Nome, e.Salario * 1.1 from Empregado e;

-- Colocar nome referencia na operação usando o As
select e.Nome, e.Salario * 1.1 as SalarioAtualizado from Empregado e;

-- O uso do Distinc é para evitar duplicatas
select distinct e.Nome, e.CPF from Empregado e, Trabalha_Em t where e.CPF = t.CPF;

-- Utilizar UNION que é a união de 2 consultas
-- 2. Listar os números de projetos nos quais esteja envolvido o empregado 'Joao da Silva' como empregado ou como gerente responsável pelo departamento que controla o projeto
(select distinct NumProj from Projeto p, Departamento d, Empregado e where p.NumDep = d.NumDep and d.CPFGer = e.CPF and e.Nome = 'Joao')
UNION
(select p.NumProj from Projeto p, Trabalha_Em t, Empregado e where p.NumProj = t.NumProj and t.CPF = e.CPF and e.Nome = 'Joao');

-- Uso do Intersect
-- Listando os nomes dos empregados que também são gerentes
select e.Nome from Empregado e
Intersect
select e.Nome from Empregado e, Departamento d where d.CPFGer = e.CPF;

-- Uso is null, para imprimir registros que tem nulo em certa coluna
select e.Nome from Empregado e where e.CPFSup is not null; -- não é nulo
select e.Nome from Empregado e where e.CPFSup is null; -- é nulo

-- Funções que já estão nativas do SQL

-- Média
select avg(e.Salario) from Empregado e;

-- Contagem
select count(*) from Empregado e;

-- Soma
select sum(e.Salario) from Empregado e;

-- Maior
select max(e.Salario) from Empregado e;

-- Menor
select min(e.Salario) from Empregado e;

----- Selecionar o CPF de todos os empregados que trabalham no mesmo projeto e com a mesma quantidade de horas que o empregado cujo CPF é 123.

select distinct t.CPF from Trabalha_Em t where t.NumProj in (select t2.NumProj from Trabalha_Em t2 where t2.CPF = 123) and t.HorasSemana = (select t2.HorasSemana from Trabalha_Em t2 where t2.CPF = 123);

-- Resolução alternativa
select distinct CPF 
from Trabalha_Em 
where (NumProj, HorasSemana) in -- o in é para verificar se o resultado está na subconsulta
(select NumProj, HorasSemana from Trabalha_Em where CPF = 123);

----- Selecionar o nome de todos os empregados que têm salário maior que todos os salários dos empregados do departamento 2

select e.nome from Empregado e where e.Salario > all (select e2.Salario from Empregado e2 where e2.NumDep = 2);