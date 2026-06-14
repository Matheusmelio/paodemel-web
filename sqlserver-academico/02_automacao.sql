USE PaoDeMel;
GO

IF OBJECT_ID('dbo.trg_RecalcularTotalPedido', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_RecalcularTotalPedido;
GO

CREATE TRIGGER dbo.trg_RecalcularTotalPedido
ON dbo.ItemPedido
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
       SET ValorTotal = ISNULL(T.TotalPedido, 0)
      FROM dbo.Pedido AS P
      LEFT JOIN (
            SELECT IDPedido, SUM(Subtotal) AS TotalPedido
              FROM dbo.ItemPedido
             GROUP BY IDPedido
      ) AS T ON T.IDPedido = P.IDPedido
     WHERE P.IDPedido IN (
            SELECT IDPedido FROM inserted
            UNION
            SELECT IDPedido FROM deleted
     );
END;
GO

IF OBJECT_ID('dbo.trg_RecalcularTotalVenda', 'TR') IS NOT NULL
    DROP TRIGGER dbo.trg_RecalcularTotalVenda;
GO

CREATE TRIGGER dbo.trg_RecalcularTotalVenda
ON dbo.ItemVenda
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE V
       SET Total = ISNULL(T.TotalVenda, 0)
      FROM dbo.Venda AS V
      LEFT JOIN (
            SELECT IDVenda, SUM(Subtotal) AS TotalVenda
              FROM dbo.ItemVenda
             GROUP BY IDVenda
      ) AS T ON T.IDVenda = V.IDVenda
     WHERE V.IDVenda IN (
            SELECT IDVenda FROM inserted
            UNION
            SELECT IDVenda FROM deleted
     );
END;
GO

IF OBJECT_ID('dbo.fn_CalcularIdadeCliente', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_CalcularIdadeCliente;
GO

CREATE FUNCTION dbo.fn_CalcularIdadeCliente (@CPFCliente CHAR(11))
RETURNS INT
AS
BEGIN
    DECLARE @Nascimento DATE;
    DECLARE @Idade INT;

    SELECT @Nascimento = Nascimento
      FROM dbo.Cliente
     WHERE CPFCliente = @CPFCliente;

    IF @Nascimento IS NULL
        RETURN NULL;

    SET @Idade = DATEDIFF(YEAR, @Nascimento, GETDATE());

    IF DATEADD(YEAR, @Idade, @Nascimento) > GETDATE()
        SET @Idade = @Idade - 1;

    RETURN @Idade;
END;
GO

IF OBJECT_ID('dbo.sp_CadastrarPedido', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CadastrarPedido;
GO

CREATE PROCEDURE dbo.sp_CadastrarPedido
    @CPFCliente CHAR(11),
    @DataEntrega DATETIME2,
    @IDProduto INT,
    @Quantidade INT,
    @PrecoUnitario DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Pedido (CPFCliente, DataEntrega)
    VALUES (@CPFCliente, @DataEntrega);

    DECLARE @IDPedido INT = SCOPE_IDENTITY();

    INSERT INTO dbo.ItemPedido (IDPedido, IDProduto, Quantidade, PrecoUnitario)
    VALUES (@IDPedido, @IDProduto, @Quantidade, @PrecoUnitario);

    SELECT @IDPedido AS IDPedidoCriado;
END;
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Pedido_CPFCliente' AND object_id = OBJECT_ID('dbo.Pedido'))
    DROP INDEX IX_Pedido_CPFCliente ON dbo.Pedido;
GO

CREATE INDEX IX_Pedido_CPFCliente
ON dbo.Pedido (CPFCliente);
GO

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Venda_DataVenda' AND object_id = OBJECT_ID('dbo.Venda'))
    DROP INDEX IX_Venda_DataVenda ON dbo.Venda;
GO

CREATE INDEX IX_Venda_DataVenda
ON dbo.Venda (DataVenda);
GO
