-- Criar tabela usuario
create table usuario ( 
	id serial primary key not null,
	nome varchar(50),
    email varchar(50)
);

-- Criar tabela cargo
create table cargo ( 
	id int primary key not null,
    nome varchar(50),
    fk_usuario int,
    constraint fk_cargo_usuario foreign key (fk_usuario) references usuario(id)
);

-- Inserir os dados na tabela usuario
insert into usuario values (1, 'Matheus', 'matheus@matheus');
insert into usuario values (2, 'Maria', 'Maria@maria');
insert into usuario values (3, 'Joao', 'joao@joao');
insert into usuario values (4, 'Joao', 'joao@joao');
insert into usuario values (5, 'Maria', 'Maria@maria');

-- Inserir os dados na tabela cargo
insert into cargo values (1, 'Administrador', 1);
insert into cargo values (2, 'Gestor', 2);
insert into cargo values (3, 'Vendedor', 3);
insert into cargo values (4, 'Analista', 4);
insert into cargo values (6, 'Gestor', 2);


-- Consultar tabela usuario
SELECT * FROM usuario;

-- Consultar tabela cargo
SELECT * FROM cargo;

-- Imprimir somente o nome da coluna da tabela cargo
select cargo.nome from cargo;

-- Imprimir somente o id da coluna da tabela cargo
select cargo.id from cargo;

-- Abreviação de nome da tabela
select c.nome from cargo c;
select c.nome, u.nome from cargo c, usuario u;

-- Aplicação de condições
select * from cargo where id = 1; -- Imprime todos os cargos com o id 1

select * from cargo where id = 1 and nome = 'Administrador'; -- Imprime todos os cargos com o id 1 e o nome Administrador

select * from cargo where id = 1 or nome = 'Administrador'; -- Imprime todos os cargos com o id 1 ou o nome Administrador

select * from cargo where id = 1 or id = 2; -- Imprime todos os cargos com o id 1 ou o id 2

select * from cargo where id in (1,2,3); -- Imprime todos os cargos de id 1 a 3

select * FROM cargo where id NOT IN (1,2,3); -- Imprime todos os cargos que não sejam de id 1 a 3

select * from cargo where id between 1 and 3; -- Imprime todos os cargos com o id entre 1 e 3

----- Ou seja, in = dentro, not in = fora, between = entre, and = e, or = ou. -----

-- Operadores de pesquisa like
select * from cargo where nome like 'A%'; -- Imprime todos os cargos que comece com a letra A

select * from cargo where nome like '%a'; -- Imprime todos os cargos que termine com a letra a

select * from cargo where nome like '%a%'; -- Imprime todos os cargos que contenham a letra a

-- Operadores de comparação
select * from cargo where id > 1; -- Imprime todos os cargos com o id maior que 1

select * from cargo where id < 1; -- Imprime todos os cargos com o id menor que 1

select * from cargo where id >= 1; -- Imprime todos os cargos com o id maior ou igual que 1

select * from cargo where id <= 1; -- Imprime todos os cargos com o id menor ou igual que 1

select * from cargo where id != 1; -- Imprime todos os cargos com o id diferente de 1

select * from cargo where id > 1 and id < 3; -- Imprime todos os cargos com o id maior que 1 e menor que 3

-- Operadores de ordenação
select * from usuario order by nome; -- Imprime todos os cargos em ordem crescente de id

select * from cargo order by id desc; -- Imprime todos os cargos em ordem decrescente de id


-- Limitar os resultados
select * from cargo limit 2; -- Imprime os dois primeiros cargos

select * from cargo limit 2 offset 2; -- Imprime os dois primeiros cargos a partir do terceiro cargo

-- Operador de agrupamento
select c.nome, u.nome from usuario u, cargo c where u.id = c.fk_usuario group by c.nome, u.id; -- Imprime todos os cargos agrupados por nome

select u.nome, count(c.id) from usuario u, cargo c where u.id = c.fk_usuario group by c.fk_usuario, u.id; -- Imprime todos os cargos agrupados por nome e conta quantos cargos tem por nome

