IF DB_ID('PaoDeMel') IS NULL
BEGIN
    CREATE DATABASE PaoDeMel;
END;
GO

USE PaoDeMel;
GO

IF OBJECT_ID('dbo.ItemVenda', 'U') IS NOT NULL DROP TABLE dbo.ItemVenda;
IF OBJECT_ID('dbo.Venda', 'U') IS NOT NULL DROP TABLE dbo.Venda;
IF OBJECT_ID('dbo.ItemPedido', 'U') IS NOT NULL DROP TABLE dbo.ItemPedido;
IF OBJECT_ID('dbo.Pedido', 'U') IS NOT NULL DROP TABLE dbo.Pedido;
IF OBJECT_ID('dbo.Fornada', 'U') IS NOT NULL DROP TABLE dbo.Fornada;
IF OBJECT_ID('dbo.Insumo', 'U') IS NOT NULL DROP TABLE dbo.Insumo;
IF OBJECT_ID('dbo.Produto', 'U') IS NOT NULL DROP TABLE dbo.Produto;
IF OBJECT_ID('dbo.Usuario', 'U') IS NOT NULL DROP TABLE dbo.Usuario;
IF OBJECT_ID('dbo.Cliente', 'U') IS NOT NULL DROP TABLE dbo.Cliente;
GO

CREATE TABLE dbo.Cliente (
    CPFCliente CHAR(11) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Nascimento DATE NOT NULL,
    Sexo CHAR(1) NOT NULL,
    Logradouro VARCHAR(50) NOT NULL,
    Numero VARCHAR(10) NOT NULL,
    Complemento VARCHAR(30) NULL,
    CEP CHAR(8) NOT NULL CONSTRAINT DF_Cliente_CEP DEFAULT ('00000000'),
    Bairro VARCHAR(30) NOT NULL,
    Cidade VARCHAR(30) NOT NULL,
    Estado CHAR(2) NOT NULL,
    Telefone VARCHAR(15) NOT NULL,
    Email VARCHAR(50) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (CPFCliente),
    CONSTRAINT UQ_Cliente_Email UNIQUE (Email),
    CONSTRAINT CK_Cliente_CPF CHECK (CPFCliente NOT LIKE '%[^0-9]%' AND LEN(CPFCliente) = 11),
    CONSTRAINT CK_Cliente_CEP CHECK (CEP NOT LIKE '%[^0-9]%' AND LEN(CEP) = 8),
    CONSTRAINT CK_Cliente_Sexo CHECK (Sexo IN ('M', 'F')),
    CONSTRAINT CK_Cliente_Estado CHECK (LEN(Estado) = 2)
);
GO

CREATE TABLE dbo.Usuario (
    IDUsuario INT IDENTITY(1000,10) NOT NULL,
    CPFCliente CHAR(11) NULL,
    Nome VARCHAR(50) NOT NULL,
    Telefone VARCHAR(15) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Senha VARCHAR(100) NOT NULL,
    Perfil VARCHAR(20) NOT NULL,
    CodigoInterno VARCHAR(20) NULL,
    DataCadastro DATETIME2 NOT NULL CONSTRAINT DF_Usuario_DataCadastro DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_Usuario PRIMARY KEY (IDUsuario),
    CONSTRAINT UQ_Usuario_Email UNIQUE (Email),
    CONSTRAINT CK_Usuario_Perfil CHECK (Perfil IN ('GERENTE', 'ATENDENTE', 'CONFEITEIRO', 'CLIENTE')),
    CONSTRAINT FK_Usuario_Cliente FOREIGN KEY (CPFCliente)
        REFERENCES dbo.Cliente(CPFCliente)
        ON DELETE CASCADE
);
GO

CREATE TABLE dbo.Produto (
    IDProduto INT IDENTITY(1000,10) NOT NULL,
    Nome VARCHAR(60) NOT NULL,
    Tipo VARCHAR(30) NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    Ativo BIT NOT NULL CONSTRAINT DF_Produto_Ativo DEFAULT (1),
    CONSTRAINT PK_Produto PRIMARY KEY (IDProduto),
    CONSTRAINT UQ_Produto_Nome UNIQUE (Nome),
    CONSTRAINT CK_Produto_Preco CHECK (PrecoUnitario > 0)
);
GO

CREATE TABLE dbo.Pedido (
    IDPedido INT IDENTITY(1000,10) NOT NULL,
    CPFCliente CHAR(11) NOT NULL,
    DataPedido DATETIME2 NOT NULL CONSTRAINT DF_Pedido_DataPedido DEFAULT (SYSDATETIME()),
    DataEntrega DATETIME2 NOT NULL,
    StatusPedido VARCHAR(30) NOT NULL CONSTRAINT DF_Pedido_Status DEFAULT ('Aguardando Producao'),
    ValorTotal DECIMAL(10,2) NOT NULL CONSTRAINT DF_Pedido_ValorTotal DEFAULT (0),
    CONSTRAINT PK_Pedido PRIMARY KEY (IDPedido),
    CONSTRAINT CK_Pedido_Status CHECK (StatusPedido IN ('Aguardando Producao', 'Em Producao', 'Pronto', 'Entregue', 'Cancelado')),
    CONSTRAINT CK_Pedido_ValorTotal CHECK (ValorTotal >= 0),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (CPFCliente)
        REFERENCES dbo.Cliente(CPFCliente)
        ON DELETE CASCADE
);
GO

CREATE TABLE dbo.ItemPedido (
    IDItemPedido INT IDENTITY(1000,10) NOT NULL,
    IDPedido INT NOT NULL,
    IDProduto INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    Subtotal AS (Quantidade * PrecoUnitario) PERSISTED,
    CONSTRAINT PK_ItemPedido PRIMARY KEY (IDItemPedido),
    CONSTRAINT CK_ItemPedido_Quantidade CHECK (Quantidade > 0),
    CONSTRAINT CK_ItemPedido_Preco CHECK (PrecoUnitario > 0),
    CONSTRAINT FK_ItemPedido_Pedido FOREIGN KEY (IDPedido)
        REFERENCES dbo.Pedido(IDPedido)
        ON DELETE CASCADE,
    CONSTRAINT FK_ItemPedido_Produto FOREIGN KEY (IDProduto)
        REFERENCES dbo.Produto(IDProduto)
);
GO

CREATE TABLE dbo.Insumo (
    IDInsumo INT IDENTITY(1000,10) NOT NULL,
    Nome VARCHAR(60) NOT NULL,
    QuantidadeAtual DECIMAL(10,2) NOT NULL,
    Unidade VARCHAR(10) NOT NULL,
    EstoqueMinimo DECIMAL(10,2) NOT NULL CONSTRAINT DF_Insumo_EstoqueMinimo DEFAULT (0),
    CONSTRAINT PK_Insumo PRIMARY KEY (IDInsumo),
    CONSTRAINT UQ_Insumo_Nome UNIQUE (Nome),
    CONSTRAINT CK_Insumo_Quantidade CHECK (QuantidadeAtual >= 0),
    CONSTRAINT CK_Insumo_EstoqueMinimo CHECK (EstoqueMinimo >= 0)
);
GO

CREATE TABLE dbo.Fornada (
    IDFornada INT IDENTITY(1000,10) NOT NULL,
    TipoPao VARCHAR(50) NOT NULL,
    QuantidadeProduzida INT NOT NULL,
    HoraSaida TIME NOT NULL,
    DataFornada DATE NOT NULL CONSTRAINT DF_Fornada_Data DEFAULT (CONVERT(DATE, GETDATE())),
    CONSTRAINT PK_Fornada PRIMARY KEY (IDFornada),
    CONSTRAINT CK_Fornada_Quantidade CHECK (QuantidadeProduzida > 0)
);
GO

CREATE TABLE dbo.Venda (
    IDVenda INT IDENTITY(1000,10) NOT NULL,
    CPFCliente CHAR(11) NULL,
    DataVenda DATETIME2 NOT NULL CONSTRAINT DF_Venda_Data DEFAULT (SYSDATETIME()),
    Total DECIMAL(10,2) NOT NULL CONSTRAINT DF_Venda_Total DEFAULT (0),
    CONSTRAINT PK_Venda PRIMARY KEY (IDVenda),
    CONSTRAINT CK_Venda_Total CHECK (Total >= 0),
    CONSTRAINT FK_Venda_Cliente FOREIGN KEY (CPFCliente)
        REFERENCES dbo.Cliente(CPFCliente)
        ON DELETE SET NULL
);
GO

CREATE TABLE dbo.ItemVenda (
    IDItemVenda INT IDENTITY(1000,10) NOT NULL,
    IDVenda INT NOT NULL,
    IDProduto INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10,2) NOT NULL,
    Subtotal AS (Quantidade * PrecoUnitario) PERSISTED,
    CONSTRAINT PK_ItemVenda PRIMARY KEY (IDItemVenda),
    CONSTRAINT CK_ItemVenda_Quantidade CHECK (Quantidade > 0),
    CONSTRAINT CK_ItemVenda_Preco CHECK (PrecoUnitario > 0),
    CONSTRAINT FK_ItemVenda_Venda FOREIGN KEY (IDVenda)
        REFERENCES dbo.Venda(IDVenda)
        ON DELETE CASCADE,
    CONSTRAINT FK_ItemVenda_Produto FOREIGN KEY (IDProduto)
        REFERENCES dbo.Produto(IDProduto)
);
GO
