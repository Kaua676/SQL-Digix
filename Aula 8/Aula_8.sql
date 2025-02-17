CREATE TABLE aula8.time (
    id INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE aula8.partida (
    id INTEGER PRIMARY KEY,
    time_1 INTEGER,
    time_2 INTEGER,
    time_1_gols INTEGER,
    time_2_gols INTEGER,
    FOREIGN KEY(time_1) REFERENCES time(id),
    FOREIGN KEY(time_2) REFERENCES time(id)
);

INSERT INTO aula8.time(id, nome)
VALUES (1, 'CORINTHIANS'),
    (2, 'SÃO PAULO'),
    (3, 'CRUZEIRO'),
    (4, 'ATLETICO MINEIRO'),
    (5, 'PALMEIRAS');

INSERT INTO aula8.partida(id, time_1, time_2, time_1_gols, time_2_gols)
VALUES (1, 4, 1, 0, 4),
    (2, 3, 2, 0, 1),
    (3, 1, 3, 3, 0),
    (4, 3, 4, 0, 1),
    (5, 1, 2, 0, 0),
    (6, 2, 4, 2, 2),
    (7, 1, 5, 1, 2),
    (8, 5, 2, 1, 2);

-- Tabela Temporaria: elas são para dados temporarios, e que são de unica sessão de banco de dados
create Temp table temp_time as select * from time;
create Temp table temp_Jogo;
Insert into temp_Jogo select * from partida where time_1 = 1 or time_2 = 1;

select * from temp_time;

-- Ele apaga os dados mais não a tabela
truncate table temp_time;

-- Operações nas funções no Postgres
-- 1. Criar varaives dentro da função e imprimir
create or replace function operacao_funcao() returns void as $$
declare -- declare é para declara e criar as variaveis internas
	v_id integer;
	v_nome varchar(50);
begin
	-- Atribuindo valores nas variaveis
	-- v_id := 1;
	-- v_nome := 'CORINTHIANS';
	-- raise notice 'ID: %, Nome: %', v_id, v_nome;

	-- Operação Matematica
	-- v_id := v_id + 1;
	raise notice 'Soma: %', 1 + 1;
	raise notice 'Subtração: %', 1 - 1;
	raise notice 'Multiplicação: %', 1 * 1;
	raise notice 'Divisão: %', 1 / 1;
	-- Operação de comparação
	raise notice 'Maior: %', 1 > 1;
	raise notice 'Maior ou igura: %', 1 >= 1;
	raise notice 'Menor: %', 1 < 1;
	raise notice 'Menor ou igual: %', 1 <= 1;
	raise notice 'Igual: %', 1 = 1;
	raise notice 'Diferente: %', 1 <> 1;
	-- Operação de concatenação
	raise notice 'Concatenação: %', 'Aula' || 'Digix';
	-- Operação de Lógica
	raise notice 'E: %', true and true;
	raise notice 'Ou: %', true or false;
	raise notice 'Não: %', not true;
	-- Manipução de String
	raise notice 'Tamanho da String: %', length('Aula Digix');
	raise notice 'Substituir: %', replace('Aula Digix', 'Digix', 'Postgres');
	raise notice 'Posição: %', position('Digix' in 'Aula Digix');
	raise notice 'Sub String: %', substring('Aula Digix', 6, 5);
	raise notice 'Maiuscula: %', upper('Aula Digix');
	raise notice 'Minuscula: %', lower('Aula Digix');
	-- Manipulação de Data
	raise notice 'Data Atual: %', now();
	raise notice 'Data Atual: %', current_date;
	raise notice 'Hora Atual: %', current_time; -- Hora
	-- Manipulação de Array
	raise notice 'Array: %', ARRAY[1,2,3,4,5];
	raise notice 'Array: %', ARRAY['Aula', 'Digix'];
	-- raise notice 'Array: %', ARRAY['Aula', 1];  Não é possivel criar um array com tipos diferentes
	raise notice 'Matriz: %', ARRAY[[1,2,3],[4,5,6]];
	raise notice 'Matriz trididimencional: %', ARRAY[[[1,2,3],[4,5,6]],[[7,8,9],[10,11,12]]];
	-- Manipulação de JSON
	raise notice 'JSON: %', '{"nome": "Aula Digix"}';
end;
$$ language plpgsql;

-- Executando a função
select operacao_funcao();

-- 2. Criar uma função que recebe parametros e retorna um valor
create or replace function obter_nome_time(p_id integer) returns varchar as $$
declare
	v_nome varchar(50);
begin
	select nome into v_nome from time where id = p_id;
	return v_nome;
end;
$$ language plpgsql;

select obter_nome_time(1);

-- 3. Criar função com loops
create or replace function obter_times() returns setof time as $$
declare
	i int :=1;
begin 
	Loop -- É quivalente ao while
		exit when i > 5; -- exit é quando a condição for verdadeira
		raise notice 'Valor de i:%', i;
		i :=i+1;
	end loop;
end;
$$ language plpgsql;

-- Ou usando for ou while
create or replace function obter_times() returns setof time as $$
declare
	i int :=1;
begin 
	
	for i in 1..5 loop -- A gente coloca os 2 pontos para indicar o intervalo, e inicio e o fim	
		raise notice 'Valor de i:%', i;
	end loop;

	while i <= 5 loop
		raise notice 'Valor de i:%', i;
		i :=i+1;
	end loop;

end;
$$ language plpgsql;

select obter_times();

-- 4. Criar funçao que percore uma tabela usando Return Next
CREATE OR REPLACE FUNCTION obter_times_dados() RETURNS SETOF time AS $$
DECLARE
    v_time time%ROWTYPE; -- %ROWTYPE é usado para definir uma variável que armazena uma linha de uma tabela
BEGIN
    FOR v_time IN SELECT * FROM time LOOP -- Aqui estamos percorrendo todos os registros da tabela time
        RETURN NEXT v_time; -- Aqui estamos retornando o registro atual, ou seja, o registro que está sendo percorrido no momento
    END LOOP; -- Aqui estamos encerrando o loop
    RETURN; -- Aqui estamos finalizando a função
END;
$$ LANGUAGE plpgsql;

select * from obter_times_dados();

--  5. Função que trabalha codnições
create or replace function gols() returns setof time as 
Declare
	v_gols integer;
	begin
	  select time_1_gols into v_gols from partida where id = 1;
	  if v_gols > 2 then
	  		raise notice 'Time marcou mais de 2 gols';
	  else
	  		raise notice 'Time marcou menos de 2 gols';
	  end if;
	end;
$$ language plpgsql;

-- ou com case
create or replace function gols() returns setof time as
Declare
	v_gols integer;
	begin
	  select time_1_gols into v_gols from partida where id = 1;
	  case
	  	when v_gols > 2 then
	  		raise notice 'Time marcou mais de 2 gols';
	  	else
	  		raise notice 'Time marcou menos de 2 gols';
	  end case;
	end;
$$ language plpgsql;

select * from gols();

-- 6. Função que trata Exceções
create or replace function obter_nome_time_excecao(id_time_nome integer) returns varchar as $$
declare
	v_nome varchar(50);
begin
	select nome into v_nome from time where id = id_time_nome;
	return v_nome;
	Exception 
	when No_Data_Found then
		raise notice 'Nenhum registro encontrado';
end;
$$ language plpgsql;

select obter_nome_time_excecao(6);