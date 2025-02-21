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

INSERT INTO time(id, nome) VALUES 
(1,'CORINTHIANS'), 
(2,'SÃO PAULO'), 
(3,'CRUZEIRO'), 
(4,'ATLETICO MINEIRO'),
(5,'PALMEIRAS');

INSERT INTO partida(id, time_1, time_2, time_1_gols, time_2_gols) 
VALUES 
(1,4,1,0,4), 
(2,3,2,0,1), 
(3,1,3,3,0), 
(4,3,4,0,1), 
(5,1,2,0,0), 
(6,2,4,2,2), 
(7,1,5,1,2),
(8,5,2,1,2);

-- As trigger são gatilhos automaticos que são excutandos antes ou depois de uma operação de insert, update ou delete
-- As trigger são muito utilizadas para garantir a integridade dos dados
-- Quando as trigger são nescessarias?
-- 1 - Quando é nescessario garantir a integridade dos dados
-- 2 - Quando é nescessario garantir a consistencia dos dados
-- 3 - Para validar regreas de negocio antes de inserir, atualizar ou deletar dados
-- 4 - Para automatizar tarefas que devem ser executadas

--  Para mostrar como acontece nas auditorias vou fazer uma tabela que registrar os eventos das outras
create table log_partida(
    id serial PRIMARY KEY, -- se for mysql coloca o AUTO_INCREMENT(id int PRIMARY KEY AUTO_INCREMENT)
    partida_id INTEGER,
    acao VARCHAR(20),
    data TIMESTAMP default CURRENT_TIMESTAMP -- O default CURRENT_TIMESTAMP é para pegar a data e hora atual
);

-- Criação de trigger com sintaxe MySQL
create trigger log_partida_insert
after insert on partida -- after quer dizer que acontece depois da operção nas tabelas
for each row -- para cada linha que for inserida
begin
    insert into log_partida(partida_id, acao) values ( new.id, 'INSERT'); -- new.id é o id da linha que foi inserida
end;

-- No postgresql a sintaxe é um pouco diferente
-- Ou seja a gente vai criar a função e depois a trigger que chama a função
create or replace function log_partida_insert()
returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values ( new.id, 'INSERT'); -- new.id é o id da linha que foi inserida
    return new; -- o return new é para garantir que a operacação continue normalmente e não seja interrompida
end;
$$ language plpgsql;

create trigger log_partida_insert
after insert on partida
for each row
execute function log_partida_insert();

-- Vamos testar
insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (9, 1, 2, 1, 0);

select * from log_partida;

-- Criando Trigger de Restrição (mysql)
create trigger insert_partida
before insert on partida -- before quer dizer que acontece antes da operção nas tabelas
for each row -- para cada linha que for inserida
begin 
    if new.time_1 = new.time_2 then
        signal sqlstate '45000'  -- 45000 é um erro generico que pode ser usado para qualquer tipo de erro
        -- signal sqlstate é uma função que vai gerar um erro
        set message_text = 'Não é permitido jogos entre o mesmo time'; -- set message_text é para setar a mensagem de erro
    end if;
end;

-- Criando Trigger de Restrição (postgresql)
create or replace function insert_partida()
returns trigger as $$
begin
    if new.time_1 = new.time_2 then
        raise exception 'Não é permitido jogos entre o mesmo time';
    end if;
    return new; -- o return new é para garantir que a operacação continue normalmente e não seja interrompida
end;
$$ language plpgsql;
-- Aqui a gente cria a função que vai ser chamada pela trigger

create trigger insert_partida
before insert on partida -- before quer dizer que acontece antes da operção nas tabelas
for each row -- para cada linha que for inserida
execute function insert_partida();

-- Testar 
insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (10, 1, 1, 1, 0);

-- O instead of não é suporatado pelo mysql porque ele não tem suporte para trigger de visão
-- O instead of é utilizado para fazer trigger em visões
-- No postgresql a sintaxe é a mesma
-- O instead of é utilizado para fazer trigger em visões

-- Exemplo de instead of no postgres que é unico que suporta
-- Fazer um visão
create view partidas_v as
select id, time_1, time_2, time_1_gols, time_2_gols from partida;
-- Agora quereos permitir inserções na partida_v, mas os dados reais devem ser armazenados na tabela partida, Para isso usamos o instead of
create or replace function insert_partida_v()
returns trigger as $$
begin 
    insert into partida(id, time_1, time_2, time_1_gols, time_2_gols) values (new.id, new.time_1, new.time_2, new.time_1_gols, new.time_2_gols);
    return null; -- não quero inserir na visão diretamente
end;
$$ language plpgsql;

create trigger insert_partida_v
instead of insert on partidas_v -- aqui a gente esta dizendo que a trigger vai ser executada no lugar de uma inserção na visão
for each row
execute function insert_partida_v();

-- Testar
insert into partidas_v(id, time_1, time_2, time_1_gols, time_2_gols) values (11, 1, 2, 1, 0);

-- Update
-- Mysql
create trigger update_partida
after update on partida
for each row
begin
    insert into log_partida(partida_id, acao) values ( new.id, 'UPDATE');
end;
-- Postgresql
create or replace function update_partida()
returns trigger as $$
begin
    insert into log_partida(partida_id, acao) values ( new.id, 'UPDATE');
    return new;
end;

$$ language plpgsql;
create trigger update_partida
after update on partida
for each row
execute function update_partida();

-- Testar
update partida set time_1_gols = 2 where id = 11;
select * from log_partida;

-- fazer triguer que impessa de fazer update em partidas que ja foram finalizadas
-- Postgres
create or replace function validar_update_partida()
returns trigger as $$
begin 
    if old.time_1_gols is not null then
        raise exception 'Não é permitido alterar partidas finalizadas';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger validar_update_partida
before update on partida
for each row
execute function validar_update_partida();

-- Delete
--  Postgres
create or replace function delete_partida()
returns trigger as $$
begin
    -- insert into log_partida(partida_id, acao) values ( old.id, 'DELETE');
    -- return old;
    -- impedir delete
    raise exception 'Não é permitido deletar partidas';
end;
$$ language plpgsql;

create or replace trigger delete_partida
before delete on partida
for each row
execute function delete_partida();

-- Testar
delete from partida where id = 5;