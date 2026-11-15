
SET @banco_existe = (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.SCHEMATA
    WHERE SCHEMA_NAME = 'trattos_db'
);

SET @sql_drop = IF(
    @banco_existe > 0,
    'DROP DATABASE `trattos_db`',
    'SELECT 1'
);

PREPARE stmt_drop FROM @sql_drop;
EXECUTE stmt_drop;
DEALLOCATE PREPARE stmt_drop;

CREATE DATABASE `trattos_db`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `trattos_db`;

-- ============================================================================
-- 1. TABELAS PRINCIPAIS / CADASTROS
-- ============================================================================

CREATE TABLE `REPRESENTANTE` (
    `id_representante` INT NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(100) NOT NULL,
    `cpf` CHAR(11) NOT NULL,
    `codigo_representante` VARCHAR(45) NOT NULL,
    `data_cadastro` DATE NOT NULL,
    `endereco` VARCHAR(200) NULL,
    `estado_civil` VARCHAR(40) NULL,
    `id_patrocinador` INT NULL,
    PRIMARY KEY (`id_representante`),
    UNIQUE KEY `uq_representante_cpf` (`cpf`),
    UNIQUE KEY `uq_representante_codigo` (`codigo_representante`),
    INDEX `idx_representante_patrocinador` (`id_patrocinador`),
    CONSTRAINT `fk_representante_patrocinador`
        FOREIGN KEY (`id_patrocinador`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE `CLIENTE` (
    `id_cliente` INT NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(100) NOT NULL,
    `cpf` CHAR(11) NULL,
    `rg` VARCHAR(25) NULL,
    `data_nascimento` DATE NULL,
    `endereco` VARCHAR(200) NULL,
    `telefone` VARCHAR(25) NULL,
    `whatsapp` VARCHAR(25) NULL,
    `email` VARCHAR(150) NULL,
    `data_cadastro` DATE NOT NULL,
    `data_prevista_proxima_compra` DATE NULL,
    `id_representante` INT NOT NULL,
    PRIMARY KEY (`id_cliente`),
    UNIQUE KEY `uq_cliente_cpf` (`cpf`),
    INDEX `idx_cliente_representante` (`id_representante`),
    CONSTRAINT `fk_cliente_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `PRODUTO` (
    `id_produto` INT NOT NULL AUTO_INCREMENT,
    `nome_produto` VARCHAR(120) NOT NULL,
    `preco_tabela` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_produto`),
    CONSTRAINT `chk_produto_preco` CHECK (`preco_tabela` >= 0),
    INDEX `idx_produto_nome` (`nome_produto`)
) ENGINE=InnoDB;

CREATE TABLE `FORNECEDOR` (
    `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
    `cnpj` CHAR(14) NOT NULL,
    `razao_social` VARCHAR(150) NOT NULL,
    `nome_fantasia` VARCHAR(150) NULL,
    `endereco` VARCHAR(200) NULL,
    `data_abertura` DATE NULL,
    `contato_responsavel` VARCHAR(100) NULL,
    `telefone` VARCHAR(25) NULL,
    `whatsapp` VARCHAR(25) NULL,
    `email` VARCHAR(150) NULL,
    `website` VARCHAR(150) NULL,
    `status_anvisa` VARCHAR(45) NULL,
    `data_anvisa` DATE NULL,
    `status_vigilancia_sanitaria` VARCHAR(45) NULL,
    `data_inicio_vigilancia` DATE NULL,
    `data_validade_vigilancia` DATE NULL,
    `prazo_entrega` INT NULL,
    PRIMARY KEY (`id_fornecedor`),
    UNIQUE KEY `uq_fornecedor_cnpj` (`cnpj`)
) ENGINE=InnoDB;

CREATE TABLE `CATEGORIA` (
    `id_categoria` INT NOT NULL AUTO_INCREMENT,
    `nome_categoria` VARCHAR(80) NOT NULL,
    `percentual_desconto_base` DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (`id_categoria`),
    UNIQUE KEY `uq_categoria_nome` (`nome_categoria`),
    CONSTRAINT `chk_categoria_percentual` CHECK (`percentual_desconto_base` BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- ============================================================================
-- 2. ATENDIMENTO, CONDICOES E VISITAS
-- ============================================================================

CREATE TABLE `CONDICAO_SAUDE` (
    `id_condicao` INT NOT NULL AUTO_INCREMENT,
    `nome_condicao` VARCHAR(120) NOT NULL,
    `data_inicio_sintomas` DATE NULL,
    `data_diagnostico` DATE NULL,
    `historico_doenca` TEXT NULL,
    `id_cliente` INT NOT NULL,
    PRIMARY KEY (`id_condicao`),
    INDEX `idx_condicao_cliente` (`id_cliente`),
    CONSTRAINT `fk_condicao_cliente`
        FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `CONDICAO_ALERGIA` (
    `id_condicao_alergia` INT NOT NULL AUTO_INCREMENT,
    `alergia` VARCHAR(120) NOT NULL,
    `id_condicao` INT NOT NULL,
    PRIMARY KEY (`id_condicao_alergia`),
    INDEX `idx_alergia_condicao` (`id_condicao`),
    CONSTRAINT `fk_alergia_condicao`
        FOREIGN KEY (`id_condicao`)
        REFERENCES `CONDICAO_SAUDE` (`id_condicao`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `CONDICAO_MEDICAMENTO` (
    `id_condicao_medicamento` INT NOT NULL AUTO_INCREMENT,
    `medicamento` VARCHAR(120) NOT NULL,
    `id_condicao` INT NOT NULL,
    PRIMARY KEY (`id_condicao_medicamento`),
    INDEX `idx_medicamento_condicao` (`id_condicao`),
    CONSTRAINT `fk_medicamento_condicao`
        FOREIGN KEY (`id_condicao`)
        REFERENCES `CONDICAO_SAUDE` (`id_condicao`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `CONDICAO_SINTOMA` (
    `id_condicao_sintoma` INT NOT NULL AUTO_INCREMENT,
    `sintoma` VARCHAR(120) NOT NULL,
    `id_condicao` INT NOT NULL,
    PRIMARY KEY (`id_condicao_sintoma`),
    INDEX `idx_sintoma_condicao` (`id_condicao`),
    CONSTRAINT `fk_sintoma_condicao`
        FOREIGN KEY (`id_condicao`)
        REFERENCES `CONDICAO_SAUDE` (`id_condicao`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `VISITA` (
    `id_visita` INT NOT NULL AUTO_INCREMENT,
    `data_visita` DATE NOT NULL,
    `observacoes` TEXT NULL,
    `data_proxima_visita` DATE NULL,
    `id_cliente` INT NOT NULL,
    PRIMARY KEY (`id_visita`),
    INDEX `idx_visita_cliente` (`id_cliente`),
    CONSTRAINT `fk_visita_cliente`
        FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- 3. VENDAS E PAGAMENTOS
-- ============================================================================

CREATE TABLE `VENDA` (
    `id_venda` INT NOT NULL AUTO_INCREMENT,
    `data_venda` DATE NOT NULL,
    `id_cliente` INT NOT NULL,
    PRIMARY KEY (`id_venda`),
    INDEX `idx_venda_cliente` (`id_cliente`),
    INDEX `idx_venda_data` (`data_venda`),
    CONSTRAINT `fk_venda_cliente`
        FOREIGN KEY (`id_cliente`) REFERENCES `CLIENTE` (`id_cliente`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Preco de tabela / preco vendido representam os valores da EPOCA da venda.
CREATE TABLE `VENDA_PRODUTO` (
    `id_venda` INT NOT NULL,
    `id_produto` INT NOT NULL,
    `quantidade` INT NOT NULL,
    `preco_tabela` DECIMAL(10,2) NOT NULL,
    `preco_vendido` DECIMAL(10,2) NOT NULL,
    `desconto_aplicado` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id_venda`, `id_produto`),
    INDEX `idx_venda_produto_produto` (`id_produto`),
    CONSTRAINT `fk_vendaproduto_venda`
        FOREIGN KEY (`id_venda`) REFERENCES `VENDA` (`id_venda`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_vendaproduto_produto`
        FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_venda_produto_quantidade` CHECK (`quantidade` > 0),
    CONSTRAINT `chk_venda_produto_precos` CHECK (`preco_tabela` >= 0 AND `preco_vendido` >= 0 AND `desconto_aplicado` >= 0)
) ENGINE=InnoDB;

-- Pagamento pertence a Venda; Venda NAO depende de Pagamento (sem ciclo).
CREATE TABLE `PAGAMENTO_VENDA` (
    `id_pagamento_venda` INT NOT NULL AUTO_INCREMENT,
    `data_pagamento` DATE NOT NULL,
    `valor` DECIMAL(10,2) NOT NULL,
    `forma_pagamento` VARCHAR(45) NOT NULL,
    `id_venda` INT NOT NULL,
    PRIMARY KEY (`id_pagamento_venda`),
    INDEX `idx_pagamento_venda` (`id_venda`),
    CONSTRAINT `fk_pagamentovenda_venda`
        FOREIGN KEY (`id_venda`) REFERENCES `VENDA` (`id_venda`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_pagamento_venda_valor` CHECK (`valor` >= 0)
) ENGINE=InnoDB;

-- ============================================================================
-- 4. PEDIDOS, LOTES, FORNECEDORES E PAGAMENTOS DE PEDIDO
-- ============================================================================

CREATE TABLE `PEDIDO` (
    `id_pedido` INT NOT NULL AUTO_INCREMENT,
    `numero_pedido` VARCHAR(45) NOT NULL,
    `data_pedido` DATE NOT NULL,
    `frete` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `status_pedido` VARCHAR(45) NOT NULL,
    `id_representante` INT NOT NULL,
    PRIMARY KEY (`id_pedido`),
    UNIQUE KEY `uq_pedido_numero` (`numero_pedido`),
    INDEX `idx_pedido_representante` (`id_representante`),
    CONSTRAINT `fk_pedido_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_pedido_frete` CHECK (`frete` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `PEDIDO_PRODUTO` (
    `id_pedido` INT NOT NULL,
    `id_produto` INT NOT NULL,
    `quantidade` INT NOT NULL,
    `valor_unitario` DECIMAL(10,2) NOT NULL,
    `desconto_item` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id_pedido`, `id_produto`),
    INDEX `idx_pedidoproduto_produto` (`id_produto`),
    CONSTRAINT `fk_pedidoproduto_pedido`
        FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_pedidoproduto_produto`
        FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_pedido_produto_quantidade` CHECK (`quantidade` > 0),
    CONSTRAINT `chk_pedido_produto_valores` CHECK (`valor_unitario` >= 0 AND `desconto_item` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `PAGAMENTO_PEDIDO` (
    `id_pagamento_pedido` INT NOT NULL AUTO_INCREMENT,
    `data_pagamento` DATE NOT NULL,
    `valor` DECIMAL(10,2) NOT NULL,
    `forma_pagamento` VARCHAR(45) NOT NULL,
    `id_pedido` INT NOT NULL,
    PRIMARY KEY (`id_pagamento_pedido`),
    INDEX `idx_pagamentopedido_pedido` (`id_pedido`),
    CONSTRAINT `fk_pagamentopedido_pedido`
        FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_pagamento_pedido_valor` CHECK (`valor` >= 0)
) ENGINE=InnoDB;

CREATE TABLE `LOTE` (
    `id_lote` INT NOT NULL AUTO_INCREMENT,
    `numero_lote` VARCHAR(45) NOT NULL,
    `data_fabricacao` DATE NOT NULL,
    `data_validade` DATE NOT NULL,
    `id_produto` INT NOT NULL,
    PRIMARY KEY (`id_lote`),
    CONSTRAINT `chk_lote_datas` CHECK (`data_validade` > `data_fabricacao`),
    UNIQUE KEY `uq_lote_numero_produto` (`numero_lote`, `id_produto`),
    INDEX `idx_lote_produto` (`id_produto`),
    INDEX `idx_lote_validade` (`data_validade`),
    CONSTRAINT `fk_lote_produto`
        FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `PEDIDO_LOTE` (
    `id_pedido` INT NOT NULL,
    `id_lote` INT NOT NULL,
    `quantidade_lote` INT NOT NULL,
    PRIMARY KEY (`id_pedido`, `id_lote`),
    INDEX `idx_pedidolote_lote` (`id_lote`),
    CONSTRAINT `fk_pedidolote_pedido`
        FOREIGN KEY (`id_pedido`) REFERENCES `PEDIDO` (`id_pedido`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_pedidolote_lote`
        FOREIGN KEY (`id_lote`) REFERENCES `LOTE` (`id_lote`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_pedido_lote_quantidade` CHECK (`quantidade_lote` > 0)
) ENGINE=InnoDB;

CREATE TABLE `FORNECEDOR_PRODUTO` (
    `id_fornecedor` INT NOT NULL,
    `id_produto` INT NOT NULL,
    PRIMARY KEY (`id_fornecedor`, `id_produto`),
    INDEX `idx_fornecedorproduto_produto` (`id_produto`),
    CONSTRAINT `fk_fornecedorproduto_fornecedor`
        FOREIGN KEY (`id_fornecedor`) REFERENCES `FORNECEDOR` (`id_fornecedor`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_fornecedorproduto_produto`
        FOREIGN KEY (`id_produto`) REFERENCES `PRODUTO` (`id_produto`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Qualificacao do fornecedor: mantem o historico de avaliacao do parceiro.
CREATE TABLE `QUALIFICACAO_FORNECEDOR` (
    `id_qualificacao_fornecedor` INT NOT NULL AUTO_INCREMENT,
    `data_qualificacao` DATE NOT NULL,
    `status` VARCHAR(45) NOT NULL,
    `observacao` VARCHAR(250) NULL,
    `id_fornecedor` INT NOT NULL,
    PRIMARY KEY (`id_qualificacao_fornecedor`),
    INDEX `idx_qualifornecedor_fornecedor` (`id_fornecedor`),
    CONSTRAINT `fk_qualifornecedor_fornecedor`
        FOREIGN KEY (`id_fornecedor`) REFERENCES `FORNECEDOR` (`id_fornecedor`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `FORNECEDOR_FORMA_PAGAMENTO` (
    `id_forma_pagamento` INT NOT NULL AUTO_INCREMENT,
    `forma_pagamento` VARCHAR(45) NOT NULL,
    `id_fornecedor` INT NOT NULL,
    PRIMARY KEY (`id_forma_pagamento`),
    UNIQUE KEY `uq_forma_fornecedor` (`id_fornecedor`, `forma_pagamento`),
    CONSTRAINT `fk_formapagamento_fornecedor`
        FOREIGN KEY (`id_fornecedor`) REFERENCES `FORNECEDOR` (`id_fornecedor`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ============================================================================
-- 5. REPRESENTANTES, QUALIFICACAO E COMISSOES
-- ============================================================================

CREATE TABLE `INGRESSO` (
    `id_ingresso` INT NOT NULL AUTO_INCREMENT,
    `data_ingresso` DATE NOT NULL,
    `valor_kit` DECIMAL(10,2) NOT NULL,
    `quantidade_parcelas` INT NOT NULL,
    `status_pagamento` VARCHAR(45) NOT NULL,
    `id_representante` INT NOT NULL,
    PRIMARY KEY (`id_ingresso`),
    UNIQUE KEY `uq_ingresso_representante` (`id_representante`),
    CONSTRAINT `fk_ingresso_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_ingresso_valor` CHECK (`valor_kit` >= 0),
    CONSTRAINT `chk_ingresso_parcelas` CHECK (`quantidade_parcelas` > 0)
) ENGINE=InnoDB;

CREATE TABLE `QUALIFICACAO` (
    `id_qualificacao` INT NOT NULL AUTO_INCREMENT,
    `data_qualificacao` DATE NOT NULL,
    `tipo_qualificacao` VARCHAR(45) NOT NULL,
    `valor_base` DECIMAL(10,2) NULL,
    `id_representante` INT NOT NULL,
    `id_categoria` INT NOT NULL,
    `id_treinador` INT NULL,
    PRIMARY KEY (`id_qualificacao`),
    INDEX `idx_qualificacao_representante` (`id_representante`),
    INDEX `idx_qualificacao_categoria` (`id_categoria`),
    INDEX `idx_qualificacao_treinador` (`id_treinador`),
    CONSTRAINT `fk_qualificacao_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_qualificacao_categoria`
        FOREIGN KEY (`id_categoria`) REFERENCES `CATEGORIA` (`id_categoria`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `fk_qualificacao_treinador`
        FOREIGN KEY (`id_treinador`) REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT `chk_qualificacao_valor_base` CHECK (`valor_base` IS NULL OR `valor_base` >= 0)
) ENGINE=InnoDB;

-- Atividade mensal do representante, separada da categoria/qualificacao.
CREATE TABLE `ATIVIDADE_MENSAL` (
    `id_atividade` INT NOT NULL AUTO_INCREMENT,
    `mes_referencia` TINYINT NOT NULL,
    `ano_referencia` SMALLINT NOT NULL,
    `status_atividade` VARCHAR(45) NOT NULL,
    `id_representante` INT NOT NULL,
    PRIMARY KEY (`id_atividade`),
    UNIQUE KEY `uq_atividade_representante_mes`
        (`id_representante`, `mes_referencia`, `ano_referencia`),
    CONSTRAINT `chk_atividade_mes`
        CHECK (`mes_referencia` BETWEEN 1 AND 12),
    CONSTRAINT `fk_atividade_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE `COMISSAO` (
    `id_comissao` INT NOT NULL AUTO_INCREMENT,
    `tipo_comissao` VARCHAR(45) NOT NULL,
    `valor_base` DECIMAL(10,2) NOT NULL,
    `percentual` DECIMAL(5,2) NOT NULL,
    `data_geracao` DATE NOT NULL,
    `status` VARCHAR(45) NOT NULL,
    `data_pagamento` DATE NULL,
    `id_representante` INT NOT NULL,
    PRIMARY KEY (`id_comissao`),
    INDEX `idx_comissao_representante` (`id_representante`),
    CONSTRAINT `fk_comissao_representante`
        FOREIGN KEY (`id_representante`)
        REFERENCES `REPRESENTANTE` (`id_representante`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT `chk_comissao_valor_base` CHECK (`valor_base` >= 0),
    CONSTRAINT `chk_comissao_percentual` CHECK (`percentual` BETWEEN 0 AND 100)
) ENGINE=InnoDB;

-- ============================================================================
-- 6. MASSA DE DADOS DE TESTE (100% FICTICIOS)
-- Como o banco e recriado no inicio, os INSERTs partem sempre de uma base vazia.
-- ============================================================================

START TRANSACTION;

-- ----------------------------------------------------------------------------
-- REPRESENTANTES
-- Dados ficticios para demonstracao academica.
-- ----------------------------------------------------------------------------
INSERT INTO `REPRESENTANTE`
    (`id_representante`, `nome`, `cpf`, `codigo_representante`, `data_cadastro`,
     `endereco`, `estado_civil`, `id_patrocinador`)
VALUES
    (1, 'Ana Lima (ficticia)', '00000000001', 'REP001', '2026-01-10',
     'Rua Exemplo, 100', 'Solteiro(a)', NULL),
    (2, 'Bruno Rocha (ficticio)', '00000000002', 'REP002', '2026-02-05',
     'Avenida Modelo, 200', 'Casado(a)', 1),
    (3, 'Camila Alves (ficticia)', '00000000003', 'REP003', '2026-03-12',
     'Rua Modelo, 35', 'Solteiro(a)', 1),
    (4, 'Diego Martins (ficticio)', '00000000004', 'REP004', '2026-04-18',
     'Rua Teste, 44', 'Casado(a)', 2),
    (5, 'Elisa Ramos (ficticia)', '00000000005', 'REP005', '2026-05-09',
     'Avenida Exemplo, 51', 'Solteiro(a)', 2),
    (6, 'Felipe Santos (ficticio)', '00000000006', 'REP006', '2026-06-21',
     'Rua Demonstracao, 62', 'Casado(a)', 3);

-- ----------------------------------------------------------------------------
-- CLIENTES
-- Os clientes 1 a 40 possuem uma venda cada; os clientes 41 a 60 ficam sem venda.
-- ----------------------------------------------------------------------------
INSERT INTO `CLIENTE`
    (`id_cliente`, `nome`, `data_nascimento`, `data_cadastro`, `cpf`, `email`, `rg`,
     `telefone`, `whatsapp`, `endereco`, `data_prevista_proxima_compra`,
     `id_representante`)
VALUES
    (1, 'Marina Costa (ficticia)', '1981-06-08', '2026-01-05', '10000000001',
     'cliente01.teste@example.com', 'RG-FIC-001', '11920000001', '11930000001',
     'Rua Ficticia 1, 10', '2026-09-07', 1),
    (2, 'Joao Pereira (ficticio)', '1984-11-15', '2026-01-09', '10000000002',
     'cliente02.teste@example.com', 'RG-FIC-002', '11920000002', '11930000002',
     'Rua Ficticia 2, 20', '2026-09-13', 2),
    (3, 'Clara Souza (ficticia)', '1987-04-22', '2026-01-13', '10000000003',
     'cliente03.teste@example.com', 'RG-FIC-003', '11920000003', '11930000003',
     'Rua Ficticia 3, 30', '2026-09-19', 3),
    (4, 'Lucas Almeida (ficticio)', '1990-09-02', '2026-01-17', '10000000004',
     'cliente04.teste@example.com', 'RG-FIC-004', '11920000004', '11930000004',
     'Rua Ficticia 4, 40', '2026-09-25', 4),
    (5, 'Patricia Melo (ficticia)', '1993-02-09', '2026-01-21', '10000000005',
     'cliente05.teste@example.com', 'RG-FIC-005', '11920000005', '11930000005',
     'Rua Ficticia 5, 50', '2026-10-01', 5),
    (6, 'Rafael Nunes (ficticio)', '1996-07-16', '2026-01-25', '10000000006',
     'cliente06.teste@example.com', 'RG-FIC-006', '11920000006', '11930000006',
     'Rua Ficticia 6, 60', '2026-10-07', 6),
    (7, 'Beatriz Lopes (ficticia)', '1999-12-23', '2026-01-29', '10000000007',
     'cliente07.teste@example.com', 'RG-FIC-007', '11920000007', '11930000007',
     'Rua Ficticia 7, 70', '2026-10-13', 1),
    (8, 'Gustavo Freitas (ficticio)', '1978-05-03', '2026-02-02', '10000000008',
     'cliente08.teste@example.com', 'RG-FIC-008', '11920000008', '11930000008',
     'Rua Ficticia 8, 80', '2026-10-19', 2),
    (9, 'Renata Barros (ficticia)', '1981-10-10', '2026-02-06', '10000000009',
     'cliente09.teste@example.com', 'RG-FIC-009', '11920000009', '11930000009',
     'Rua Ficticia 9, 90', '2026-10-25', 3),
    (10, 'Marcelo Dias (ficticio)', '1984-03-17', '2026-02-10', '10000000010',
     'cliente10.teste@example.com', 'RG-FIC-010', '11920000010', '11930000010',
     'Rua Ficticia 10, 100', '2026-11-30', 4),
    (11, 'Sonia Prado (ficticia)', '1987-08-24', '2026-02-14', '10000000011',
     'cliente11.teste@example.com', 'RG-FIC-011', '11920000011', '11930000011',
     'Rua Ficticia 11, 110', '2026-11-06', 5),
    (12, 'Eduardo Campos (ficticio)', '1990-01-04', '2026-02-18', '10000000012',
     'cliente12.teste@example.com', 'RG-FIC-012', '11920000012', '11930000012',
     'Rua Ficticia 12, 120', '2026-11-12', 6),
    (13, 'Aline Silva (ficticia)', '1993-06-11', '2026-02-22', '10000000013',
     'cliente13.teste@example.com', 'RG-FIC-013', '11920000013', '11930000013',
     'Rua Ficticia 13, 130', '2026-11-18', 1),
    (14, 'Bruno Rocha (ficticio)', '1996-11-18', '2026-02-26', '10000000014',
     'cliente14.teste@example.com', 'RG-FIC-014', '11920000014', '11930000014',
     'Rua Ficticia 14, 140', '2026-11-24', 2),
    (15, 'Carla Martins (ficticia)', '1999-04-25', '2026-03-02', '10000000015',
     'cliente15.teste@example.com', 'RG-FIC-015', '11920000015', '11930000015',
     'Rua Ficticia 15, 150', '2026-11-30', 3),
    (16, 'Daniel Ramos (ficticio)', '1978-09-05', '2026-03-06', '10000000016',
     'cliente16.teste@example.com', 'RG-FIC-016', '11920000016', '11930000016',
     'Rua Ficticia 16, 160', '2026-12-06', 4),
    (17, 'Elaine Oliveira (ficticia)', '1981-02-12', '2026-03-10', '10000000017',
     'cliente17.teste@example.com', 'RG-FIC-017', '11920000017', '11930000017',
     'Rua Ficticia 17, 170', '2026-12-12', 5),
    (18, 'Fabio Santos (ficticio)', '1984-07-19', '2026-03-14', '10000000018',
     'cliente18.teste@example.com', 'RG-FIC-018', '11920000018', '11930000018',
     'Rua Ficticia 18, 180', '2026-12-18', 6),
    (19, 'Gabriela Araujo (ficticia)', '1987-12-26', '2026-03-18', '10000000019',
     'cliente19.teste@example.com', 'RG-FIC-019', '11920000019', '11930000019',
     'Rua Ficticia 19, 190', '2026-12-24', 1),
    (20, 'Henrique Cardoso (ficticio)', '1990-05-06', '2026-03-22', '10000000020',
     'cliente20.teste@example.com', 'RG-FIC-020', '11920000020', '11930000020',
     'Rua Ficticia 20, 200', '2026-12-10', 2),
    (21, 'Isabela Costa (ficticia)', '1993-10-13', '2026-03-26', '10000000021',
     'cliente21.teste@example.com', 'RG-FIC-021', '11920000021', '11930000021',
     'Rua Ficticia 21, 210', '2027-01-05', 3),
    (22, 'Julio Pereira (ficticio)', '1996-03-20', '2026-03-30', '10000000022',
     'cliente22.teste@example.com', 'RG-FIC-022', '11920000022', '11930000022',
     'Rua Ficticia 22, 220', '2027-01-11', 4),
    (23, 'Karen Souza (ficticia)', '1999-08-27', '2026-04-03', '10000000023',
     'cliente23.teste@example.com', 'RG-FIC-023', '11920000023', '11930000023',
     'Rua Ficticia 23, 230', '2027-01-17', 5),
    (24, 'Leandro Almeida (ficticio)', '1978-01-07', '2026-04-07', '10000000024',
     'cliente24.teste@example.com', 'RG-FIC-024', '11920000024', '11930000024',
     'Rua Ficticia 24, 240', '2027-01-23', 6),
    (25, 'Monica Melo (ficticia)', '1981-06-14', '2026-04-11', '10000000025',
     'cliente25.teste@example.com', 'RG-FIC-025', '11920000025', '11930000025',
     'Rua Ficticia 25, 250', '2026-09-01', 1),
    (26, 'Nicolas Nunes (ficticio)', '1984-11-21', '2026-04-15', '10000000026',
     'cliente26.teste@example.com', 'RG-FIC-026', '11920000026', '11930000026',
     'Rua Ficticia 26, 260', '2026-09-07', 2),
    (27, 'Olivia Lopes (ficticia)', '1987-04-01', '2026-04-19', '10000000027',
     'cliente27.teste@example.com', 'RG-FIC-027', '11920000027', '11930000027',
     'Rua Ficticia 27, 270', '2026-09-13', 3),
    (28, 'Paulo Freitas (ficticio)', '1990-09-08', '2026-04-23', '10000000028',
     'cliente28.teste@example.com', 'RG-FIC-028', '11920000028', '11930000028',
     'Rua Ficticia 28, 280', '2026-09-19', 4),
    (29, 'Raquel Barros (ficticia)', '1993-02-15', '2026-04-27', '10000000029',
     'cliente29.teste@example.com', 'RG-FIC-029', '11920000029', '11930000029',
     'Rua Ficticia 29, 290', '2026-09-25', 5),
    (30, 'Samuel Dias (ficticio)', '1996-07-22', '2026-05-01', '10000000030',
     'cliente30.teste@example.com', 'RG-FIC-030', '11920000030', '11930000030',
     'Rua Ficticia 30, 300', '2026-12-20', 6),
    (31, 'Tatiane Prado (ficticia)', '1999-12-02', '2026-05-05', '10000000031',
     'cliente31.teste@example.com', 'RG-FIC-031', '11920000031', '11930000031',
     'Rua Ficticia 31, 310', '2026-10-07', 1),
    (32, 'Vinicius Campos (ficticio)', '1978-05-09', '2026-05-09', '10000000032',
     'cliente32.teste@example.com', 'RG-FIC-032', '11920000032', '11930000032',
     'Rua Ficticia 32, 320', '2026-10-13', 2),
    (33, 'Amanda Silva (ficticia)', '1981-10-16', '2026-05-13', '10000000033',
     'cliente33.teste@example.com', 'RG-FIC-033', '11920000033', '11930000033',
     'Rua Ficticia 33, 330', '2026-10-19', 3),
    (34, 'Caio Rocha (ficticio)', '1984-03-23', '2026-05-17', '10000000034',
     'cliente34.teste@example.com', 'RG-FIC-034', '11920000034', '11930000034',
     'Rua Ficticia 34, 340', '2026-10-25', 4),
    (35, 'Debora Martins (ficticia)', '1987-08-03', '2026-05-21', '10000000035',
     'cliente35.teste@example.com', 'RG-FIC-035', '11920000035', '11930000035',
     'Rua Ficticia 35, 350', '2026-10-31', 5),
    (36, 'Erick Ramos (ficticio)', '1990-01-10', '2026-05-25', '10000000036',
     'cliente36.teste@example.com', 'RG-FIC-036', '11920000036', '11930000036',
     'Rua Ficticia 36, 360', '2026-11-06', 6),
    (37, 'Fernanda Oliveira (ficticia)', '1993-06-17', '2026-05-29', '10000000037',
     'cliente37.teste@example.com', 'RG-FIC-037', '11920000037', '11930000037',
     'Rua Ficticia 37, 370', '2026-11-12', 1),
    (38, 'Giovana Santos (ficticio)', '1996-11-24', '2026-06-02', '10000000038',
     'cliente38.teste@example.com', 'RG-FIC-038', '11920000038', '11930000038',
     'Rua Ficticia 38, 380', '2026-11-18', 2),
    (39, 'Heitor Araujo (ficticia)', '1999-04-04', '2026-06-06', '10000000039',
     'cliente39.teste@example.com', 'RG-FIC-039', '11920000039', '11930000039',
     'Rua Ficticia 39, 390', '2026-11-24', 3),
    (40, 'Ingrid Cardoso (ficticio)', '1978-09-11', '2026-06-10', '10000000040',
     'cliente40.teste@example.com', 'RG-FIC-040', '11920000040', '11930000040',
     'Rua Ficticia 40, 400', '2026-12-30', 4),
    (41, 'Jorge Costa (ficticia)', '1981-02-18', '2026-06-14', '10000000041',
     'cliente41.teste@example.com', 'RG-FIC-041', '11920000041', '11930000041',
     'Rua Ficticia 41, 410', '2026-12-06', 5),
    (42, 'Larissa Pereira (ficticio)', '1984-07-25', '2026-06-18', '10000000042',
     'cliente42.teste@example.com', 'RG-FIC-042', '11920000042', '11930000042',
     'Rua Ficticia 42, 420', '2026-12-12', 6),
    (43, 'Matheus Souza (ficticia)', '1987-12-05', '2026-06-22', '10000000043',
     'cliente43.teste@example.com', 'RG-FIC-043', '11920000043', '11930000043',
     'Rua Ficticia 43, 430', '2026-12-18', 1),
    (44, 'Natalia Almeida (ficticio)', '1990-05-12', '2026-06-26', '10000000044',
     'cliente44.teste@example.com', 'RG-FIC-044', '11920000044', '11930000044',
     'Rua Ficticia 44, 440', '2026-12-24', 2),
    (45, 'Otavio Melo (ficticia)', '1993-10-19', '2026-06-30', '10000000045',
     'cliente45.teste@example.com', 'RG-FIC-045', '11920000045', '11930000045',
     'Rua Ficticia 45, 450', '2026-12-30', 3),
    (46, 'Priscila Nunes (ficticio)', '1996-03-26', '2026-07-04', '10000000046',
     'cliente46.teste@example.com', 'RG-FIC-046', '11920000046', '11930000046',
     'Rua Ficticia 46, 460', '2027-01-05', 4),
    (47, 'Rodrigo Lopes (ficticia)', '1999-08-06', '2026-07-08', '10000000047',
     'cliente47.teste@example.com', 'RG-FIC-047', '11920000047', '11930000047',
     'Rua Ficticia 47, 470', '2027-01-11', 5),
    (48, 'Simone Freitas (ficticio)', '1978-01-13', '2026-07-12', '10000000048',
     'cliente48.teste@example.com', 'RG-FIC-048', '11920000048', '11930000048',
     'Rua Ficticia 48, 480', '2027-01-17', 6),
    (49, 'Thiago Barros (ficticia)', '1981-06-20', '2026-07-16', '10000000049',
     'cliente49.teste@example.com', 'RG-FIC-049', '11920000049', '11930000049',
     'Rua Ficticia 49, 490', '2027-01-23', 1),
    (50, 'Vanessa Dias (ficticio)', '1984-11-27', '2026-07-20', '10000000050',
     'cliente50.teste@example.com', 'RG-FIC-050', '11920000050', '11930000050',
     'Rua Ficticia 50, 500', '2027-01-09', 2),
    (51, 'Wesley Prado (ficticia)', '1987-04-07', '2026-07-24', '10000000051',
     'cliente51.teste@example.com', 'RG-FIC-051', '11920000051', '11930000051',
     'Rua Ficticia 51, 510', '2026-09-07', 3),
    (52, 'Yasmin Campos (ficticio)', '1990-09-14', '2026-07-28', '10000000052',
     'cliente52.teste@example.com', 'RG-FIC-052', '11920000052', '11930000052',
     'Rua Ficticia 52, 520', '2026-09-13', 4),
    (53, 'Adriana Silva (ficticia)', '1993-02-21', '2026-08-01', '10000000053',
     'cliente53.teste@example.com', 'RG-FIC-053', '11920000053', '11930000053',
     'Rua Ficticia 53, 530', '2026-09-19', 5),
    (54, 'Bernardo Rocha (ficticio)', '1996-07-01', '2026-08-05', '10000000054',
     'cliente54.teste@example.com', 'RG-FIC-054', '11920000054', '11930000054',
     'Rua Ficticia 54, 540', '2026-09-25', 6),
    (55, 'Cristina Martins (ficticia)', '1999-12-08', '2026-08-09', '10000000055',
     'cliente55.teste@example.com', 'RG-FIC-055', '11920000055', '11930000055',
     'Rua Ficticia 55, 550', '2026-10-01', 1),
    (56, 'Douglas Ramos (ficticio)', '1978-05-15', '2026-08-13', '10000000056',
     'cliente56.teste@example.com', 'RG-FIC-056', '11920000056', '11930000056',
     'Rua Ficticia 56, 560', '2026-10-07', 2),
    (57, 'Estela Oliveira (ficticia)', '1981-10-22', '2026-08-17', '10000000057',
     'cliente57.teste@example.com', 'RG-FIC-057', '11920000057', '11930000057',
     'Rua Ficticia 57, 570', '2026-10-13', 3),
    (58, 'Fernando Santos (ficticio)', '1984-03-02', '2026-08-21', '10000000058',
     'cliente58.teste@example.com', 'RG-FIC-058', '11920000058', '11930000058',
     'Rua Ficticia 58, 580', '2026-10-19', 4),
    (59, 'Helena Araujo (ficticia)', '1987-08-09', '2026-08-25', '10000000059',
     'cliente59.teste@example.com', 'RG-FIC-059', '11920000059', '11930000059',
     'Rua Ficticia 59, 590', '2026-10-25', 5),
    (60, 'Igor Cardoso (ficticio)', '1990-01-16', '2026-08-29', '10000000060',
     'cliente60.teste@example.com', 'RG-FIC-060', '11920000060', '11930000060',
     'Rua Ficticia 60, 600', '2027-01-19', 6);

-- ----------------------------------------------------------------------------
-- PRODUTOS
-- Produtos alinhados aos exemplos informados na entrevista.
-- ----------------------------------------------------------------------------
INSERT INTO `PRODUTO` (`id_produto`, `nome_produto`, `preco_tabela`)
VALUES
    (1, 'Colageno Hidrolisado (exemplo ficticio)', 89.90),
    (2, 'Calcio e Magnesio (exemplo ficticio)', 69.90),
    (3, 'Levedo de Cerveja (exemplo ficticio)', 39.90),
    (4, 'Allium (exemplo ficticio)', 74.90),
    (5, 'Polen Apicola (exemplo ficticio)', 54.90);

-- ----------------------------------------------------------------------------
-- FORNECEDORES
-- ----------------------------------------------------------------------------
INSERT INTO `FORNECEDOR`
    (`id_fornecedor`, `cnpj`, `razao_social`, `nome_fantasia`, `endereco`,
     `data_abertura`, `contato_responsavel`, `telefone`, `whatsapp`, `email`,
     `website`, `status_anvisa`, `data_anvisa`, `status_vigilancia_sanitaria`,
     `data_inicio_vigilancia`, `data_validade_vigilancia`, `prazo_entrega`)
VALUES
    (1, '00000000000001', 'Distribuidora Exemplo LTDA', 'Distribuidora Exemplo',
     'Rua Fornecedor, 10', '2018-01-15', 'Contato Ficticio A', '1130000001',
     '11980000001', 'fornecedor1@example.com', 'https://fornecedor1.example.com', 'Regular', '2026-01-15',
     'Regular', '2026-01-15', '2027-01-15', 5),
    (2, '00000000000002', 'Saude Modelo LTDA', 'Saude Modelo',
     'Rua Fornecedor, 20', '2020-02-20', 'Contato Ficticio B', '1130000002',
     '11980000002', 'fornecedor2@example.com', 'https://fornecedor2.example.com', 'Regular', '2026-02-20',
     'Regular', '2026-02-20', '2027-02-20', 7),
    (3, '00000000000003', 'Parceiro Nutricao LTDA', 'Parceiro Nutricao',
     'Rua Fornecedor, 30', '2019-05-14', 'Contato Ficticio C', '1130000003',
     '11980000003', 'fornecedor3@example.com', 'https://fornecedor3.example.com', 'Regular', '2026-03-14',
     'Regular', '2026-03-14', '2027-03-14', 4);

INSERT INTO `CATEGORIA`
    (`id_categoria`, `nome_categoria`, `percentual_desconto_base`)
VALUES
    (1, 'R30', 30.00),
    (2, 'R40', 40.00),
    (9999, 'Categoria CRUD demonstracao', 5.00);

-- ----------------------------------------------------------------------------
-- ACOMPANHAMENTO DE CLIENTES
-- ----------------------------------------------------------------------------
INSERT INTO `CONDICAO_SAUDE`
    (`id_condicao`, `data_inicio_sintomas`, `data_diagnostico`,
     `historico_doenca`, `nome_condicao`, `id_cliente`)
VALUES
    (1, '2026-05-03', '2026-05-10', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 1),
    (2, '2026-05-05', '2026-05-12', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 2),
    (3, '2026-05-07', '2026-05-14', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 3),
    (4, '2026-05-09', '2026-05-16', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 4),
    (5, '2026-05-11', '2026-05-18', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 5),
    (6, '2026-05-13', '2026-05-20', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 6),
    (7, '2026-05-15', '2026-05-22', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 7),
    (8, '2026-05-17', '2026-05-24', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 8),
    (9, '2026-05-19', '2026-05-26', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 9),
    (10, '2026-05-21', '2026-05-28', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 10),
    (11, '2026-05-23', '2026-05-30', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 11),
    (12, '2026-05-25', '2026-06-01', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 12),
    (13, '2026-05-27', '2026-06-03', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 13),
    (14, '2026-05-29', '2026-06-05', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 14),
    (15, '2026-05-31', '2026-06-07', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 15),
    (16, '2026-06-02', '2026-06-09', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 16),
    (17, '2026-06-04', '2026-06-11', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 17),
    (18, '2026-06-06', '2026-06-13', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 18),
    (19, '2026-06-08', '2026-06-15', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 19),
    (20, '2026-06-10', '2026-06-17', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 20),
    (21, '2026-06-12', '2026-06-19', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 21),
    (22, '2026-06-14', '2026-06-21', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 22),
    (23, '2026-06-16', '2026-06-23', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 23),
    (24, '2026-06-18', '2026-06-25', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 24),
    (25, '2026-06-20', '2026-06-27', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 25),
    (26, '2026-06-22', '2026-06-29', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 26),
    (27, '2026-06-24', '2026-07-01', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 27),
    (28, '2026-06-26', '2026-07-03', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 28),
    (29, '2026-06-28', '2026-07-05', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 29),
    (30, '2026-06-30', '2026-07-07', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 30),
    (31, '2026-07-02', '2026-07-09', 'Historico ficticio para teste', 'Rinite (exemplo ficticio)', 31),
    (32, '2026-07-04', '2026-07-11', 'Historico ficticio para teste', 'Alergia sazonal (exemplo ficticio)', 32),
    (33, '2026-07-06', '2026-07-13', 'Historico ficticio para teste', 'Hipertensao (exemplo ficticio)', 33),
    (34, '2026-07-08', '2026-07-15', 'Historico ficticio para teste', 'Gastrite (exemplo ficticio)', 34),
    (35, '2026-07-10', '2026-07-17', 'Historico ficticio para teste', 'Enxaqueca (exemplo ficticio)', 35),
    (36, '2026-07-12', '2026-07-19', 'Historico ficticio para teste', 'Intolerancia alimentar (exemplo ficticio)', 36);

INSERT INTO `CONDICAO_SINTOMA`
    (`id_condicao_sintoma`, `sintoma`, `id_condicao`)
VALUES
    (1, 'Espirros (exemplo)', 1),
    (2, 'Irritacao (exemplo)', 2),
    (3, 'Pressao elevada (exemplo)', 3),
    (4, 'Desconforto abdominal (exemplo)', 4),
    (5, 'Dor de cabeca (exemplo)', 5),
    (6, 'Desconforto digestivo (exemplo)', 6),
    (7, 'Espirros (exemplo)', 7),
    (8, 'Irritacao (exemplo)', 8),
    (9, 'Pressao elevada (exemplo)', 9),
    (10, 'Desconforto abdominal (exemplo)', 10),
    (11, 'Dor de cabeca (exemplo)', 11),
    (12, 'Desconforto digestivo (exemplo)', 12),
    (13, 'Espirros (exemplo)', 13),
    (14, 'Irritacao (exemplo)', 14),
    (15, 'Pressao elevada (exemplo)', 15),
    (16, 'Desconforto abdominal (exemplo)', 16),
    (17, 'Dor de cabeca (exemplo)', 17),
    (18, 'Desconforto digestivo (exemplo)', 18),
    (19, 'Espirros (exemplo)', 19),
    (20, 'Irritacao (exemplo)', 20),
    (21, 'Pressao elevada (exemplo)', 21),
    (22, 'Desconforto abdominal (exemplo)', 22),
    (23, 'Dor de cabeca (exemplo)', 23),
    (24, 'Desconforto digestivo (exemplo)', 24),
    (25, 'Espirros (exemplo)', 25),
    (26, 'Irritacao (exemplo)', 26),
    (27, 'Pressao elevada (exemplo)', 27),
    (28, 'Desconforto abdominal (exemplo)', 28),
    (29, 'Dor de cabeca (exemplo)', 29),
    (30, 'Desconforto digestivo (exemplo)', 30),
    (31, 'Espirros (exemplo)', 31),
    (32, 'Irritacao (exemplo)', 32),
    (33, 'Pressao elevada (exemplo)', 33),
    (34, 'Desconforto abdominal (exemplo)', 34),
    (35, 'Dor de cabeca (exemplo)', 35),
    (36, 'Desconforto digestivo (exemplo)', 36);

INSERT INTO `CONDICAO_MEDICAMENTO`
    (`id_condicao_medicamento`, `medicamento`, `id_condicao`)
VALUES
    (1, 'Medicamento ficticio A', 2),
    (2, 'Medicamento ficticio B', 4),
    (3, 'Medicamento ficticio C', 6),
    (4, 'Medicamento ficticio D', 8),
    (5, 'Medicamento ficticio E', 10),
    (6, 'Medicamento ficticio F', 12),
    (7, 'Medicamento ficticio A', 14),
    (8, 'Medicamento ficticio B', 16),
    (9, 'Medicamento ficticio C', 18),
    (10, 'Medicamento ficticio D', 20),
    (11, 'Medicamento ficticio E', 22),
    (12, 'Medicamento ficticio F', 24),
    (13, 'Medicamento ficticio A', 26),
    (14, 'Medicamento ficticio B', 28),
    (15, 'Medicamento ficticio C', 30),
    (16, 'Medicamento ficticio D', 32),
    (17, 'Medicamento ficticio E', 34),
    (18, 'Medicamento ficticio F', 36);

INSERT INTO `CONDICAO_ALERGIA`
    (`id_condicao_alergia`, `alergia`, `id_condicao`)
VALUES
    (1, 'Poeira (exemplo)', 3),
    (2, 'Polen ambiental (exemplo)', 6),
    (3, 'Lactose (exemplo)', 9),
    (4, 'Fragrancia (exemplo)', 12),
    (5, 'Acidos (exemplo)', 15),
    (6, 'Corante (exemplo)', 18),
    (7, 'Poeira (exemplo)', 21),
    (8, 'Polen ambiental (exemplo)', 24),
    (9, 'Lactose (exemplo)', 27),
    (10, 'Fragrancia (exemplo)', 30),
    (11, 'Acidos (exemplo)', 33),
    (12, 'Corante (exemplo)', 36);

INSERT INTO `VISITA`
    (`id_visita`, `data_visita`, `observacoes`, `data_proxima_visita`, `id_cliente`)
VALUES
    (1, '2026-07-01', 'Acompanhamento ficticio do cliente 1', '2026-08-30', 1),
    (2, '2026-07-04', 'Acompanhamento ficticio do cliente 2', '2026-09-02', 2),
    (3, '2026-07-07', 'Acompanhamento ficticio do cliente 3', '2026-09-05', 3),
    (4, '2026-07-10', 'Acompanhamento ficticio do cliente 4', '2026-09-08', 4),
    (5, '2026-07-13', 'Acompanhamento ficticio do cliente 5', '2026-09-11', 5),
    (6, '2026-07-16', 'Acompanhamento ficticio do cliente 6', '2026-09-14', 6),
    (7, '2026-07-19', 'Acompanhamento ficticio do cliente 7', '2026-09-17', 7),
    (8, '2026-07-22', 'Acompanhamento ficticio do cliente 8', '2026-09-20', 8),
    (9, '2026-07-25', 'Acompanhamento ficticio do cliente 9', '2026-09-23', 9),
    (10, '2026-07-28', 'Acompanhamento ficticio do cliente 10', '2026-09-26', 10),
    (11, '2026-07-31', 'Acompanhamento ficticio do cliente 11', '2026-09-29', 11),
    (12, '2026-08-03', 'Acompanhamento ficticio do cliente 12', '2026-10-02', 12),
    (13, '2026-08-06', 'Acompanhamento ficticio do cliente 13', '2026-10-05', 13),
    (14, '2026-08-09', 'Acompanhamento ficticio do cliente 14', '2026-10-08', 14),
    (15, '2026-08-12', 'Acompanhamento ficticio do cliente 15', '2026-10-11', 15),
    (16, '2026-08-15', 'Acompanhamento ficticio do cliente 16', '2026-10-14', 16),
    (17, '2026-08-18', 'Acompanhamento ficticio do cliente 17', '2026-10-17', 17),
    (18, '2026-08-21', 'Acompanhamento ficticio do cliente 18', '2026-10-20', 18),
    (19, '2026-08-24', 'Acompanhamento ficticio do cliente 19', '2026-10-23', 19),
    (20, '2026-08-27', 'Acompanhamento ficticio do cliente 20', '2026-10-26', 20),
    (21, '2026-08-30', 'Acompanhamento ficticio do cliente 21', '2026-10-29', 21),
    (22, '2026-09-02', 'Acompanhamento ficticio do cliente 22', '2026-11-01', 22),
    (23, '2026-09-05', 'Acompanhamento ficticio do cliente 23', '2026-11-04', 23),
    (24, '2026-09-08', 'Acompanhamento ficticio do cliente 24', '2026-11-07', 24),
    (25, '2026-09-11', 'Acompanhamento ficticio do cliente 25', '2026-11-10', 25),
    (26, '2026-09-14', 'Acompanhamento ficticio do cliente 26', '2026-11-13', 26),
    (27, '2026-09-17', 'Acompanhamento ficticio do cliente 27', '2026-11-16', 27),
    (28, '2026-09-20', 'Acompanhamento ficticio do cliente 28', '2026-11-19', 28),
    (29, '2026-09-23', 'Acompanhamento ficticio do cliente 29', '2026-11-22', 29),
    (30, '2026-09-26', 'Acompanhamento ficticio do cliente 30', '2026-11-25', 30),
    (31, '2026-09-29', 'Acompanhamento ficticio do cliente 31', '2026-11-28', 31),
    (32, '2026-10-02', 'Acompanhamento ficticio do cliente 32', '2026-12-01', 32),
    (33, '2026-10-05', 'Acompanhamento ficticio do cliente 33', '2026-12-04', 33),
    (34, '2026-10-08', 'Acompanhamento ficticio do cliente 34', '2026-12-07', 34),
    (35, '2026-10-11', 'Acompanhamento ficticio do cliente 35', '2026-12-10', 35),
    (36, '2026-10-14', 'Acompanhamento ficticio do cliente 36', '2026-12-13', 36),
    (37, '2026-10-17', 'Acompanhamento ficticio do cliente 37', '2026-12-16', 37),
    (38, '2026-10-20', 'Acompanhamento ficticio do cliente 38', NULL, 38),
    (39, '2026-10-23', 'Acompanhamento ficticio do cliente 39', NULL, 39),
    (40, '2026-10-26', 'Acompanhamento ficticio do cliente 40', NULL, 40);

-- ----------------------------------------------------------------------------
-- VENDAS
-- 40 vendas ligadas a 40 clientes diferentes.
-- Cada venda possui produto e pagamento correspondente.
-- ----------------------------------------------------------------------------
INSERT INTO `VENDA` (`id_venda`, `data_venda`, `id_cliente`)
VALUES
    (1, '2026-07-05', 1),
    (2, '2026-07-08', 2),
    (3, '2026-07-11', 3),
    (4, '2026-07-14', 4),
    (5, '2026-07-17', 5),
    (6, '2026-07-20', 6),
    (7, '2026-07-23', 7),
    (8, '2026-07-26', 8),
    (9, '2026-07-29', 9),
    (10, '2026-08-01', 10),
    (11, '2026-08-04', 11),
    (12, '2026-08-07', 12),
    (13, '2026-08-10', 13),
    (14, '2026-08-13', 14),
    (15, '2026-08-16', 15),
    (16, '2026-08-19', 16),
    (17, '2026-08-22', 17),
    (18, '2026-08-25', 18),
    (19, '2026-08-28', 19),
    (20, '2026-08-31', 20),
    (21, '2026-09-03', 21),
    (22, '2026-09-06', 22),
    (23, '2026-09-09', 23),
    (24, '2026-09-12', 24),
    (25, '2026-09-15', 25),
    (26, '2026-09-18', 26),
    (27, '2026-09-21', 27),
    (28, '2026-09-24', 28),
    (29, '2026-09-27', 29),
    (30, '2026-09-30', 30),
    (31, '2026-10-03', 31),
    (32, '2026-10-06', 32),
    (33, '2026-10-09', 33),
    (34, '2026-10-12', 34),
    (35, '2026-10-15', 35),
    (36, '2026-10-18', 36),
    (37, '2026-10-21', 37),
    (38, '2026-10-24', 38),
    (39, '2026-10-27', 39),
    (40, '2026-10-30', 40);

INSERT INTO `VENDA_PRODUTO`
    (`id_venda`, `id_produto`, `quantidade`, `preco_tabela`,
     `preco_vendido`, `desconto_aplicado`)
VALUES
    (1, 1, 1, 89.90, 89.90, 0.00),
    (2, 2, 2, 69.90, 68.90, 1.00),
    (3, 3, 1, 39.90, 37.90, 2.00),
    (4, 4, 3, 74.90, 74.90, 0.00),
    (5, 5, 1, 54.90, 53.90, 1.00),
    (6, 1, 2, 89.90, 87.90, 2.00),
    (7, 2, 1, 69.90, 69.90, 0.00),
    (8, 3, 3, 39.90, 38.90, 1.00),
    (9, 4, 1, 74.90, 72.90, 2.00),
    (10, 5, 2, 54.90, 54.90, 0.00),
    (11, 1, 1, 89.90, 88.90, 1.00),
    (12, 2, 3, 69.90, 67.90, 2.00),
    (13, 3, 1, 39.90, 39.90, 0.00),
    (14, 4, 2, 74.90, 73.90, 1.00),
    (15, 5, 1, 54.90, 52.90, 2.00),
    (16, 1, 3, 89.90, 89.90, 0.00),
    (17, 2, 1, 69.90, 68.90, 1.00),
    (18, 3, 2, 39.90, 37.90, 2.00),
    (19, 4, 1, 74.90, 74.90, 0.00),
    (20, 5, 3, 54.90, 53.90, 1.00),
    (21, 1, 1, 89.90, 87.90, 2.00),
    (22, 2, 2, 69.90, 69.90, 0.00),
    (23, 3, 1, 39.90, 38.90, 1.00),
    (24, 4, 3, 74.90, 72.90, 2.00),
    (25, 5, 1, 54.90, 54.90, 0.00),
    (26, 1, 2, 89.90, 88.90, 1.00),
    (27, 2, 1, 69.90, 67.90, 2.00),
    (28, 3, 3, 39.90, 39.90, 0.00),
    (29, 4, 1, 74.90, 73.90, 1.00),
    (30, 5, 2, 54.90, 52.90, 2.00),
    (31, 1, 1, 89.90, 89.90, 0.00),
    (32, 2, 3, 69.90, 68.90, 1.00),
    (33, 3, 1, 39.90, 37.90, 2.00),
    (34, 4, 2, 74.90, 74.90, 0.00),
    (35, 5, 1, 54.90, 53.90, 1.00),
    (36, 1, 3, 89.90, 87.90, 2.00),
    (37, 2, 1, 69.90, 69.90, 0.00),
    (38, 3, 2, 39.90, 38.90, 1.00),
    (39, 4, 1, 74.90, 72.90, 2.00),
    (40, 5, 3, 54.90, 54.90, 0.00);

INSERT INTO `PAGAMENTO_VENDA`
    (`id_pagamento_venda`, `data_pagamento`, `valor`, `forma_pagamento`, `id_venda`)
VALUES
    (1, '2026-07-06', 89.90, 'Pix', 1),
    (2, '2026-07-08', 137.80, 'Cartao', 2),
    (3, '2026-07-12', 37.90, 'Transferencia', 3),
    (4, '2026-07-14', 224.70, 'Dinheiro', 4),
    (5, '2026-07-18', 53.90, 'Pix', 5),
    (6, '2026-07-20', 175.80, 'Cartao', 6),
    (7, '2026-07-24', 69.90, 'Transferencia', 7),
    (8, '2026-07-26', 116.70, 'Dinheiro', 8),
    (9, '2026-07-30', 72.90, 'Pix', 9),
    (10, '2026-08-01', 109.80, 'Cartao', 10),
    (11, '2026-08-05', 88.90, 'Transferencia', 11),
    (12, '2026-08-07', 203.70, 'Dinheiro', 12),
    (13, '2026-08-11', 39.90, 'Pix', 13),
    (14, '2026-08-13', 147.80, 'Cartao', 14),
    (15, '2026-08-17', 52.90, 'Transferencia', 15),
    (16, '2026-08-19', 269.70, 'Dinheiro', 16),
    (17, '2026-08-23', 68.90, 'Pix', 17),
    (18, '2026-08-25', 75.80, 'Cartao', 18),
    (19, '2026-08-29', 74.90, 'Transferencia', 19),
    (20, '2026-08-31', 161.70, 'Dinheiro', 20),
    (21, '2026-09-04', 87.90, 'Pix', 21),
    (22, '2026-09-06', 139.80, 'Cartao', 22),
    (23, '2026-09-10', 38.90, 'Transferencia', 23),
    (24, '2026-09-12', 218.70, 'Dinheiro', 24),
    (25, '2026-09-16', 54.90, 'Pix', 25),
    (26, '2026-09-18', 177.80, 'Cartao', 26),
    (27, '2026-09-22', 67.90, 'Transferencia', 27),
    (28, '2026-09-24', 119.70, 'Dinheiro', 28),
    (29, '2026-09-28', 73.90, 'Pix', 29),
    (30, '2026-09-30', 105.80, 'Cartao', 30),
    (31, '2026-10-04', 89.90, 'Transferencia', 31),
    (32, '2026-10-06', 206.70, 'Dinheiro', 32),
    (33, '2026-10-10', 37.90, 'Pix', 33),
    (34, '2026-10-12', 149.80, 'Cartao', 34),
    (35, '2026-10-16', 53.90, 'Transferencia', 35),
    (36, '2026-10-18', 263.70, 'Dinheiro', 36),
    (37, '2026-10-22', 69.90, 'Pix', 37),
    (38, '2026-10-24', 77.80, 'Cartao', 38),
    (39, '2026-10-28', 72.90, 'Transferencia', 39),
    (40, '2026-10-30', 164.70, 'Dinheiro', 40);

-- ----------------------------------------------------------------------------
-- PEDIDOS
-- 12 pedidos: dois por representante, todos com produtos e pagamento.
-- ----------------------------------------------------------------------------
INSERT INTO `PEDIDO`
    (`id_pedido`, `numero_pedido`, `data_pedido`, `frete`,
     `status_pedido`, `id_representante`)
VALUES
    (1, 'PED-2026-001', '2026-06-10', 0.00, 'Recebido', 1),
    (2, 'PED-2026-002', '2026-06-22', 12.00, 'Retirada', 2),
    (3, 'PED-2026-003', '2026-07-04', 18.00, 'Separacao', 3),
    (4, 'PED-2026-004', '2026-07-16', 15.00, 'Em transito', 4),
    (5, 'PED-2026-005', '2026-07-28', 0.00, 'Recebido', 5),
    (6, 'PED-2026-006', '2026-08-09', 12.00, 'Retirada', 6),
    (7, 'PED-2026-007', '2026-08-21', 18.00, 'Separacao', 1),
    (8, 'PED-2026-008', '2026-09-02', 15.00, 'Em transito', 2),
    (9, 'PED-2026-009', '2026-09-14', 0.00, 'Recebido', 3),
    (10, 'PED-2026-010', '2026-09-26', 12.00, 'Retirada', 4),
    (11, 'PED-2026-011', '2026-10-08', 18.00, 'Separacao', 5),
    (12, 'PED-2026-012', '2026-10-20', 15.00, 'Em transito', 6);

INSERT INTO `PEDIDO_PRODUTO`
    (`id_pedido`, `id_produto`, `quantidade`, `valor_unitario`, `desconto_item`)
VALUES
    (1, 1, 6, 62.93, 0.00),
    (1, 2, 6, 48.93, 0.00),
    (2, 2, 7, 48.93, 0.00),
    (2, 3, 7, 27.93, 0.00),
    (3, 3, 8, 27.93, 0.00),
    (3, 4, 4, 52.43, 0.00),
    (4, 4, 5, 52.43, 0.00),
    (4, 5, 5, 38.43, 0.00),
    (5, 5, 6, 38.43, 0.00),
    (5, 1, 6, 62.93, 0.00),
    (6, 1, 7, 62.93, 0.00),
    (6, 2, 7, 48.93, 0.00),
    (7, 2, 8, 48.93, 0.00),
    (7, 3, 4, 27.93, 0.00),
    (8, 3, 5, 27.93, 0.00),
    (8, 4, 5, 52.43, 0.00),
    (9, 4, 6, 52.43, 0.00),
    (9, 5, 6, 38.43, 0.00),
    (10, 5, 7, 38.43, 0.00),
    (10, 1, 7, 62.93, 0.00),
    (11, 1, 8, 62.93, 0.00),
    (11, 2, 4, 48.93, 0.00),
    (12, 2, 5, 48.93, 0.00),
    (12, 3, 5, 27.93, 0.00);

INSERT INTO `PAGAMENTO_PEDIDO`
    (`id_pagamento_pedido`, `data_pagamento`, `valor`, `forma_pagamento`, `id_pedido`)
VALUES
    (1, '2026-06-12', 671.16, 'Boleto', 1),
    (2, '2026-06-24', 550.02, 'Pix', 2),
    (3, '2026-07-06', 451.16, 'Transferencia', 3),
    (4, '2026-07-18', 469.30, 'Boleto', 4),
    (5, '2026-07-30', 608.16, 'Pix', 5),
    (6, '2026-08-11', 795.02, 'Transferencia', 6),
    (7, '2026-08-23', 521.16, 'Boleto', 7),
    (8, '2026-09-04', 416.80, 'Pix', 8),
    (9, '2026-09-16', 545.16, 'Transferencia', 9),
    (10, '2026-09-28', 721.52, 'Boleto', 10),
    (11, '2026-10-10', 717.16, 'Pix', 11),
    (12, '2026-10-22', 399.30, 'Transferencia', 12);

-- ----------------------------------------------------------------------------
-- LOTES
-- Dois lotes por produto; os lotes utilizados nos pedidos correspondem aos produtos pedidos.
-- ----------------------------------------------------------------------------
INSERT INTO `LOTE`
    (`id_lote`, `numero_lote`, `data_fabricacao`, `data_validade`, `id_produto`)
VALUES
    (1, 'COL-EX-01', '2026-01-10', '2027-01-10', 1),
    (2, 'COL-EX-02', '2026-05-10', '2027-05-10', 1),
    (3, 'CAL-EX-01', '2026-02-04', '2027-02-04', 2),
    (4, 'CAL-EX-02', '2026-06-04', '2027-06-04', 2),
    (5, 'LEV-EX-01', '2026-03-01', '2027-03-01', 3),
    (6, 'LEV-EX-02', '2026-06-29', '2027-06-29', 3),
    (7, 'ALL-EX-01', '2026-03-26', '2026-12-20', 4),
    (8, 'ALL-EX-02', '2026-07-24', '2027-07-24', 4),
    (9, 'POL-EX-01', '2026-04-20', '2027-04-20', 5),
    (10, 'POL-EX-02', '2026-08-18', '2027-08-18', 5);

INSERT INTO `PEDIDO_LOTE`
    (`id_pedido`, `id_lote`, `quantidade_lote`)
VALUES
    (1, 2, 6),
    (1, 3, 6),
    (2, 3, 7),
    (2, 6, 7),
    (3, 6, 8),
    (3, 7, 4),
    (4, 7, 5),
    (4, 10, 5),
    (5, 10, 6),
    (5, 1, 6),
    (6, 1, 7),
    (6, 4, 7),
    (7, 4, 8),
    (7, 5, 4),
    (8, 5, 5),
    (8, 8, 5),
    (9, 8, 6),
    (9, 9, 6),
    (10, 9, 7),
    (10, 2, 7),
    (11, 2, 8),
    (11, 3, 4),
    (12, 3, 5),
    (12, 6, 5);

-- ----------------------------------------------------------------------------
-- FORNECEDORES X PRODUTOS
-- Todos os produtos possuem fornecedores relacionados.
-- ----------------------------------------------------------------------------
INSERT INTO `FORNECEDOR_PRODUTO`
    (`id_fornecedor`, `id_produto`)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 5),
    (2, 1),
    (2, 3),
    (2, 4),
    (3, 2),
    (3, 4),
    (3, 5);

INSERT INTO `QUALIFICACAO_FORNECEDOR`
    (`id_qualificacao_fornecedor`, `data_qualificacao`, `status`, `observacao`, `id_fornecedor`)
VALUES
    (1, '2026-05-01', 'Aprovado', 'Avaliacao ficticia', 1),
    (2, '2026-10-01', 'Aprovado', 'Reavaliacao ficticia', 1),
    (3, '2026-05-03', 'Aprovado', 'Avaliacao ficticia', 2),
    (4, '2026-10-03', 'Aprovado', 'Reavaliacao ficticia', 2),
    (5, '2026-05-05', 'Aprovado', 'Avaliacao ficticia', 3),
    (6, '2026-10-05', 'Aprovado', 'Reavaliacao ficticia', 3);

INSERT INTO `FORNECEDOR_FORMA_PAGAMENTO`
    (`id_forma_pagamento`, `forma_pagamento`, `id_fornecedor`)
VALUES
    (1, 'Pix', 1),
    (2, 'Boleto', 1),
    (3, 'Pix', 2),
    (4, 'Transferencia', 2),
    (5, 'Boleto', 3),
    (6, 'Transferencia', 3);

-- ----------------------------------------------------------------------------
-- INGRESSO, QUALIFICACAO E ATIVIDADE MENSAL
-- ----------------------------------------------------------------------------
INSERT INTO `INGRESSO`
    (`id_ingresso`, `data_ingresso`, `valor_kit`, `quantidade_parcelas`,
     `status_pagamento`, `id_representante`)
VALUES
    (1, '2026-01-10', 500.00, 1, 'Quitado', 1),
    (2, '2026-02-05', 500.00, 2, 'Quitado', 2),
    (3, '2026-03-12', 500.00, 1, 'Quitado', 3),
    (4, '2026-04-18', 500.00, 2, 'Quitado', 4),
    (5, '2026-05-09', 500.00, 1, 'Quitado', 5),
    (6, '2026-06-21', 500.00, 2, 'Quitado', 6);

INSERT INTO `QUALIFICACAO`
    (`id_qualificacao`, `data_qualificacao`, `tipo_qualificacao`, `valor_base`,
     `id_representante`, `id_categoria`, `id_treinador`)
VALUES
    (1, '2026-01-10', 'Ingresso / R30', 500.00, 1, 1, NULL),
    (2, '2026-02-05', 'Ingresso / R30', 500.00, 2, 1, NULL),
    (3, '2026-03-12', 'Ingresso / R30', 500.00, 3, 1, NULL),
    (4, '2026-04-18', 'Ingresso / R30', 500.00, 4, 1, NULL),
    (5, '2026-05-09', 'Ingresso / R30', 500.00, 5, 1, NULL),
    (6, '2026-06-21', 'Ingresso / R30', 500.00, 6, 1, NULL),
    (7, '2026-08-10', 'Evolucao / R40', 1000.00, 1, 2, 2),
    (8, '2026-08-20', 'Evolucao / R40', 1050.00, 2, 2, 1),
    (9, '2026-09-01', 'Evolucao / R40', 1100.00, 3, 2, 1),
    (10, '2026-09-12', 'Evolucao / R40', 1150.00, 4, 2, 2),
    (11, '2026-10-02', 'Evolucao / R40', 1200.00, 5, 2, 3),
    (12, '2026-10-15', 'Evolucao / R40', 1250.00, 6, 2, 3);

INSERT INTO `ATIVIDADE_MENSAL`
    (`id_atividade`, `mes_referencia`, `ano_referencia`, `status_atividade`, `id_representante`)
VALUES
    (1, 10, 2026, 'Ativo', 1),
    (2, 10, 2026, 'Ativo', 2),
    (3, 10, 2026, 'Ativo', 3),
    (4, 10, 2026, 'Ativo', 4),
    (5, 10, 2026, 'Ativo', 5),
    (6, 10, 2026, 'Ativo', 6),
    (7, 11, 2026, 'Ativo', 1),
    (8, 11, 2026, 'Ativo', 2),
    (9, 11, 2026, 'Ativo', 3),
    (10, 11, 2026, 'Ativo', 4),
    (11, 11, 2026, 'Ativo', 5),
    (12, 11, 2026, 'Ativo', 6);

-- ----------------------------------------------------------------------------
-- COMISSOES
-- Valores ficticios para demonstracao; formulas comerciais reais nao foram informadas.
-- ----------------------------------------------------------------------------
INSERT INTO `COMISSAO`
    (`id_comissao`, `tipo_comissao`, `valor_base`, `percentual`,
     `data_geracao`, `status`, `data_pagamento`, `id_representante`)
VALUES
    (1, 'Venda', 489.30, 6.00, '2026-10-26', 'Paga', '2026-11-02', 1),
    (2, 'Equipe', 575.00, 4.00, '2026-11-02', 'Paga', '2026-11-09', 1),
    (3, 'Venda', 1026.30, 6.00, '2026-10-27', 'Paga', '2026-11-03', 2),
    (4, 'Equipe', 650.00, 4.00, '2026-11-03', 'Pendente', NULL, 2),
    (5, 'Venda', 430.30, 6.00, '2026-10-28', 'Paga', '2026-11-04', 3),
    (6, 'Equipe', 725.00, 4.00, '2026-11-04', 'Paga', '2026-11-11', 3),
    (7, 'Venda', 1178.20, 6.00, '2026-10-29', 'Paga', '2026-11-05', 4),
    (8, 'Equipe', 800.00, 4.00, '2026-11-05', 'Pendente', NULL, 4),
    (9, 'Venda', 378.40, 6.00, '2026-10-30', 'Paga', '2026-11-06', 5),
    (10, 'Equipe', 875.00, 4.00, '2026-11-06', 'Pendente', NULL, 5),
    (11, 'Venda', 1043.50, 6.00, '2026-10-31', 'Paga', '2026-11-07', 6),
    (12, 'Equipe', 950.00, 4.00, '2026-11-07', 'Pendente', NULL, 6);

COMMIT;

-- ============================================================================
-- 7. SELECT COM JOIN
-- Consulta relacional de demonstracao antes dos exemplos de UPDATE e DELETE.
-- ============================================================================

SELECT c.`id_cliente`,
       c.`nome` AS cliente,
       r.`nome` AS representante
FROM `CLIENTE` AS c
INNER JOIN `REPRESENTANTE` AS r
    ON r.`id_representante` = c.`id_representante`
ORDER BY c.`nome`;

-- ============================================================================
-- 8. UPDATE E DELETE
-- A categoria 9999 foi incluida na massa de dados apenas para demonstrar
-- UPDATE e DELETE sem alterar os registros principais do projeto.
-- ============================================================================

-- UPDATE: altera o percentual do registro temporario.
UPDATE `CATEGORIA`
SET `percentual_desconto_base` = 10.00
WHERE `id_categoria` = 9999;

-- SELECT: verifica a alteracao.
SELECT `id_categoria`, `nome_categoria`, `percentual_desconto_base`
FROM `CATEGORIA`
WHERE `id_categoria` = 9999;

-- DELETE: remove o registro temporario.
DELETE FROM `CATEGORIA`
WHERE `id_categoria` = 9999;

-- SELECT: deve retornar 0 linhas.
SELECT *
FROM `CATEGORIA`
WHERE `id_categoria` = 9999;

-- ============================================================================
-- 9. CONSULTAS GERENCIAIS
-- ============================================================================

-- G01 — Quais clientes estao vinculados a cada representante?
-- Atende: P2 — centralizacao das informacoes de clientes e representantes.
SELECT c.`id_cliente`,
       c.`nome` AS cliente,
       r.`nome` AS representante
FROM `CLIENTE` AS c
INNER JOIN `REPRESENTANTE` AS r
    ON r.`id_representante` = c.`id_representante`
ORDER BY r.`nome`, c.`nome`;

-- G02 — Quantas vendas cada cliente realizou e qual receita ele gerou?
-- Atende: KPI — receita gerada por cliente.
SELECT c.`id_cliente`,
       c.`nome` AS cliente,
       COUNT(DISTINCT v.`id_venda`) AS numero_vendas,
       COALESCE(SUM(vp.`quantidade` * vp.`preco_vendido`), 0.00) AS receita_total
FROM `CLIENTE` AS c
LEFT JOIN `VENDA` AS v
    ON v.`id_cliente` = c.`id_cliente`
LEFT JOIN `VENDA_PRODUTO` AS vp
    ON vp.`id_venda` = v.`id_venda`
GROUP BY c.`id_cliente`, c.`nome`
ORDER BY receita_total DESC, c.`nome`;

-- G03 — Quais produtos tiveram maior volume de vendas?
-- Atende: KPI — produtos com maior volume de vendas.
SELECT p.`id_produto`,
       p.`nome_produto`,
       SUM(vp.`quantidade`) AS unidades_vendidas,
       SUM(vp.`quantidade` * vp.`preco_vendido`) AS faturamento,
       ROUND(
           SUM(vp.`quantidade` * vp.`preco_vendido`)
           / NULLIF(SUM(vp.`quantidade`), 0),
           2
       ) AS preco_medio_vendido
FROM `VENDA_PRODUTO` AS vp
INNER JOIN `PRODUTO` AS p
    ON p.`id_produto` = vp.`id_produto`
GROUP BY p.`id_produto`, p.`nome_produto`
ORDER BY unidades_vendidas DESC, faturamento DESC;

-- G04 — Qual foi o faturamento das vendas em cada dia?
-- Atende: KPI — faturamento por periodo.
SELECT v.`data_venda`,
       COUNT(DISTINCT v.`id_venda`) AS total_vendas,
       SUM(vp.`quantidade` * vp.`preco_vendido`) AS faturamento_dia
FROM `VENDA` AS v
INNER JOIN `VENDA_PRODUTO` AS vp
    ON vp.`id_venda` = v.`id_venda`
GROUP BY v.`data_venda`
ORDER BY v.`data_venda`;

-- G05 — Qual e o valor total de cada pedido e qual e sua situacao?
-- Atende: P2 — centralizacao do acompanhamento de pedidos.
SELECT ped.`id_pedido`,
       ped.`numero_pedido`,
       ped.`status_pedido`,
       COALESCE(
           SUM(pp.`quantidade` * (pp.`valor_unitario` - pp.`desconto_item`)),
           0.00
       ) AS valor_itens,
       ped.`frete`,
       COALESCE(
           SUM(pp.`quantidade` * (pp.`valor_unitario` - pp.`desconto_item`)),
           0.00
       ) + ped.`frete` AS total_pedido
FROM `PEDIDO` AS ped
LEFT JOIN `PEDIDO_PRODUTO` AS pp
    ON pp.`id_pedido` = ped.`id_pedido`
GROUP BY ped.`id_pedido`,
         ped.`numero_pedido`,
         ped.`status_pedido`,
         ped.`frete`
ORDER BY ped.`data_pedido`, ped.`id_pedido`;

-- G06 — Quais lotes vencem nos proximos 60 dias?
-- Atende: KPI — lotes proximos da validade.
SELECT p.`nome_produto`,
       l.`numero_lote`,
       l.`data_validade`,
       DATEDIFF(l.`data_validade`, CURRENT_DATE()) AS dias_para_vencer
FROM `LOTE` AS l
INNER JOIN `PRODUTO` AS p
    ON p.`id_produto` = l.`id_produto`
WHERE l.`data_validade`
      BETWEEN CURRENT_DATE()
      AND DATE_ADD(CURRENT_DATE(), INTERVAL 60 DAY)
ORDER BY l.`data_validade`;

-- G07 — Quais comissoes ainda estao pendentes e qual e o valor calculado?
-- Atende: P1 — controle e pagamento de comissoes.
-- Atende: KPI — valor de comissoes pendentes.
SELECT r.`nome` AS representante,
       cm.`tipo_comissao`,
       cm.`valor_base`,
       cm.`percentual`,
       ROUND(cm.`valor_base` * cm.`percentual` / 100, 2) AS valor_comissao,
       cm.`data_geracao`,
       cm.`status`
FROM `COMISSAO` AS cm
INNER JOIN `REPRESENTANTE` AS r
    ON r.`id_representante` = cm.`id_representante`
WHERE cm.`status` = 'Pendente'
ORDER BY cm.`data_geracao`, r.`nome`;

-- G08 — Quais informacoes de acompanhamento existem para clientes com visita registrada?
-- Atende: P2 — centralizacao das informacoes de acompanhamento.
SELECT c.`nome` AS cliente,
       cs.`nome_condicao` AS nome_condicao,
       DATE_FORMAT(vi.`data_visita`, '%d/%m/%Y') AS data_visita,
       DATE_FORMAT(vi.`data_proxima_visita`, '%d/%m/%Y') AS data_proxima_visita
FROM `CLIENTE` AS c
INNER JOIN `VISITA` AS vi
    ON vi.`id_cliente` = c.`id_cliente`
LEFT JOIN `CONDICAO_SAUDE` AS cs
    ON cs.`id_cliente` = c.`id_cliente`
ORDER BY c.`nome`, vi.`data_visita`;

-- Observacao:
-- se houver mais de uma condicao ou visita para o mesmo cliente,
-- a consulta apresenta as combinacoes encontradas. Isso nao significa
-- que uma visita especifica esteja clinicamente ligada a uma condicao.

-- G09 — Quais clientes ultrapassaram a data prevista de proxima compra?
-- Atende: KPI — clientes com recompra prevista em atraso.
SELECT c.`id_cliente`,
       c.`nome`,
       c.`data_prevista_proxima_compra`,
       r.`nome` AS representante
FROM `CLIENTE` AS c
INNER JOIN `REPRESENTANTE` AS r
    ON r.`id_representante` = c.`id_representante`
WHERE c.`data_prevista_proxima_compra` IS NOT NULL
  AND c.`data_prevista_proxima_compra` < CURRENT_DATE()
ORDER BY c.`data_prevista_proxima_compra`;

-- ============================================================================
-- 10. CONSULTAS DE AUDITORIA
-- ============================================================================

-- A01 — Existem vendas em que o total pago difere do total dos itens?
-- Verifica: RN34 — preservacao e rastreabilidade dos registros de pagamento.
-- Observacao: diferenca pode representar pagamento parcial e nao prova fraude.
SELECT v.`id_venda`,
       c.`nome` AS cliente,
       COALESCE(itens.`total_itens`, 0.00) AS total_itens,
       COALESCE(pagos.`total_pago`, 0.00) AS total_pago,
       COALESCE(itens.`total_itens`, 0.00)
       - COALESCE(pagos.`total_pago`, 0.00) AS diferenca
FROM `VENDA` AS v
INNER JOIN `CLIENTE` AS c
    ON c.`id_cliente` = v.`id_cliente`
LEFT JOIN (
    SELECT `id_venda`,
           SUM(`quantidade` * `preco_vendido`) AS total_itens
    FROM `VENDA_PRODUTO`
    GROUP BY `id_venda`
) AS itens
    ON itens.`id_venda` = v.`id_venda`
LEFT JOIN (
    SELECT `id_venda`,
           SUM(`valor`) AS total_pago
    FROM `PAGAMENTO_VENDA`
    GROUP BY `id_venda`
) AS pagos
    ON pagos.`id_venda` = v.`id_venda`
WHERE ABS(
    COALESCE(itens.`total_itens`, 0.00)
    - COALESCE(pagos.`total_pago`, 0.00)
) > 0.009
ORDER BY v.`id_venda`;

-- A02 — Existem produtos sem nenhum fornecedor relacionado?
-- Verifica: RN35 — relacionamento entre fornecedores e produtos.
SELECT p.`id_produto`,
       p.`nome_produto`
FROM `PRODUTO` AS p
LEFT JOIN `FORNECEDOR_PRODUTO` AS fp
    ON fp.`id_produto` = p.`id_produto`
WHERE fp.`id_produto` IS NULL
ORDER BY p.`nome_produto`;

-- A03 — Existe pedido registrado sem nenhum produto?
-- Verifica: RN19 — cada pedido deve conter pelo menos um produto.
SELECT ped.`id_pedido`,
       ped.`numero_pedido`,
       ped.`status_pedido`
FROM `PEDIDO` AS ped
LEFT JOIN `PEDIDO_PRODUTO` AS pp
    ON pp.`id_pedido` = ped.`id_pedido`
WHERE pp.`id_pedido` IS NULL;

-- A04 — Existe venda registrada sem nenhum produto?
-- Verifica: RN27 — cada venda deve possuir pelo menos um produto.
SELECT v.`id_venda`,
       v.`data_venda`,
       c.`nome` AS cliente
FROM `VENDA` AS v
INNER JOIN `CLIENTE` AS c
    ON c.`id_cliente` = v.`id_cliente`
LEFT JOIN `VENDA_PRODUTO` AS vp
    ON vp.`id_venda` = v.`id_venda`
WHERE vp.`id_venda` IS NULL;

-- ============================================================================
-- 11. VIEWS (VISUALIZACOES UTEIS, EM SUBSTITUICAO A view1/view2 VAZIAS)
-- ============================================================================

CREATE OR REPLACE VIEW `vw_resumo_vendas` AS
SELECT v.`id_venda`, v.`data_venda`, c.`nome` AS cliente,
       COALESCE(SUM(vp.`quantidade` * vp.`preco_vendido`), 0.00) AS valor_total
FROM `VENDA` AS v
INNER JOIN `CLIENTE` AS c ON c.`id_cliente` = v.`id_cliente`
LEFT JOIN `VENDA_PRODUTO` AS vp ON vp.`id_venda` = v.`id_venda`
GROUP BY v.`id_venda`, v.`data_venda`, c.`nome`;

CREATE OR REPLACE VIEW `vw_lotes_validade` AS
SELECT l.`id_lote`, l.`numero_lote`, p.`nome_produto`,
       l.`data_fabricacao`, l.`data_validade`
FROM `LOTE` AS l
INNER JOIN `PRODUTO` AS p ON p.`id_produto` = l.`id_produto`;

-- Consultas finais de verificacao.
SELECT * FROM `vw_resumo_vendas` ORDER BY `id_venda`;
SELECT * FROM `vw_lotes_validade` ORDER BY `data_validade`;
SHOW TABLES;


-- ============================================================================
-- 12. VERIFICACAO FINAL
-- ============================================================================

SELECT DATABASE() AS banco_em_uso;

SELECT COUNT(*) AS total_tabelas
FROM information_schema.tables
WHERE table_schema = DATABASE()
  AND table_type = 'BASE TABLE';

SELECT COUNT(*) AS total_clientes FROM `CLIENTE`;
SELECT COUNT(*) AS total_representantes FROM `REPRESENTANTE`;
SELECT COUNT(*) AS total_produtos FROM `PRODUTO`;
SELECT COUNT(*) AS total_pedidos FROM `PEDIDO`;
SELECT COUNT(*) AS total_vendas FROM `VENDA`;
SELECT COUNT(*) AS total_comissoes FROM `COMISSAO`;

SELECT COUNT(*) AS total_visitas FROM `VISITA`;
SELECT COUNT(*) AS total_condicoes_saude FROM `CONDICAO_SAUDE`;
SELECT COUNT(*) AS total_pagamentos_venda FROM `PAGAMENTO_VENDA`;

SELECT COUNT(*) AS total_vendas,
       COUNT(DISTINCT `id_cliente`) AS clientes_diferentes_que_compraram
FROM `VENDA`;

SELECT COUNT(*) AS clientes_sem_venda
FROM `CLIENTE` AS c
LEFT JOIN `VENDA` AS v
    ON v.`id_cliente` = c.`id_cliente`
WHERE v.`id_venda` IS NULL;

-- Resultados esperados na carga ficticia:
-- total_tabelas = 25
-- total_clientes = 60
-- total_representantes = 6
-- total_produtos = 5
-- total_pedidos = 12
-- total_vendas = 40
-- total_comissoes = 12
-- total_visitas = 40
-- total_condicoes_saude = 36
-- total_pagamentos_venda = 40
-- total_vendas = 40 e clientes_diferentes_que_compraram = 40
-- clientes_sem_venda = 20

-- FIM DO SCRIPT - TRATTOS - ENTREGA 2
