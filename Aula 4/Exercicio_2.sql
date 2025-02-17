-- Remover tabelas na ordem correta
DROP TABLE IF EXISTS exercicio2.maquina_software CASCADE;
DROP TABLE IF EXISTS exercicio2.usuario_maquina CASCADE;
DROP TABLE IF EXISTS exercicio2.software CASCADE;
DROP TABLE IF EXISTS exercicio2.maquina CASCADE;
DROP TABLE IF EXISTS exercicio2.usuario CASCADE;

-- Criar tabela usuario
CREATE TABLE exercicio2.usuario (
    id SERIAL PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    nome_usuario VARCHAR(255) NOT NULL,
    ramal INT NOT NULL,
    especialidade VARCHAR(255) NOT NULL
);

-- Criar tabela maquina
CREATE TABLE exercicio2.maquina (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(255) NOT NULL,
    velocidade VARCHAR(50) NOT NULL,
    hard_disk VARCHAR(50) NOT NULL,
    placa_rede VARCHAR(50) NOT NULL,
    ram VARCHAR(50) NOT NULL
);

-- Criar tabela software
CREATE TABLE exercicio2.software (
    id SERIAL PRIMARY KEY,
    produto VARCHAR(255) NOT NULL,
    hard_disk VARCHAR(50) NOT NULL,
    ram VARCHAR(50) NOT NULL
);

-- Criar tabela usuario_maquina
CREATE TABLE exercicio2.usuario_maquina (
    fk_usuario INT NOT NULL,
    fk_maquina INT NOT NULL,
    PRIMARY KEY (fk_usuario, fk_maquina),
    FOREIGN KEY (fk_usuario) REFERENCES exercicio2.usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (fk_maquina) REFERENCES exercicio2.maquina(id) ON DELETE CASCADE
);

-- Criar tabela maquina_software
CREATE TABLE exercicio2.maquina_software (
    fk_maquina INT NOT NULL,
    fk_software INT NOT NULL,
    PRIMARY KEY (fk_maquina, fk_software),
    FOREIGN KEY (fk_maquina) REFERENCES exercicio2.maquina(id) ON DELETE CASCADE,
    FOREIGN KEY (fk_software) REFERENCES exercicio2.software(id) ON DELETE CASCADE
);

-- Inserir dados na tabela usuario
INSERT INTO exercicio2.usuario (id, password, nome_usuario, ramal, especialidade) VALUES
(1, '1234', 'Matheus', 7823, 'Analista'),
(2, '4585', 'Maria', 6598, 'Tecnico'),
(3, '1284', 'Joao', 4758, 'Desenvolvedor'),
(4, '6845', 'Joao', 4524, 'Tecnico'),
(5, '7423', 'Maria', 6588, 'PO');

-- Inserir dados na tabela maquina
INSERT INTO exercicio2.maquina (id, tipo, velocidade, hard_disk, placa_rede, ram) VALUES
(1, 'Core II', '2.4', '100', '15', '8'),
(2, 'Core III', '3.2', '2000', '20', '16'),
(3, 'Core II', '2.4', '3000', '10', '32'),
(4, 'Pentium', '2.4', '250', '35', '8'),
(5, 'Core V', '3.2', '90', '500', '32');

-- Inserir dados na tabela software
INSERT INTO exercicio2.software (id, produto, hard_disk, ram) VALUES
(1, 'Python', '15', '8'),
(2, 'Java', '2', '46'),
(3, 'C++', '10', '32'),
(4, 'C#', '40', '16'),
(5, 'C++', '500', '12');

-- Inserir dados na tabela usuario_maquina
INSERT INTO exercicio2.usuario_maquina (fk_usuario, fk_maquina) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserir dados na tabela maquina_software
INSERT INTO exercicio2.maquina_software (fk_maquina, fk_software) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Consultar tabela
SELECT * FROM exercicio2.usuario;
SELECT * FROM exercicio2.maquina;
SELECT * FROM exercicio2.software;
SELECT * FROM exercicio2.usuario_maquina;
SELECT * FROM exercicio2.maquina_software;

-- 1. Todos os atributos da tabela para usuarios = tecnico
SELECT * FROM exercicio2.usuario WHERE especialidade = 'Tecnico';

-- 2. Todas as combinações de tipo e velocidade das máquinas
SELECT tipo, velocidade FROM exercicio2.maquina;

-- 3. O tipo e a velocidade dos computadores dos tipos Core II e Pentium
SELECT tipo, velocidade FROM exercicio2.maquina 
WHERE tipo IN ('Core II', 'Pentium');

-- 4. A identificação, o tipo dos computadores e a taxa de transmissão da placa de rede, para maquinas com placa de rede com taxa menor do que 10 Mb/s.
SELECT id, tipo, placa_rede FROM exercicio2.maquina
WHERE CAST(placa_rede AS NUMERIC) < 10;

-- 5. Os nomes dos usuarios que utilizam computadores do tipo Core III ou Core V
SELECT u.nome_usuario 
FROM exercicio2.usuario u
JOIN exercicio2.usuario_maquina um ON u.id = um.fk_usuario
JOIN exercicio2.maquina m ON um.fk_maquina = m.id
WHERE m.tipo IN ('Core III', 'Core V');

-- 6. A identificação das máquinas com C++ instalado.
SELECT m.id 
FROM exercicio2.maquina m
JOIN exercicio2.maquina_software ms ON m.id = ms.fk_maquina
JOIN exercicio2.software s ON ms.fk_software = s.id
WHERE s.produto = 'C++';

-- 7. A identificação das máquinas, sua quantidade de memória RAM, o produto e aquantidade de memoria RAM necessaria dos produtos que nao podem rodar, devido à quantidade exigida dessa memória.
SELECT m.id, m.ram, s.produto, s.ram 
FROM exercicio2.maquina m
JOIN exercicio2.maquina_software ms ON m.id = ms.fk_maquina
JOIN exercicio2.software s ON ms.fk_software = s.id
WHERE CAST(m.ram AS NUMERIC) < CAST(s.ram AS NUMERIC);

-- 8. O nome dos usuários e a velocidade de suas máquinas.
SELECT u.nome_usuario, m.velocidade
FROM exercicio2.usuario u
JOIN exercicio2.usuario_maquina um ON u.id = um.fk_usuario
JOIN exercicio2.maquina m ON um.fk_maquina = m.id;

-- 9. O nome e identificacao dos usuarios que tenham ID menor que o ID de Maria.
SELECT nome_usuario, id
FROM exercicio2.usuario
WHERE id < (SELECT id FROM exercicio2.usuario WHERE nome_usuario = 'Maria' LIMIT 1);

-- 10. O número total de máquinas com velocidade maior do que 2,4 GHz.
SELECT COUNT(*) FROM exercicio2.maquina 
WHERE CAST(velocidade AS NUMERIC) > 2.4;

-- 11. O número de usuários das maquinas.
SELECT COUNT(DISTINCT fk_usuario) FROM exercicio2.usuario_maquina;

-- 12. O número de usuários agrupados pelo tipo de máquinas.
SELECT m.tipo, COUNT(um.fk_usuario) 
FROM exercicio2.usuario_maquina um
JOIN exercicio2.maquina m ON um.fk_maquina = m.id
GROUP BY m.tipo;

-- 13. O número de usuários de máquinas do tipo Dual Core.
SELECT COUNT(*) FROM exercicio2.usuario_maquina um
JOIN exercicio2.maquina m ON um.fk_maquina = m.id
WHERE m.tipo = 'Dual Core';

-- 14. A quantidade de disco rígido necessaria para instalar Word e Lotus juntos na mesma máquina.
SELECT SUM(hard_disk) FROM exercicio2.software WHERE produto IN ('Word', 'Lotus');

-- 15. A quantidade de disco rígido utilizada em cada maquina para os produtos instalados em cada uma delas.
SELECT m.id, SUM(s.hard_disk)
FROM exercicio2.maquina m
JOIN exercicio2.maquina_software ms ON m.id = ms.fk_maquina
JOIN exercicio2.software s ON ms.fk_software = s.id
GROUP BY m.id;

-- 16. A quantidade média de disco rígido necessária por produto.
SELECT produto, AVG(hard_disk) FROM exercicio2.software GROUP BY produto;

-- 17. O número total de máquinas de cada tipo.
SELECT tipo, COUNT(*) FROM exercicio2.maquina GROUP BY tipo;

-- 18. O número de produtos cuja instalação consuma entre 90 e 250 MB de disco rígido.
SELECT COUNT(*) FROM exercicio2.software WHERE hard_disk BETWEEN '90 MB' AND '250 MB';

-- 19. A identificacão e o respectivo produto, em cujo nome tenha a letra O em sua composição.
SELECT id, produto FROM exercicio2.software WHERE produto LIKE '%o%';

-- 20. O produto e a capacidade do disco rígido para maquinas com capacidade de instalação de qualquer produto individualmente.
SELECT m.id, s.produto 
FROM exercicio2.maquina m
JOIN exercicio2.maquina_software ms ON m.id = ms.fk_maquina
JOIN exercicio2.software s ON ms.fk_software = s.id
WHERE m.hard_disk >= s.hard_disk;

-- 21. A relação dos produtos instalados em pelo menos uma máquina.
SELECT DISTINCT s.produto
FROM exercicio2.software s
JOIN exercicio2.maquina_software ms ON s.id = ms.fk_software;