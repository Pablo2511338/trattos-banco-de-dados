-- ============================================================================
-- TRATTOS - BANCO DE DADOS ENTREGA 2 
-- ============================================================================
CREATE DATABASE IF NOT EXISTS `trattos_db`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `trattos_db`;

-- ============================================================================
-- 1. TABELAS PRINCIPAIS / CADASTROS
-- ============================================================================

CREATE TABLE IF NOT EXISTS `REPRESENTANTE` (
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

CREATE TABLE IF NOT EXISTS `CLIENTE` (
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

CREATE TABLE IF NOT EXISTS `PRODUTO` (
    `id_produto` INT NOT NULL AUTO_INCREMENT,
    `nome_produto` VARCHAR(120) NOT NULL,
    `preco_tabela` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_produto`),
    CONSTRAINT `chk_produto_preco` CHECK (`preco_tabela` >= 0),
    INDEX `idx_produto_nome` (`nome_produto`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `FORNECEDOR` (
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

CREATE TABLE IF NOT EXISTS `CATEGORIA` (
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

CREATE TABLE IF NOT EXISTS `CONDICAO_SAUDE` (
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

CREATE TABLE IF NOT EXISTS `CONDICAO_ALERGIA` (
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

CREATE TABLE IF NOT EXISTS `CONDICAO_MEDICAMENTO` (
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

CREATE TABLE IF NOT EXISTS `CONDICAO_SINTOMA` (
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

CREATE TABLE IF NOT EXISTS `VISITA` (
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

CREATE TABLE IF NOT EXISTS `VENDA` (
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
CREATE TABLE IF NOT EXISTS `VENDA_PRODUTO` (
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
CREATE TABLE IF NOT EXISTS `PAGAMENTO_VENDA` (
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

CREATE TABLE IF NOT EXISTS `PEDIDO` (
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

CREATE TABLE IF NOT EXISTS `PEDIDO_PRODUTO` (
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

CREATE TABLE IF NOT EXISTS `PAGAMENTO_PEDIDO` (
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

CREATE TABLE IF NOT EXISTS `LOTE` (
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

CREATE TABLE IF NOT EXISTS `PEDIDO_LOTE` (
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

CREATE TABLE IF NOT EXISTS `FORNECEDOR_PRODUTO` (
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
CREATE TABLE IF NOT EXISTS `QUALIFICACAO_FORNECEDOR` (
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

CREATE TABLE IF NOT EXISTS `FORNECEDOR_FORMA_PAGAMENTO` (
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

CREATE TABLE IF NOT EXISTS `INGRESSO` (
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

CREATE TABLE IF NOT EXISTS `QUALIFICACAO` (
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
CREATE TABLE IF NOT EXISTS `ATIVIDADE_MENSAL` (
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

CREATE TABLE IF NOT EXISTS `COMISSAO` (
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
-- INSERT IGNORE torna a carga demonstrativa repetivel sem duplicar IDs.
-- ============================================================================

START TRANSACTION;

-- ----------------------------------------------------------------------------
-- REPRESENTANTES
-- Dados ficticios para demonstracao academica.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `REPRESENTANTE`
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
-- Os clientes 11 a 60 ficam sem venda para demonstrar clientes sem compras.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `CLIENTE`
    (`id_cliente`, `nome`, `data_nascimento`, `data_cadastro`, `cpf`, `email`, `rg`,
     `telefone`, `whatsapp`, `endereco`, `data_prevista_proxima_compra`,
     `id_representante`)
VALUES
    (1, 'Marina Costa (ficticioa)', '1981-06-08', '2026-01-05', '10000000001',
     'cliente01.teste@example.com', 'RG-FIC-001', '11920000001', '11930000001',
     'Rua Ficticia 1, 10', '2026-09-07', 1),
    (2, 'Joao Pereira (ficticio)', '1984-11-15', '2026-01-09', '10000000002',
     'cliente02.teste@example.com', 'RG-FIC-002', '11920000002', '11930000002',
     'Rua Ficticia 2, 20', '2026-09-13', 2),
    (3, 'Clara Souza (ficticioa)', '1987-04-22', '2026-01-13', '10000000003',
     'cliente03.teste@example.com', 'RG-FIC-003', '11920000003', '11930000003',
     'Rua Ficticia 3, 30', '2026-09-19', 3),
    (4, 'Lucas Almeida (ficticio)', '1990-09-02', '2026-01-17', '10000000004',
     'cliente04.teste@example.com', 'RG-FIC-004', '11920000004', '11930000004',
     'Rua Ficticia 4, 40', '2026-09-25', 4),
    (5, 'Patricia Melo (ficticioa)', '1993-02-09', '2026-01-21', '10000000005',
     'cliente05.teste@example.com', 'RG-FIC-005', '11920000005', '11930000005',
     'Rua Ficticia 5, 50', '2026-10-01', 5),
    (6, 'Rafael Nunes (ficticio)', '1996-07-16', '2026-01-25', '10000000006',
     'cliente06.teste@example.com', 'RG-FIC-006', '11920000006', '11930000006',
     'Rua Ficticia 6, 60', '2026-10-07', 6),
    (7, 'Beatriz Lopes (ficticioa)', '1999-12-23', '2026-01-29', '10000000007',
     'cliente07.teste@example.com', 'RG-FIC-007', '11920000007', '11930000007',
     'Rua Ficticia 7, 70', '2026-10-13', 1),
    (8, 'Gustavo Freitas (ficticio)', '1978-05-03', '2026-02-02', '10000000008',
     'cliente08.teste@example.com', 'RG-FIC-008', '11920000008', '11930000008',
     'Rua Ficticia 8, 80', '2026-10-19', 2),
    (9, 'Renata Barros (ficticioa)', '1981-10-10', '2026-02-06', '10000000009',
     'cliente09.teste@example.com', 'RG-FIC-009', '11920000009', '11930000009',
     'Rua Ficticia 9, 90', '2026-10-25', 3),
    (10, 'Marcelo Dias (ficticio)', '1984-03-17', '2026-02-10', '10000000010',
     'cliente10.teste@example.com', 'RG-FIC-010', '11920000010', '11930000010',
     'Rua Ficticia 10, 100', NULL, 4),
    (11, 'Sonia Prado (ficticioa)', '1987-08-24', '2026-02-14', '10000000011',
     'cliente11.teste@example.com', 'RG-FIC-011', '11920000011', '11930000011',
     'Rua Ficticia 11, 110', '2026-11-06', 5),
    (12, 'Eduardo Campos (ficticio)', '1990-01-04', '2026-02-18', '10000000012',
     'cliente12.teste@example.com', 'RG-FIC-012', '11920000012', '11930000012',
     'Rua Ficticia 12, 120', '2026-11-12', 6),
    (13, 'Aline Silva (ficticioa)', '1993-06-11', '2026-02-22', '10000000013',
     'cliente13.teste@example.com', 'RG-FIC-013', '11920000013', '11930000013',
     'Rua Ficticia 13, 130', '2026-11-18', 1),
    (14, 'Bruno Rocha (ficticio)', '1996-11-18', '2026-02-26', '10000000014',
     'cliente14.teste@example.com', 'RG-FIC-014', '11920000014', '11930000014',
     'Rua Ficticia 14, 140', '2026-11-24', 2),
    (15, 'Carla Martins (ficticioa)', '1999-04-25', '2026-03-02', '10000000015',
     'cliente15.teste@example.com', 'RG-FIC-015', '11920000015', '11930000015',
     'Rua Ficticia 15, 150', '2026-11-30', 3),
    (16, 'Daniel Ramos (ficticio)', '1978-09-05', '2026-03-06', '10000000016',
     'cliente16.teste@example.com', 'RG-FIC-016', '11920000016', '11930000016',
     'Rua Ficticia 16, 160', '2026-12-06', 4),
    (17, 'Elaine Oliveira (ficticioa)', '1981-02-12', '2026-03-10', '10000000017',
     'cliente17.teste@example.com', 'RG-FIC-017', '11920000017', '11930000017',
     'Rua Ficticia 17, 170', '2026-12-12', 5),
    (18, 'Fabio Santos (ficticio)', '1984-07-19', '2026-03-14', '10000000018',
     'cliente18.teste@example.com', 'RG-FIC-018', '11920000018', '11930000018',
     'Rua Ficticia 18, 180', '2026-12-18', 6),
    (19, 'Gabriela Araujo (ficticioa)', '1987-12-26', '2026-03-18', '10000000019',
     'cliente19.teste@example.com', 'RG-FIC-019', '11920000019', '11930000019',
     'Rua Ficticia 19, 190', '2026-12-24', 1),
    (20, 'Henrique Cardoso (ficticio)', '1990-05-06', '2026-03-22', '10000000020',
     'cliente20.teste@example.com', 'RG-FIC-020', '11920000020', '11930000020',
     'Rua Ficticia 20, 200', NULL, 2),
    (21, 'Isabela Costa (ficticioa)', '1993-10-13', '2026-03-26', '10000000021',
     'cliente21.teste@example.com', 'RG-FIC-021', '11920000021', '11930000021',
     'Rua Ficticia 21, 210', '2027-01-05', 3),
    (22, 'Julio Pereira (ficticio)', '1996-03-20', '2026-03-30', '10000000022',
     'cliente22.teste@example.com', 'RG-FIC-022', '11920000022', '11930000022',
     'Rua Ficticia 22, 220', '2027-01-11', 4),
    (23, 'Karen Souza (ficticioa)', '1999-08-27', '2026-04-03', '10000000023',
     'cliente23.teste@example.com', 'RG-FIC-023', '11920000023', '11930000023',
     'Rua Ficticia 23, 230', '2027-01-17', 5),
    (24, 'Leandro Almeida (ficticio)', '1978-01-07', '2026-04-07', '10000000024',
     'cliente24.teste@example.com', 'RG-FIC-024', '11920000024', '11930000024',
     'Rua Ficticia 24, 240', '2027-01-23', 6),
    (25, 'Monica Melo (ficticioa)', '1981-06-14', '2026-04-11', '10000000025',
     'cliente25.teste@example.com', 'RG-FIC-025', '11920000025', '11930000025',
     'Rua Ficticia 25, 250', '2026-09-01', 1),
    (26, 'Nicolas Nunes (ficticio)', '1984-11-21', '2026-04-15', '10000000026',
     'cliente26.teste@example.com', 'RG-FIC-026', '11920000026', '11930000026',
     'Rua Ficticia 26, 260', '2026-09-07', 2),
    (27, 'Olivia Lopes (ficticioa)', '1987-04-01', '2026-04-19', '10000000027',
     'cliente27.teste@example.com', 'RG-FIC-027', '11920000027', '11930000027',
     'Rua Ficticia 27, 270', '2026-09-13', 3),
    (28, 'Paulo Freitas (ficticio)', '1990-09-08', '2026-04-23', '10000000028',
     'cliente28.teste@example.com', 'RG-FIC-028', '11920000028', '11930000028',
     'Rua Ficticia 28, 280', '2026-09-19', 4),
    (29, 'Raquel Barros (ficticioa)', '1993-02-15', '2026-04-27', '10000000029',
     'cliente29.teste@example.com', 'RG-FIC-029', '11920000029', '11930000029',
     'Rua Ficticia 29, 290', '2026-09-25', 5),
    (30, 'Samuel Dias (ficticio)', '1996-07-22', '2026-05-01', '10000000030',
     'cliente30.teste@example.com', 'RG-FIC-030', '11920000030', '11930000030',
     'Rua Ficticia 30, 300', NULL, 6),
    (31, 'Tatiane Prado (ficticioa)', '1999-12-02', '2026-05-05', '10000000031',
     'cliente31.teste@example.com', 'RG-FIC-031', '11920000031', '11930000031',
     'Rua Ficticia 31, 310', '2026-10-07', 1),
    (32, 'Vinicius Campos (ficticio)', '1978-05-09', '2026-05-09', '10000000032',
     'cliente32.teste@example.com', 'RG-FIC-032', '11920000032', '11930000032',
     'Rua Ficticia 32, 320', '2026-10-13', 2),
    (33, 'Amanda Silva (ficticioa)', '1981-10-16', '2026-05-13', '10000000033',
     'cliente33.teste@example.com', 'RG-FIC-033', '11920000033', '11930000033',
     'Rua Ficticia 33, 330', '2026-10-19', 3),
    (34, 'Caio Rocha (ficticio)', '1984-03-23', '2026-05-17', '10000000034',
     'cliente34.teste@example.com', 'RG-FIC-034', '11920000034', '11930000034',
     'Rua Ficticia 34, 340', '2026-10-25', 4),
    (35, 'Debora Martins (ficticioa)', '1987-08-03', '2026-05-21', '10000000035',
     'cliente35.teste@example.com', 'RG-FIC-035', '11920000035', '11930000035',
     'Rua Ficticia 35, 350', '2026-10-31', 5),
    (36, 'Erick Ramos (ficticio)', '1990-01-10', '2026-05-25', '10000000036',
     'cliente36.teste@example.com', 'RG-FIC-036', '11920000036', '11930000036',
     'Rua Ficticia 36, 360', '2026-11-06', 6),
    (37, 'Fernanda Oliveira (ficticioa)', '1993-06-17', '2026-05-29', '10000000037',
     'cliente37.teste@example.com', 'RG-FIC-037', '11920000037', '11930000037',
     'Rua Ficticia 37, 370', '2026-11-12', 1),
    (38, 'Giovana Santos (ficticio)', '1996-11-24', '2026-06-02', '10000000038',
     'cliente38.teste@example.com', 'RG-FIC-038', '11920000038', '11930000038',
     'Rua Ficticia 38, 380', '2026-11-18', 2),
    (39, 'Heitor Araujo (ficticioa)', '1999-04-04', '2026-06-06', '10000000039',
     'cliente39.teste@example.com', 'RG-FIC-039', '11920000039', '11930000039',
     'Rua Ficticia 39, 390', '2026-11-24', 3),
    (40, 'Ingrid Cardoso (ficticio)', '1978-09-11', '2026-06-10', '10000000040',
     'cliente40.teste@example.com', 'RG-FIC-040', '11920000040', '11930000040',
     'Rua Ficticia 40, 400', NULL, 4),
    (41, 'Jorge Costa (ficticioa)', '1981-02-18', '2026-06-14', '10000000041',
     'cliente41.teste@example.com', 'RG-FIC-041', '11920000041', '11930000041',
     'Rua Ficticia 41, 410', '2026-12-06', 5),
    (42, 'Larissa Pereira (ficticio)', '1984-07-25', '2026-06-18', '10000000042',
     'cliente42.teste@example.com', 'RG-FIC-042', '11920000042', '11930000042',
     'Rua Ficticia 42, 420', '2026-12-12', 6),
    (43, 'Matheus Souza (ficticioa)', '1987-12-05', '2026-06-22', '10000000043',
     'cliente43.teste@example.com', 'RG-FIC-043', '11920000043', '11930000043',
     'Rua Ficticia 43, 430', '2026-12-18', 1),
    (44, 'Natalia Almeida (ficticio)', '1990-05-12', '2026-06-26', '10000000044',
     'cliente44.teste@example.com', 'RG-FIC-044', '11920000044', '11930000044',
     'Rua Ficticia 44, 440', '2026-12-24', 2),
    (45, 'Otavio Melo (ficticioa)', '1993-10-19', '2026-06-30', '10000000045',
     'cliente45.teste@example.com', 'RG-FIC-045', '11920000045', '11930000045',
     'Rua Ficticia 45, 450', '2026-12-30', 3),
    (46, 'Priscila Nunes (ficticio)', '1996-03-26', '2026-07-04', '10000000046',
     'cliente46.teste@example.com', 'RG-FIC-046', '11920000046', '11930000046',
     'Rua Ficticia 46, 460', '2027-01-05', 4),
    (47, 'Rodrigo Lopes (ficticioa)', '1999-08-06', '2026-07-08', '10000000047',
     'cliente47.teste@example.com', 'RG-FIC-047', '11920000047', '11930000047',
     'Rua Ficticia 47, 470', '2027-01-11', 5),
    (48, 'Simone Freitas (ficticio)', '1978-01-13', '2026-07-12', '10000000048',
     'cliente48.teste@example.com', 'RG-FIC-048', '11920000048', '11930000048',
     'Rua Ficticia 48, 480', '2027-01-17', 6),
    (49, 'Thiago Barros (ficticioa)', '1981-06-20', '2026-07-16', '10000000049',
     'cliente49.teste@example.com', 'RG-FIC-049', '11920000049', '11930000049',
     'Rua Ficticia 49, 490', '2027-01-23', 1),
    (50, 'Vanessa Dias (ficticio)', '1984-11-27', '2026-07-20', '10000000050',
     'cliente50.teste@example.com', 'RG-FIC-050', '11920000050', '11930000050',
     'Rua Ficticia 50, 500', NULL, 2),
    (51, 'Wesley Prado (ficticioa)', '1987-04-07', '2026-07-24', '10000000051',
     'cliente51.teste@example.com', 'RG-FIC-051', '11920000051', '11930000051',
     'Rua Ficticia 51, 510', '2026-09-07', 3),
    (52, 'Yasmin Campos (ficticio)', '1990-09-14', '2026-07-28', '10000000052',
     'cliente52.teste@example.com', 'RG-FIC-052', '11920000052', '11930000052',
     'Rua Ficticia 52, 520', '2026-09-13', 4),
    (53, 'Adriana Silva (ficticioa)', '1993-02-21', '2026-08-01', '10000000053',
     'cliente53.teste@example.com', 'RG-FIC-053', '11920000053', '11930000053',
     'Rua Ficticia 53, 530', '2026-09-19', 5),
    (54, 'Bernardo Rocha (ficticio)', '1996-07-01', '2026-08-05', '10000000054',
     'cliente54.teste@example.com', 'RG-FIC-054', '11920000054', '11930000054',
     'Rua Ficticia 54, 540', '2026-09-25', 6),
    (55, 'Cristina Martins (ficticioa)', '1999-12-08', '2026-08-09', '10000000055',
     'cliente55.teste@example.com', 'RG-FIC-055', '11920000055', '11930000055',
     'Rua Ficticia 55, 550', '2026-10-01', 1),
    (56, 'Douglas Ramos (ficticio)', '1978-05-15', '2026-08-13', '10000000056',
     'cliente56.teste@example.com', 'RG-FIC-056', '11920000056', '11930000056',
     'Rua Ficticia 56, 560', '2026-10-07', 2),
    (57, 'Estela Oliveira (ficticioa)', '1981-10-22', '2026-08-17', '10000000057',
     'cliente57.teste@example.com', 'RG-FIC-057', '11920000057', '11930000057',
     'Rua Ficticia 57, 570', '2026-10-13', 3),
    (58, 'Fernando Santos (ficticio)', '1984-03-02', '2026-08-21', '10000000058',
     'cliente58.teste@example.com', 'RG-FIC-058', '11920000058', '11930000058',
     'Rua Ficticia 58, 580', '2026-10-19', 4),
    (59, 'Helena Araujo (ficticioa)', '1987-08-09', '2026-08-25', '10000000059',
     'cliente59.teste@example.com', 'RG-FIC-059', '11920000059', '11930000059',
     'Rua Ficticia 59, 590', '2026-10-25', 5),
    (60, 'Igor Cardoso (ficticio)', '1990-01-16', '2026-08-29', '10000000060',
     'cliente60.teste@example.com', 'RG-FIC-060', '11920000060', '11930000060',
     'Rua Ficticia 60, 600', NULL, 6);

-- ----------------------------------------------------------------------------
-- PRODUTOS
-- Produtos alinhados aos exemplos informados na entrevista.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `PRODUTO` (`id_produto`, `nome_produto`, `preco_tabela`)
VALUES
    (1, 'Colageno Hidrolisado (exemplo ficticio)', 89.90),
    (2, 'Calcio e Magnesio (exemplo ficticio)', 69.90),
    (3, 'Levedo de Cerveja (exemplo ficticio)', 39.90),
    (4, 'Allium (exemplo ficticio)', 74.90),
    (5, 'Polen Apicola (exemplo ficticio)', 54.90);

-- ----------------------------------------------------------------------------
-- FORNECEDORES
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `FORNECEDOR`
    (`id_fornecedor`, `cnpj`, `razao_social`, `nome_fantasia`, `endereco`,
     `data_abertura`, `contato_responsavel`, `telefone`, `whatsapp`, `email`,
     `website`, `status_anvisa`, `data_anvisa`, `status_vigilancia_sanitaria`,
     `data_inicio_vigilancia`, `data_validade_vigilancia`, `prazo_entrega`)
VALUES
    (1, '00000000000001', 'Distribuidora Exemplo LTDA', 'Distribuidora Exemplo',
     'Rua Fornecedor, 10', '2018-01-15', 'Contato Ficticio A', '1130000001',
     '11980000001', 'fornecedor1@example.com', NULL, 'Em analise', NULL,
     'Em analise', NULL, NULL, 5),
    (2, '00000000000002', 'Saude Modelo LTDA', 'Saude Modelo',
     'Rua Fornecedor, 20', '2020-02-20', 'Contato Ficticio B', '1130000002',
     '11980000002', 'fornecedor2@example.com', NULL, 'Em analise', NULL,
     'Em analise', NULL, NULL, 7),
    (3, '00000000000003', 'Parceiro Nutricao LTDA', 'Parceiro Nutricao',
     'Rua Fornecedor, 30', '2019-05-14', 'Contato Ficticio C', '1130000003',
     '11980000003', 'fornecedor3@example.com', NULL, 'Em analise', NULL,
     'Em analise', NULL, NULL, 4);

INSERT IGNORE INTO `CATEGORIA`
    (`id_categoria`, `nome_categoria`, `percentual_desconto_base`)
VALUES
    (1, 'R30', 30.00),
    (2, 'R40', 40.00),
    (9999, 'Categoria CRUD demonstracao', 5.00);

-- ----------------------------------------------------------------------------
-- ACOMPANHAMENTO DE CLIENTES
-- Estruturas criadas no modelo academico para demonstracao.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `CONDICAO_SAUDE`
    (`id_condicao`, `data_inicio_sintomas`, `data_diagnostico`,
     `historico_doenca`, `nome_condicao`, `id_cliente`)
VALUES
    (1, '2026-09-10', '2026-09-20', 'Historico ficticio de teste', 'Rinite (exemplo)', 1),
    (2, '2026-08-01', '2026-08-14', 'Historico ficticio de teste', 'Hipertensao (exemplo)', 2),
    (3, '2026-07-05', NULL, 'Historico ficticio de teste', 'Alergia sazonal (exemplo)', 4),
    (4, '2026-06-12', '2026-06-20', 'Historico ficticio de teste', 'Condicao ficticia D', 7);

INSERT IGNORE INTO `CONDICAO_ALERGIA`
    (`id_condicao_alergia`, `alergia`, `id_condicao`)
VALUES
    (1, 'Poeira (exemplo)', 1),
    (2, 'Polen ambiental (exemplo)', 3);

INSERT IGNORE INTO `CONDICAO_MEDICAMENTO`
    (`id_condicao_medicamento`, `medicamento`, `id_condicao`)
VALUES
    (1, 'Medicamento ficticio A', 1),
    (2, 'Medicamento ficticio B', 2),
    (3, 'Medicamento ficticio C', 4);

INSERT IGNORE INTO `CONDICAO_SINTOMA`
    (`id_condicao_sintoma`, `sintoma`, `id_condicao`)
VALUES
    (1, 'Espirros (exemplo)', 1),
    (2, 'Congestao nasal (exemplo)', 1),
    (3, 'Irritacao (exemplo)', 3),
    (4, 'Sintoma ficticio D', 4);

INSERT IGNORE INTO `VISITA`
    (`id_visita`, `data_visita`, `observacoes`, `data_proxima_visita`, `id_cliente`)
VALUES
    (1, '2026-08-15', 'Atendimento ficticio para teste', '2026-10-15', 1),
    (2, '2026-09-20', 'Revisao ficticia para teste', '2026-11-20', 2),
    (3, '2026-09-28', 'Contato ficticio para teste', '2026-11-28', 4),
    (4, '2026-10-05', 'Acompanhamento ficticio', '2026-12-05', 5),
    (5, '2026-10-12', 'Acompanhamento ficticio', NULL, 7),
    (6, '2026-10-18', 'Contato ficticio para teste', '2026-12-18', 8),
    (7, '2026-10-25', 'Acompanhamento ficticio', '2026-12-20', 10),
    (8, '2026-11-01', 'Primeiro contato ficticio', NULL, 11);

-- ----------------------------------------------------------------------------
-- VENDAS
-- Os clientes 11 a 60 permanecem sem venda.
-- Existem vendas em meses diferentes e pagamento parcial para auditoria.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `VENDA` (`id_venda`, `data_venda`, `id_cliente`)
VALUES
    (1, '2026-07-05', 1),
    (2, '2026-07-18', 2),
    (3, '2026-08-03', 3),
    (4, '2026-08-21', 4),
    (5, '2026-09-02', 5),
    (6, '2026-09-19', 6),
    (7, '2026-10-04', 7),
    (8, '2026-10-22', 8),
    (9, '2026-11-01', 9),
    (10, '2026-11-06', 10);

INSERT IGNORE INTO `VENDA_PRODUTO`
    (`id_venda`, `id_produto`, `quantidade`, `preco_tabela`,
     `preco_vendido`, `desconto_aplicado`)
VALUES
    (1, 1, 1, 89.90, 89.90, 0.00),
    (1, 3, 1, 39.90, 37.90, 2.00),
    (2, 2, 1, 69.90, 69.90, 0.00),
    (2, 4, 1, 74.90, 72.90, 2.00),
    (3, 5, 2, 54.90, 52.90, 2.00),
    (4, 1, 1, 89.90, 85.90, 4.00),
    (4, 2, 1, 69.90, 69.90, 0.00),
    (5, 3, 2, 39.90, 38.90, 1.00),
    (6, 4, 1, 74.90, 74.90, 0.00),
    (6, 5, 1, 54.90, 52.90, 2.00),
    (7, 1, 2, 89.90, 84.90, 5.00),
    (8, 2, 1, 69.90, 67.90, 2.00),
    (8, 3, 1, 39.90, 39.90, 0.00),
    (9, 5, 1, 54.90, 54.90, 0.00),
    (10, 1, 1, 89.90, 87.90, 2.00),
    (10, 4, 1, 74.90, 72.90, 2.00);

INSERT IGNORE INTO `PAGAMENTO_VENDA`
    (`id_pagamento_venda`, `data_pagamento`, `valor`, `forma_pagamento`, `id_venda`)
VALUES
    (1, '2026-07-05', 127.80, 'Pix', 1),
    (2, '2026-07-18', 142.80, 'Cartao', 2),
    (3, '2026-08-03', 105.80, 'Dinheiro', 3),
    (4, '2026-08-21', 155.80, 'Pix', 4),
    (5, '2026-09-02', 77.80, 'Transferencia', 5),
    (6, '2026-09-19', 60.00, 'Pix', 6),
    (7, '2026-09-20', 67.80, 'Dinheiro', 6),
    (8, '2026-10-04', 100.00, 'Pix', 7), -- pagamento parcial proposital
    (9, '2026-10-22', 107.80, 'Cartao', 8),
    (10, '2026-11-01', 54.90, 'Pix', 9),
    (11, '2026-11-06', 160.80, 'Transferencia', 10);

-- ----------------------------------------------------------------------------
-- PEDIDOS
-- Inclui pedido cancelado e pedidos em diferentes situacoes.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `PEDIDO`
    (`id_pedido`, `numero_pedido`, `data_pedido`, `frete`,
     `status_pedido`, `id_representante`)
VALUES
    (1, 'PED-2026-001', '2026-06-10', 19.90, 'Recebido', 1),
    (2, 'PED-2026-002', '2026-06-28', 15.00, 'Recebido', 2),
    (3, 'PED-2026-003', '2026-07-16', 18.00, 'Recebido', 3),
    (4, 'PED-2026-004', '2026-08-05', 0.00, 'Retirada', 4),
    (5, 'PED-2026-005', '2026-08-30', 20.00, 'Cancelado', 5),
    (6, 'PED-2026-006', '2026-09-18', 16.50, 'Recebido', 6),
    (7, 'PED-2026-007', '2026-10-08', 22.00, 'Separacao', 1),
    (8, 'PED-2026-008', '2026-11-02', 14.00, 'Em transito', 2);

INSERT IGNORE INTO `PEDIDO_PRODUTO`
    (`id_pedido`, `id_produto`, `quantidade`, `valor_unitario`, `desconto_item`)
VALUES
    (1, 1, 10, 62.93, 0.00),
    (1, 3, 12, 27.93, 0.00),
    (2, 2, 8, 48.93, 0.00),
    (2, 4, 6, 52.43, 0.00),
    (3, 5, 10, 38.43, 0.00),
    (3, 1, 5, 62.93, 0.00),
    (4, 3, 15, 27.93, 0.00),
    (5, 4, 4, 52.43, 0.00),
    (6, 2, 10, 48.93, 0.00),
    (6, 5, 8, 38.43, 0.00),
    (7, 1, 15, 62.93, 0.00),
    (7, 3, 6, 27.93, 0.00),
    (8, 4, 8, 52.43, 0.00),
    (8, 2, 6, 48.93, 0.00);

INSERT IGNORE INTO `PAGAMENTO_PEDIDO`
    (`id_pagamento_pedido`, `data_pagamento`, `valor`,
     `forma_pagamento`, `id_pedido`)
VALUES
    (1, '2026-06-12', 984.36, 'Boleto', 1),
    (2, '2026-07-02', 721.02, 'Pix', 2),
    (3, '2026-07-18', 716.95, 'Transferencia', 3),
    (4, '2026-08-05', 418.95, 'Pix', 4),
    -- pedido 5 cancelado: sem pagamento
    (5, '2026-09-20', 400.00, 'Pix', 6),
    (6, '2026-09-22', 413.94, 'Boleto', 6),
    (7, '2026-10-10', 600.00, 'Pix', 7),
    (8, '2026-11-05', 727.02, 'Boleto', 8);

-- ----------------------------------------------------------------------------
-- LOTES
-- Dois lotes do produto 1 permitem demonstrar uso de mais de um lote.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `LOTE`
    (`id_lote`, `numero_lote`, `data_fabricacao`, `data_validade`, `id_produto`)
VALUES
    (1, 'COL-EX-01', '2026-01-10', '2027-01-10', 1),
    (2, 'LEV-EX-01', '2026-02-20', '2027-02-20', 3),
    (3, 'CAL-EX-01', '2026-03-01', '2027-03-01', 2),
    (4, 'ALL-EX-01', '2026-01-15', '2026-12-20', 4),
    (5, 'COL-EX-02', '2026-05-10', '2027-05-10', 1),
    (6, 'POL-EX-01', '2026-04-12', '2027-04-12', 5),
    (7, 'LEV-EX-02', '2026-08-01', '2027-08-01', 3);

INSERT IGNORE INTO `PEDIDO_LOTE`
    (`id_pedido`, `id_lote`, `quantidade_lote`)
VALUES
    (1, 1, 10),
    (1, 2, 12),
    (2, 3, 8),
    (2, 4, 6),
    (3, 6, 10),
    (3, 1, 5),
    (4, 2, 15),
    -- pedido 5 cancelado: sem baixa de lote
    (6, 3, 10),
    (6, 6, 8),
    (7, 1, 8),
    (7, 5, 7),
    (7, 7, 6),
    (8, 4, 8),
    (8, 3, 6);

-- ----------------------------------------------------------------------------
-- FORNECEDORES X PRODUTOS
-- O produto 5 fica propositalmente sem fornecedor para a consulta A02.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `FORNECEDOR_PRODUTO`
    (`id_fornecedor`, `id_produto`)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4),
    (3, 2),
    (3, 3),
    (3, 4);

INSERT IGNORE INTO `QUALIFICACAO_FORNECEDOR`
    (`id_qualificacao_fornecedor`, `data_qualificacao`, `status`,
     `observacao`, `id_fornecedor`)
VALUES
    (1, '2026-05-01', 'Aprovado', 'Exemplo ficticio para demonstracao', 1),
    (2, '2026-05-03', 'Aprovado', 'Exemplo ficticio para demonstracao', 2),
    (3, '2026-06-10', 'Em analise', 'Exemplo ficticio para demonstracao', 3),
    (4, '2026-10-15', 'Aprovado', 'Reavaliacao ficticia', 1);

INSERT IGNORE INTO `FORNECEDOR_FORMA_PAGAMENTO`
    (`id_forma_pagamento`, `forma_pagamento`, `id_fornecedor`)
VALUES
    (1, 'Pix', 1),
    (2, 'Boleto', 1),
    (3, 'Transferencia', 2),
    (4, 'Pix', 2),
    (5, 'Boleto', 3);

-- ----------------------------------------------------------------------------
-- INGRESSO, QUALIFICACAO E ATIVIDADE MENSAL
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `INGRESSO`
    (`id_ingresso`, `data_ingresso`, `valor_kit`, `quantidade_parcelas`,
     `status_pagamento`, `id_representante`)
VALUES
    (1, '2026-01-10', 500.00, 1, 'Quitado', 1),
    (2, '2026-02-05', 500.00, 2, 'Quitado', 2),
    (3, '2026-03-12', 500.00, 1, 'Quitado', 3),
    (4, '2026-04-18', 500.00, 2, 'Pendente', 4),
    (5, '2026-05-09', 500.00, 1, 'Quitado', 5),
    (6, '2026-06-21', 500.00, 2, 'Pendente', 6);

INSERT IGNORE INTO `QUALIFICACAO`
    (`id_qualificacao`, `data_qualificacao`, `tipo_qualificacao`, `valor_base`,
     `id_representante`, `id_categoria`, `id_treinador`)
VALUES
    (1, '2026-01-10', 'Ingresso / R30', 500.00, 1, 1, NULL),
    (2, '2026-02-05', 'Ingresso / R30', 500.00, 2, 1, NULL),
    (3, '2026-03-12', 'Ingresso / R30', 500.00, 3, 1, NULL),
    (4, '2026-04-18', 'Ingresso / R30', 500.00, 4, 1, NULL),
    (5, '2026-05-09', 'Ingresso / R30', 500.00, 5, 1, NULL),
    (6, '2026-06-21', 'Ingresso / R30', 500.00, 6, 1, NULL),
    (7, '2026-08-10', 'Evolucao / R40', 1000.00, 2, 2, 1),
    (8, '2026-09-15', 'Evolucao / R40', 1200.00, 3, 2, 1),
    (9, '2026-10-02', 'Evolucao / R40', 1100.00, 5, 2, 2);

INSERT IGNORE INTO `ATIVIDADE_MENSAL`
    (`id_atividade`, `mes_referencia`, `ano_referencia`,
     `status_atividade`, `id_representante`)
VALUES
    (1, 10, 2026, 'Ativo', 1),
    (2, 10, 2026, 'Ativo', 2),
    (3, 10, 2026, 'Ativo', 3),
    (4, 10, 2026, 'Inativo', 4),
    (5, 10, 2026, 'Ativo', 5),
    (6, 10, 2026, 'Ativo', 6),
    (7, 11, 2026, 'Ativo', 1),
    (8, 11, 2026, 'Ativo', 2),
    (9, 11, 2026, 'Ativo', 3),
    (10, 11, 2026, 'Ativo', 4),
    (11, 11, 2026, 'Ativo', 5),
    (12, 11, 2026, 'Inativo', 6);

-- ----------------------------------------------------------------------------
-- COMISSOES
-- Percentuais abaixo sao ficticios e existem somente para demonstrar o modelo.
-- A entrevista nao informou formulas ou percentuais exatos de comissao.
-- ----------------------------------------------------------------------------
INSERT IGNORE INTO `COMISSAO`
    (`id_comissao`, `tipo_comissao`, `valor_base`, `percentual`,
     `data_geracao`, `status`, `data_pagamento`, `id_representante`)
VALUES
    (1, 'Venda', 500.00, 6.00, '2026-07-08', 'Paga', '2026-07-15', 1),
    (2, 'Indicacao', 200.00, 5.00, '2026-07-20', 'Paga', '2026-07-28', 2),
    (3, 'Venda', 650.00, 6.00, '2026-08-05', 'Pendente', NULL, 3),
    (4, 'Equipe', 800.00, 4.00, '2026-09-10', 'Paga', '2026-09-18', 1),
    (5, 'Venda', 420.00, 6.00, '2026-09-25', 'Pendente', NULL, 4),
    (6, 'Indicacao', 300.00, 5.00, '2026-10-06', 'Paga', '2026-10-12', 5),
    (7, 'Equipe', 900.00, 4.00, '2026-10-20', 'Pendente', NULL, 2),
    (8, 'Venda', 550.00, 6.00, '2026-11-07', 'Pendente', NULL, 6);

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

-- G08 — Quais informacoes de acompanhamento existem para cada cliente?
-- Atende: P2 — centralizacao das informacoes de acompanhamento.
SELECT c.`nome` AS cliente,
       cs.`nome_condicao`,
       vi.`data_visita`,
       vi.`data_proxima_visita`
FROM `CLIENTE` AS c
LEFT JOIN `CONDICAO_SAUDE` AS cs
    ON cs.`id_cliente` = c.`id_cliente`
LEFT JOIN `VISITA` AS vi
    ON vi.`id_cliente` = c.`id_cliente`
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

-- FIM DO SCRIPT - TRATTOS - ENTREGA 2

