# Documentacao do Projeto - Pao de Mel & Cia

## Objetivo do Projeto

O projeto Pao de Mel & Cia tem como objetivo oferecer um sistema para gestao de uma confeitaria/padaria, permitindo controlar clientes, usuarios do sistema, pedidos, produtos, vendas, estoque de insumos e fornadas.

O sistema auxilia a operacao diaria da empresa, reduzindo controles manuais e centralizando informacoes importantes para atendimento, producao e gerenciamento.

## Modelo de Negocio

A Pao de Mel & Cia realiza vendas de produtos de confeitaria e panificacao, como paes, bolos, croissants e paes de mel. A empresa tambem recebe encomendas de clientes, acompanha a producao e controla o estoque de insumos.

Principais atores:

- Cliente: realiza cadastro, pedidos e compras.
- Atendente: registra vendas e pedidos.
- Confeiteiro: acompanha producao e fornadas.
- Gerente: acompanha relatorios, estoque, usuarios e indicadores.

## Levantamento de Requisitos

### Requisitos Funcionais

- Cadastrar clientes pessoa fisica com CPF e endereco completo.
- Cadastrar usuarios para acesso ao sistema.
- Registrar produtos vendidos pela confeitaria.
- Registrar pedidos/encomendas de clientes.
- Registrar itens de pedidos.
- Registrar vendas de balcão.
- Registrar itens vendidos.
- Controlar insumos e estoque minimo.
- Registrar fornadas.
- Calcular automaticamente o total de pedidos e vendas.
- Consultar relatorios com totais e estatisticas.

### Requisitos Nao Funcionais

- O banco academico deve usar SQL Server.
- O banco deve usar chaves primarias e estrangeiras.
- O banco deve possuir restricoes de integridade.
- O banco deve permitir consultas gerenciais com agregacoes.
- O banco deve conter automacoes com trigger, procedure e function.

## Escolha do SGBDR

O SGBDR escolhido para a versao academica e o SQL Server, pois o checklist do projeto exige explicitamente o uso apenas de SQL Server.

## Modelo Conceitual

Entidades principais:

- Cliente
- Usuario
- Produto
- Pedido
- ItemPedido
- Insumo
- Fornada
- Venda
- ItemVenda

Relacionamentos:

- Um Cliente pode ter varios Pedidos.
- Um Pedido possui varios ItemPedido.
- Um Produto pode aparecer em varios ItemPedido.
- Um Cliente pode ter varias Vendas.
- Uma Venda possui varios ItemVenda.
- Um Produto pode aparecer em varios ItemVenda.
- Um Cliente pode estar vinculado a um Usuario de perfil CLIENTE.

## Modelo Logico

- Cliente (CPFCliente, Nome, Nascimento, Sexo, Logradouro, Numero, Complemento, CEP, Bairro, Cidade, Estado, Telefone, Email)
- Usuario (IDUsuario, CPFCliente, Nome, Telefone, Email, Senha, Perfil, CodigoInterno, DataCadastro)
- Produto (IDProduto, Nome, Tipo, PrecoUnitario, Ativo)
- Pedido (IDPedido, CPFCliente, DataPedido, DataEntrega, StatusPedido, ValorTotal)
- ItemPedido (IDItemPedido, IDPedido, IDProduto, Quantidade, PrecoUnitario, Subtotal)
- Insumo (IDInsumo, Nome, QuantidadeAtual, Unidade, EstoqueMinimo)
- Fornada (IDFornada, TipoPao, QuantidadeProduzida, HoraSaida, DataFornada)
- Venda (IDVenda, CPFCliente, DataVenda, Total)
- ItemVenda (IDItemVenda, IDVenda, IDProduto, Quantidade, PrecoUnitario, Subtotal)

## Modelo Fisico

O modelo fisico esta implementado no arquivo:

```text
01_modelo_fisico.sql
```

Ele contem:

- `IDENTITY(1000,10)`
- `PRIMARY KEY`
- `FOREIGN KEY`
- `ON DELETE CASCADE`
- `NOT NULL`
- `CHECK`
- `UNIQUE`
- `DEFAULT`

## Dicionario de Dados

### Cliente

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| CPFCliente | CHAR(11) | PK, CHECK | CPF do cliente |
| Nome | VARCHAR(50) | NOT NULL | Nome do cliente |
| Nascimento | DATE | NOT NULL | Data de nascimento |
| Sexo | CHAR(1) | NOT NULL, CHECK | Sexo M/F |
| Logradouro | VARCHAR(50) | NOT NULL | Rua, avenida ou travessa |
| Numero | VARCHAR(10) | NOT NULL | Numero do endereco |
| Complemento | VARCHAR(30) | NULL | Complemento do endereco |
| CEP | CHAR(8) | NOT NULL, DEFAULT, CHECK | CEP do cliente |
| Bairro | VARCHAR(30) | NOT NULL | Bairro |
| Cidade | VARCHAR(30) | NOT NULL | Cidade |
| Estado | CHAR(2) | NOT NULL, CHECK | UF |
| Telefone | VARCHAR(15) | NOT NULL | Telefone com DDD |
| Email | VARCHAR(50) | UNIQUE | E-mail pessoal |

### Usuario

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDUsuario | INT | PK, IDENTITY(1000,10) | Identificador do usuario |
| CPFCliente | CHAR(11) | FK | Cliente relacionado ao usuario |
| Nome | VARCHAR(50) | NOT NULL | Nome do usuario |
| Telefone | VARCHAR(15) | NOT NULL | Telefone |
| Email | VARCHAR(50) | NOT NULL, UNIQUE | Login/e-mail |
| Senha | VARCHAR(100) | NOT NULL | Senha |
| Perfil | VARCHAR(20) | NOT NULL, CHECK | Perfil de acesso |
| CodigoInterno | VARCHAR(20) | NULL | Codigo para equipe |
| DataCadastro | DATETIME2 | NOT NULL, DEFAULT | Data de cadastro |

### Produto

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDProduto | INT | PK, IDENTITY(1000,10) | Identificador do produto |
| Nome | VARCHAR(60) | NOT NULL, UNIQUE | Nome do produto |
| Tipo | VARCHAR(30) | NOT NULL | Tipo/categoria |
| PrecoUnitario | DECIMAL(10,2) | NOT NULL, CHECK | Preco unitario |
| Ativo | BIT | NOT NULL, DEFAULT | Produto ativo |

### Pedido

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDPedido | INT | PK, IDENTITY(1000,10) | Identificador do pedido |
| CPFCliente | CHAR(11) | FK, NOT NULL | Cliente do pedido |
| DataPedido | DATETIME2 | NOT NULL, DEFAULT | Data do pedido |
| DataEntrega | DATETIME2 | NOT NULL | Data de entrega |
| StatusPedido | VARCHAR(30) | NOT NULL, DEFAULT, CHECK | Status do pedido |
| ValorTotal | DECIMAL(10,2) | NOT NULL, DEFAULT, CHECK | Total do pedido |

### ItemPedido

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDItemPedido | INT | PK, IDENTITY(1000,10) | Identificador do item |
| IDPedido | INT | FK, NOT NULL | Pedido relacionado |
| IDProduto | INT | FK, NOT NULL | Produto relacionado |
| Quantidade | INT | NOT NULL, CHECK | Quantidade |
| PrecoUnitario | DECIMAL(10,2) | NOT NULL, CHECK | Preco unitario |
| Subtotal | Computed | PERSISTED | Quantidade vezes preco |

### Insumo

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDInsumo | INT | PK, IDENTITY(1000,10) | Identificador do insumo |
| Nome | VARCHAR(60) | NOT NULL, UNIQUE | Nome do insumo |
| QuantidadeAtual | DECIMAL(10,2) | NOT NULL, CHECK | Quantidade atual |
| Unidade | VARCHAR(10) | NOT NULL | Unidade de medida |
| EstoqueMinimo | DECIMAL(10,2) | NOT NULL, DEFAULT, CHECK | Estoque minimo |

### Fornada

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDFornada | INT | PK, IDENTITY(1000,10) | Identificador da fornada |
| TipoPao | VARCHAR(50) | NOT NULL | Tipo de pao produzido |
| QuantidadeProduzida | INT | NOT NULL, CHECK | Quantidade produzida |
| HoraSaida | TIME | NOT NULL | Hora de saida |
| DataFornada | DATE | NOT NULL, DEFAULT | Data da fornada |

### Venda

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDVenda | INT | PK, IDENTITY(1000,10) | Identificador da venda |
| CPFCliente | CHAR(11) | FK | Cliente relacionado |
| DataVenda | DATETIME2 | NOT NULL, DEFAULT | Data da venda |
| Total | DECIMAL(10,2) | NOT NULL, DEFAULT, CHECK | Total da venda |

### ItemVenda

| Campo | Tipo | Restricao | Descricao |
|---|---|---|---|
| IDItemVenda | INT | PK, IDENTITY(1000,10) | Identificador do item vendido |
| IDVenda | INT | FK, NOT NULL | Venda relacionada |
| IDProduto | INT | FK, NOT NULL | Produto relacionado |
| Quantidade | INT | NOT NULL, CHECK | Quantidade vendida |
| PrecoUnitario | DECIMAL(10,2) | NOT NULL, CHECK | Preco unitario |
| Subtotal | Computed | PERSISTED | Quantidade vezes preco |

## Automacao

### Trigger

- `trg_RecalcularTotalPedido`: recalcula o total do pedido quando itens sao inseridos, atualizados ou removidos.
- `trg_RecalcularTotalVenda`: recalcula o total da venda quando itens sao inseridos, atualizados ou removidos.

### Stored Procedure

- `sp_CadastrarPedido`: cria um pedido e um item inicial.

### Function

- `fn_CalcularIdadeCliente`: calcula a idade do cliente pelo CPF.

### Index

- `IX_Pedido_CPFCliente`
- `IX_Venda_DataVenda`
