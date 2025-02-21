CREATE TABLE Maquina (
Id_Maquina INT PRIMARY KEY NOT NULL,
Tipo VARCHAR(255),
Velocidade INT,
HardDisk INT,
Placa_Rede INT,
Memoria_Ram INT,
Fk_Usuario INT,
FOREIGN KEY(Fk_Usuario) REFERENCES Usuarios(ID_Usuario)
);

CREATE TABLE Usuarios (
ID_Usuario INT PRIMARY KEY NOT NULL,
Password VARCHAR(255),
Nome_Usuario VARCHAR(255),
Ramal INT,
Especialidade VARCHAR(255)
);

CREATE TABLE Software (
Id_Software INT PRIMARY KEY NOT NULL,
Produto VARCHAR(255),
HardDisk INT,
Memoria_Ram INT,
Fk_Maquina INT,
FOREIGN KEY(Fk_Maquina) REFERENCES Maquina(Id_Maquina)
);

insert into Maquina values (1, 'Desktop', 2, 500, 1, 4, 1);
insert into Maquina values (2, 'Notebook', 1, 250, 1, 2, 2);
insert into Maquina values (3, 'Desktop', 3, 1000, 1, 8, 3);
insert into Maquina values (4, 'Notebook', 2, 500, 1, 4, 4);
insert into Usuarios values (1, '123', 'Joao', 123, 'TI');
insert into Usuarios values (2, '456', 'Maria', 456, 'RH');
insert into Usuarios values (3, '789', 'Jose', 789, 'Financeiro');
insert into Usuarios values (4, '101', 'Ana', 101, 'TI');
insert into Software values (1, 'Windows', 100, 2, 1);
insert into Software values (2, 'Linux', 50, 1, 2);
insert into Software values (3, 'Windows', 200, 4, 3);
insert into Software values (4, 'Linux', 100, 2, 4);

-- 1. Crie uma função chamada Espaco_Disponivel que recebe o ID da máquina e retorna TRUE se houver espaço suficiente para instalar um software.
CREATE OR REPLACE FUNCTION espaco_disponivel(idmaquina INTEGER, idsoftware INTEGER) RETURNS BOOLEAN AS $$
DECLARE
    espaco_disponivel INTEGER;
    espaco_necessario INTEGER;
BEGIN
    SELECT (HardDisk + Memoria_Ram) INTO espaco_disponivel 
    FROM Maquina 
    WHERE Id_Maquina = idmaquina;

    SELECT (HardDisk + Memoria_Ram) INTO espaco_necessario 
    FROM Software 
    WHERE Id_Software = idsoftware;

    RETURN espaco_disponivel >= espaco_necessario;
END;
$$ LANGUAGE plpgsql;

-- 2. Crie uma procedure Instalar_Software que só instala um software se houver espaço disponível.
CREATE OR REPLACE PROCEDURE instalar_software(idmaquina INTEGER, idsoftware INTEGER) AS $$
DECLARE
    espaco_disponivel INTEGER;
    espaco_necessario INTEGER;
BEGIN
    SELECT (HardDisk + Memoria_Ram) INTO espaco_disponivel 
    FROM Maquina 
    WHERE Id_Maquina = idmaquina;

    SELECT (HardDisk + Memoria_Ram) INTO espaco_necessario 
    FROM Software 
    WHERE Id_Software = idsoftware;

    IF espaco_disponivel < espaco_necessario THEN
        RAISE EXCEPTION 'Espaco insuficiente para instalar o software';
    ELSE UPDATE Software SET Fk_Maquina = idmaquina WHERE Id_Software = idsoftware;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 3. Crie uma função chamada Maquinas_Do_Usuario que retorna uma lista de máquinas associadas a um usuário.
CREATE OR REPLACE FUNCTION maquinas_do_usuario(idusuario INTEGER) RETURNS SETOF Maquina AS $$
BEGIN
    RETURN QUERY SELECT * FROM Maquina WHERE Fk_Usuario = idusuario;
END;
$$ LANGUAGE plpgsql;

-- 4. Crie uma procedure Atualizar_Recursos_Maquina que aumenta a memória RAM e o espaço em disco de uma máquina específica.
CREATE OR REPLACE PROCEDURE atualizar_recursos_maquina(idmaquina_p INTEGER) AS $$
BEGIN
    UPDATE Maquina SET Memoria_Ram = Memoria_Ram + 1, HardDisk = HardDisk + 100 WHERE Id_Maquina = idmaquina_p;
END;
$$ LANGUAGE plpgsql;

-- 5. Crie uma procedure chamada Transferir_Software que transfere um software de uma máquina para outra. Antes de transferir, a procedure deve verificar se a máquina de destino tem espaço suficiente para o software.
CREATE OR REPLACE PROCEDURE transferir_software(idmaquina_origem INTEGER, idmaquina_destino INTEGER, idsoftware INTEGER) AS $$
BEGIN
    IF espaco_disponivel(idmaquina_destino, idsoftware) THEN
        UPDATE Software SET Fk_Maquina = idmaquina_destino WHERE Id_Software = idsoftware;
    ELSE
        RAISE EXCEPTION 'Espaco insuficiente na maquina de destino';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 6. Crie uma função Media_Recursos que retorna a média de Memória RAM e HardDisk de todas as máquinas cadastradas.
CREATE OR REPLACE FUNCTION media_recursos() RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT SUM(Memoria_Ram + HardDisk) / COUNT(*) FROM Maquina);
END;
$$ LANGUAGE plpgsql;

-- 7. Crie uma procedure chamada Diagnostico_Maquina que faz uma avaliação completa de uma maquina e sugere um upgrade se os recursos dela nao forem suficientes para rodar os softwares instalados.
create or Replace Procedure Diagnostico_Maquina(Id_Maquina1 integer) as $$
declare 
    Total_Ram_Requerida integer;
    Total_HardDisk_Requerido integer;
    Ram_Ataul integer;
    HardDisk_Ataul integer;
    Ram_Upgrade integer;
    HardDisk_Upgrade integer;
begin
    -- Obetr a soma dos requisitos minimos dos sofwares instalados na maquina
    select 
        coalesce(sum(Memoria_Ram), 0) 
        coalesce(sum(HardDisk), 0) 
    into
        Total_Ram_Requerida,
        Total_HardDisk_Requerido
    from
        Software
    where
        Fk_Maquina = Id_Maquina1;
    
    -- Obter a quantidade de ram e harddisk atuais
    select 
        Memoria_Ram,
        HardDisk 
    into
        Ram_Ataul,
        HardDisk_Ataul
    from
        Maquina
    where
        Id_Maquina = Id_Maquina1;

    --  Se a maquina não for encontrada, lançar um erro
    if not found then
        raise notice 'Maquina não encontrada';
    end if;

    -- Verficar se a maquina tem recursos suficientes
    if Ram_Ataul >= Total_HardDisk_Requerido and HardDisk_Ataul >= Total_HardDisk_Requerido then
        raise notice 'Maquina % tem recursos suficientes e não precisa de upgrade', Id_Maquina1;
    else
        -- Calcula a nescessidade do upgrade
        Ram_Upgrade := Greatest(0, Total_Ram_Requerida - Ram_Ataul); -- ele ta retornando o maior valor
        HardDisk_Upgrade := Greatest(0, Total_HardDisk_Requerido - HardDisk_Ataul);  -- esse 0 é para não retornar valores negativos

        raise notice 'Maquna % precisa de upgrade', Id_Maquina1;

        -- Sugere upgrade de Ram, se nescessario
        if Ram_Upgrade > 0 then
            raise notice 'Sugere upgrade de % GB de Ram', Ram_Upgrade;
        end if;

        -- Sugere upgrade de HardDisk, se nescessario
        if HardDisk_Upgrade > 0 then
            raise notice 'Sugere upgrade de % GB de HardDisk', HardDisk_Upgrade;
        end if;
    end if;
end;
$$ language plpgsql;


-- Chamada 1: Verificar se há espaço suficiente para o software
SELECT espaco_disponivel(1, 2);

-- Chamada 2: Instalar software
CALL instalar_software(1, 2);

-- Chamada 3: Listar máquinas associadas a um usuário
SELECT * FROM maquinas_do_usuario(1);

-- Chamada 4: Atualizar recursos de uma máquina
CALL atualizar_recursos_maquina(1);

-- Chamada 5: Transferir software
CALL transferir_software(1, 2, 1);

-- Chamada 6: Verificar a média de recursos
SELECT * FROM media_recursos();

-- Chamada 7: Diagnóstico de uma máquina
