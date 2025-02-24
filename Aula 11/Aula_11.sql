-- 1. Criar um Trigger para Auditoria de Exclusão de Maquinas: Criar um trigger que registre quando um registro da tabela Maquina for excluído.
CREATE TABLE log_maquina(
    id serial PRIMARY KEY,
    maquina_id INTEGER,
    acao VARCHAR(20),
    data TIMESTAMP default CURRENT_TIMESTAMP -- O default CURRENT_TIMESTAMP é para pegar a data e hora atual
);

CREATE or REPLACE FUNCTION log_maquina_delete()
returns trigger as $$
begin
    insert into log_maquina(maquina_id, acao) values ( old.Id_Maquina, 'DELETE');
    return old; -- Old é para pegar o valor antigo da linha que foi excluída
end;
$$ language plpgsql;

create trigger log_maquina_delete
after delete on maquina
for each row
execute function log_maquina_delete();

-- Testando
insert into Maquina values (5, 'Celular', 2, 1000, 1, 4, 2);

DELETE FROM Maquina WHERE Id_Maquina = 5;

SELECT * FROM log_maquina;


-- 2. Criar um Trigger para Evitar Senhas Fracas: Criar um BEFORE INSERT trigger para impedir que um usuario seja cadastrado com uma senha menor que 6 caracteres.
CREATE or REPLACE FUNCTION senha_forte()
RETURNS TRIGGER AS $$
BEGIN
    IF length(new.password) < 6 THEN
        RAISE EXCEPTION 'A senha deve ter pelo menos 6 caracteres';
    END IF;
    RETURN NEW; -- New é para garantir que a operação continue normalmente e não seja interrompida
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER senha_forte
BEFORE INSERT ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION senha_forte();

-- Testando
insert into Usuarios values (5, '123', 'Joao', 123, 'TI');

-- 3. Criar um Trigger para Atualizar Contagem de Softwares em Cada Máquina: Criar um AFTER INSERT trigger que atualiza uma tabela auxiliar Maquina Software Count que armazena a quantidade de softwares instalados em cada máquina.
CREATE TABLE maquina_software_count (
    maquina_id INT PRIMARY KEY REFERENCES Maquina(Id_Maquina),
    software_count INT DEFAULT 0
);

INSERT INTO maquina_software_count (maquina_id, software_count)
SELECT Id_Maquina, 0 FROM Maquina;

CREATE OR REPLACE FUNCTION update_maquina_software_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza se já existir um registro
    IF EXISTS (SELECT 1 FROM maquina_software_count WHERE maquina_id = NEW.Fk_Maquina) THEN
        UPDATE maquina_software_count
        SET software_count = software_count + 1
        WHERE maquina_id = NEW.Fk_Maquina;
    ELSE
        -- Insere se ainda não existir
        INSERT INTO maquina_software_count (maquina_id, software_count)
        VALUES (NEW.Fk_Maquina, 1);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_maquina_software_count
AFTER INSERT ON Software
FOR EACH ROW
EXECUTE FUNCTION update_maquina_software_count();

INSERT INTO Software VALUES (5, 'Windows', 100, 2, 1);
INSERT INTO Software VALUES (6, 'Linux', 50, 1, 2);
INSERT INTO Software VALUES (7, 'Windows', 200, 4, 3);
INSERT INTO Software VALUES (8, 'Linux', 100, 2, 4);

DELETE FROM Software WHERE Id_Software = 5;

SELECT * FROM maquina_software_count;

-- 4. Criar um Trigger para Evitar Remoção de Usuários do Setor de Tl: Objetivo: Impedir a remoção de usuários cuja Especialidade seja 'TI'.
CREATE OR REPLACE FUNCTION impedir_remocao_ti()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.Especialidade = 'TI') THEN
        RAISE EXCEPTION 'Não é permitido remover usuários do setor de TI';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER impedir_remocao_ti
BEFORE DELETE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION impedir_remocao_ti();

DELETE FROM Usuarios WHERE ID_Usuario = 4;

-- 5. Criar um Trigger para Calcular o Uso Total de Memória por Máquina: Criar um AFTER INSERT e AFTER DELETE trigger que calcula a quantidade total de memória RAM ocupada pelos softwares em cada máquina.
CREATE TABLE maquina_memoria_total (
    maquina_id INT PRIMARY KEY REFERENCES Maquina(Id_Maquina),
    memoria_total INT DEFAULT 0
);

INSERT INTO maquina_memoria_total (maquina_id, memoria_total) SELECT Id_Maquina, 0 FROM Maquina;

SELECT * FROM maquina_memoria_total;

-- Adicionar
CREATE OR REPLACE FUNCTION calcular_uso_total_memoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza a memória total usada pela máquina
    UPDATE maquina_memoria_total
    SET memoria_total = memoria_total + NEW.Memoria_Ram
    WHERE maquina_id = NEW.Fk_Maquina;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Remover
CREATE OR REPLACE FUNCTION remover_uso_total_memoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza a memória total usada pela máquina ao remover um software
    UPDATE maquina_memoria_total
    SET memoria_total = memoria_total - OLD.Memoria_Ram
    WHERE maquina_id = OLD.Fk_Maquina;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Testar (Adicionar)
CREATE TRIGGER after_insert_software
AFTER INSERT ON Software
FOR EACH ROW
EXECUTE FUNCTION calcular_uso_total_memoria();

-- Testar (Remover)
CREATE TRIGGER after_delete_software
AFTER DELETE ON Software
FOR EACH ROW
EXECUTE FUNCTION remover_uso_total_memoria();

INSERT INTO Software VALUES (9, 'Windows', 100, 2, 1);
INSERT INTO Software VALUES (6, 'Photoshop', 50, 4, 1);
INSERT INTO Software VALUES (7, 'Linux', 200, 4, 1);
INSERT INTO Software VALUES (8, 'Photoshop', 100, 2, 1);

DELETE FROM Software WHERE Id_Software = 6;
SELECT * FROM maquina_memoria_total;

-- 6. Criar um Trigger para Registrar Alterações de Especialidade em Usuários: Criar um trigger que registre as mudanças de especialidade dos usuários na tabela Usuarios.
CREATE TABLE log_especialidade(
    id serial PRIMARY KEY,
    id_usuario INT,
    especialidade_anterior VARCHAR(255),
    especialidade_nova VARCHAR(255),
    data TIMESTAMP default CURRENT_TIMESTAMP
)

CREATE OR REPLACE FUNCTION log_especialidade_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_especialidade(id_usuario, especialidade_anterior, especialidade_nova)
    VALUES (OLD.ID_Usuario, OLD.Especialidade, NEW.Especialidade);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_especialidade_update
AFTER UPDATE ON Usuarios
FOR EACH ROW
EXECUTE FUNCTION log_especialidade_update();

UPDATE Usuarios SET Especialidade = 'Inovacao' WHERE ID_Usuario = 1;

SELECT * FROM log_especialidade;

-- 7. Criar um Trigger para Impedir Exclusão de Softwares Essenciais: Criar um BEFORE DELETE trigger que impeça a exclusão de softwares considerados essenciais (ex: Windows).
CREATE OR REPLACE FUNCTION software_essencial()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.Produto = 'Windows') THEN
        RAISE EXCEPTION 'Software essencial nao pode ser excluido';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER software_essencial
BEFORE DELETE ON Software
FOR EACH ROW
EXECUTE FUNCTION software_essencial();

DELETE FROM Software WHERE Id_Software = 2;