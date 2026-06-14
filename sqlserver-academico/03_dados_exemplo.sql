USE PaoDeMel;
GO

INSERT INTO dbo.Cliente
    (CPFCliente, Nome, Nascimento, Sexo, Logradouro, Numero, Complemento, CEP, Bairro, Cidade, Estado, Telefone, Email)
VALUES
    ('12345678901', 'Ana Clara', '1995-04-12', 'F', 'Rua das Flores', '100', 'Apto 12', '01001000', 'Centro', 'Sao Paulo', 'SP', '11999990001', 'ana@email.com'),
    ('23456789012', 'Roberto Lima', '1988-09-23', 'M', 'Avenida Brasil', '250', NULL, '02002000', 'Jardins', 'Sao Paulo', 'SP', '11999990002', 'roberto@email.com'),
    ('34567890123', 'Marina Souza', '2001-01-30', 'F', 'Travessa Mel', '45', 'Casa', '03003000', 'Vila Doce', 'Campinas', 'SP', '11999990003', 'marina@email.com');
GO

INSERT INTO dbo.Usuario
    (CPFCliente, Nome, Telefone, Email, Senha, Perfil, CodigoInterno)
VALUES
    ('12345678901', 'Ana Clara', '11999990001', 'ana@email.com', '12345678', 'CLIENTE', NULL),
    (NULL, 'Gerente Pao de Mel', '11988880001', 'gerente@paodemel.com', '12345678', 'GERENTE', 'GER-001'),
    (NULL, 'Atendente Balcao', '11988880002', 'atendente@paodemel.com', '12345678', 'ATENDENTE', 'ATE-001');
GO

INSERT INTO dbo.Produto
    (Nome, Tipo, PrecoUnitario)
VALUES
    ('Pao de mel tradicional', 'Doce', 8.00),
    ('Bolo de chocolate 1kg', 'Bolo', 85.00),
    ('Croissant', 'Pao', 9.50);
GO

INSERT INTO dbo.Insumo
    (Nome, QuantidadeAtual, Unidade, EstoqueMinimo)
VALUES
    ('Farinha de trigo', 42.00, 'kg', 20.00),
    ('Chocolate 70%', 4.00, 'kg', 8.00),
    ('Creme de leite', 10.00, 'l', 12.00);
GO

INSERT INTO dbo.Fornada
    (TipoPao, QuantidadeProduzida, HoraSaida)
VALUES
    ('Pao frances', 120, '08:30'),
    ('Croissant', 36, '09:00'),
    ('Pao de queijo', 52, '10:15');
GO

INSERT INTO dbo.Pedido
    (CPFCliente, DataEntrega, StatusPedido)
VALUES
    ('12345678901', DATEADD(DAY, 2, SYSDATETIME()), 'Aguardando Producao'),
    ('23456789012', DATEADD(DAY, 3, SYSDATETIME()), 'Em Producao'),
    ('34567890123', DATEADD(DAY, 4, SYSDATETIME()), 'Pronto');
GO

INSERT INTO dbo.ItemPedido
    (IDPedido, IDProduto, Quantidade, PrecoUnitario)
VALUES
    (1000, 1010, 1, 85.00),
    (1010, 1000, 20, 8.00),
    (1020, 1020, 12, 9.50);
GO

INSERT INTO dbo.Venda
    (CPFCliente)
VALUES
    ('12345678901'),
    ('23456789012'),
    (NULL);
GO

INSERT INTO dbo.ItemVenda
    (IDVenda, IDProduto, Quantidade, PrecoUnitario)
VALUES
    (1000, 1000, 3, 8.00),
    (1010, 1020, 2, 9.50),
    (1020, 1010, 1, 85.00);
GO

EXEC dbo.sp_CadastrarPedido
    @CPFCliente = '12345678901',
    @DataEntrega = '2026-06-20 15:00:00',
    @IDProduto = 1000,
    @Quantidade = 5,
    @PrecoUnitario = 8.00;
GO
