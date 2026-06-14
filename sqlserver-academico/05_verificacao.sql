-- Verificacao rapida do banco academico PaoDeMel

SELECT
    @@SERVERNAME AS ServidorAtual,
    DB_NAME() AS BancoAtual;
GO

SELECT name AS BancoEncontrado
FROM sys.databases
WHERE name = 'PaoDeMel';
GO

USE PaoDeMel;
GO

SELECT
    DB_NAME() AS BancoAtualAposUse;
GO

SELECT
    T.name AS Tabela,
    SUM(P.rows) AS QuantidadeRegistros
FROM sys.tables AS T
INNER JOIN sys.partitions AS P
    ON P.object_id = T.object_id
WHERE P.index_id IN (0, 1)
GROUP BY T.name
ORDER BY T.name;
GO

SELECT
    (SELECT COUNT(*) FROM dbo.Cliente) AS QtdClientes,
    (SELECT COUNT(*) FROM dbo.Usuario) AS QtdUsuarios,
    (SELECT COUNT(*) FROM dbo.Produto) AS QtdProdutos,
    (SELECT COUNT(*) FROM dbo.Pedido) AS QtdPedidos,
    (SELECT COUNT(*) FROM dbo.ItemPedido) AS QtdItensPedido,
    (SELECT COUNT(*) FROM dbo.Insumo) AS QtdInsumos,
    (SELECT COUNT(*) FROM dbo.Fornada) AS QtdFornadas,
    (SELECT COUNT(*) FROM dbo.Venda) AS QtdVendas,
    (SELECT COUNT(*) FROM dbo.ItemVenda) AS QtdItensVenda;
GO

SELECT TOP 10 * FROM dbo.Cliente;
GO
