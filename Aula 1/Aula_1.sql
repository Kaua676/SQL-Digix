-- Criar tabela
create table exercicio1.usuario ( 
	id serial primary key not null,
	nome varchar(50),
    email varchar(50)
);

create table cargo ( 
	id int primary key not null,
    nome varchar(50),
    fk_usuario int,
    constraint fk_cargo_usuario foreign key (fk_usuario) references usuario(id)
);

-- Consultar tabela
SELECT * FROM usuario;

-- Alterar tabela e adicionando a coluna salario --
alter table cargo add column salario decimal(10,2);
alter table cargo alter column nome type varchar(100);
alter table cargo drop column salario;

-- Excluir tabela
drop table cargo;
drop table usuario;

-- Inserir os dados
insert into usuario values (1, 'Matheus', 'matheus@matheus');
insert into usuario values (2, 'Maria', 'Maria@maria');
insert into usuario values (3, 'Joao', 'joao@joao');
insert into cargo values (1, 'Desenvolvedor', 1, 1000.00);
insert into cargo values (2, 'Desenvolvedor', 2, 3000.00);
insert into cargo values (3, 'Desenvolvedor', 3, 5000.00);

-- Alterar os dados
update cargo set salario = 1000 where id = 2;
update cargo set nome = 'Arthur das calabresas' where id = 1;

-- Deletar os dados
delete from usuario where id = 1;
delete from cargo where id = 2;

-- Left Join que retorna todos os usuarios e os cargos
select * from usuario left join cargo on usuario.id = cargo.fk_usuario;

-- Right Join que retorna todos os cargos e os usuarios
select * from cargo right join usuario on cargo.id = usuario.id;

-- Inner Join que retorna todos os cargos e os usuarios com o mesmo id
select * from cargo inner join usuario on cargo.id = usuario.id;