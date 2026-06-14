# Projeto SQL Server - Pao de Mel & Cia

Esta pasta contem a versao academica do banco de dados em SQL Server, separada do sistema online no Railway.

O site online continua usando PostgreSQL no Railway. Estes scripts sao para atender ao checklist que exige SQL Server.

## Ordem de execucao no SSMS

Abra o SQL Server Management Studio e execute os arquivos nesta ordem:

1. `01_modelo_fisico.sql`
2. `02_automacao.sql`
3. `03_dados_exemplo.sql`
4. `04_consultas_checklist.sql`

## O que o checklist pede e onde esta

| Item | Arquivo |
|---|---|
| Campo autonumerado `(1000,10)` | `01_modelo_fisico.sql` (`IDENTITY(1000,10)`) |
| Primary Key | `01_modelo_fisico.sql` |
| Foreign Key | `01_modelo_fisico.sql` |
| Foreign Key com `ON DELETE CASCADE` | `Usuario`, `Pedido`, `ItemPedido`, `ItemVenda` |
| `NOT NULL` | `01_modelo_fisico.sql` |
| `CHECK` | `01_modelo_fisico.sql` |
| `UNIQUE` | `Cliente.Email`, `Usuario.Email`, `Produto.Nome`, `Insumo.Nome` |
| `DEFAULT` | `CEP`, datas, status e totais |
| Pelo menos 3 registros por tabela | `03_dados_exemplo.sql` |
| Alias em tabelas (`AS`) | `04_consultas_checklist.sql` |
| Consulta com pelo menos 2 joins | `04_consultas_checklist.sql` |
| `SUM`, `COUNT`, `AVG`, `MAX`, `MIN` | `04_consultas_checklist.sql` |
| Dicionario de Dados | `DOCUMENTACAO.md` |
| Trigger | `02_automacao.sql` |
| Stored Procedure | `02_automacao.sql` |
| Function | `02_automacao.sql` |
| Index | `02_automacao.sql` |

## Banco criado

```sql
PaoDeMel
```

## Observacao

Os scripts usam apenas T-SQL/SQL Server.
