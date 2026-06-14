USE PaoDeMel;
GO

-- Alias em tabelas usando AS e consulta com pelo menos 2 JOINs.
SELECT
    C.Nome AS Cliente,
    P.IDPedido AS NumeroPedido,
    PR.Nome AS Produto,
    IP.Quantidade AS Quantidade,
    IP.Subtotal AS Subtotal
FROM dbo.Cliente AS C
INNER JOIN dbo.Pedido AS P
    ON P.CPFCliente = C.CPFCliente
INNER JOIN dbo.ItemPedido AS IP
    ON IP.IDPedido = P.IDPedido
INNER JOIN dbo.Produto AS PR
    ON PR.IDProduto = IP.IDProduto;
GO

-- SUM: total vendido por produto.
SELECT
    PR.Nome AS Produto,
    SUM(IV.Subtotal) AS TotalVendido
FROM dbo.Produto AS PR
INNER JOIN dbo.ItemVenda AS IV
    ON IV.IDProduto = PR.IDProduto
GROUP BY PR.Nome;
GO

-- COUNT: quantidade de pedidos por cliente.
SELECT
    C.Nome AS Cliente,
    COUNT(P.IDPedido) AS QuantidadePedidos
FROM dbo.Cliente AS C
LEFT JOIN dbo.Pedido AS P
    ON P.CPFCliente = C.CPFCliente
GROUP BY C.Nome;
GO

-- AVG, MAX e MIN: estatisticas dos produtos.
SELECT
    AVG(PrecoUnitario) AS PrecoMedio,
    MAX(PrecoUnitario) AS MaiorPreco,
    MIN(PrecoUnitario) AS MenorPreco
FROM dbo.Produto;
GO

-- Uso da FUNCTION criada.
SELECT
    C.Nome AS Cliente,
    dbo.fn_CalcularIdadeCliente(C.CPFCliente) AS Idade
FROM dbo.Cliente AS C;
GO

-- Consulta de estoque baixo.
SELECT
    I.Nome AS Insumo,
    I.QuantidadeAtual AS QuantidadeAtual,
    I.EstoqueMinimo AS EstoqueMinimo
FROM dbo.Insumo AS I
WHERE I.QuantidadeAtual <= I.EstoqueMinimo;
GO
