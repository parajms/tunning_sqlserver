/********************************************************************************************
SITUAÇÃO:
    Para situações em que se faz necessário realizar análises de tempo de execução de rotinas 
    e subrotinas armazenadas no Integration Services, o código abaixo será útil.
OBJETIVO:
    Obter tempo de execução de rotinas a partir do log do SQL Server Integration Services.
HISTÓRICO
    01/01/2023 - Alexsandre Macaulay, Vitor Pilger, Jerson Mateus da Silveira
*********************************************************************************************/

-- Definindo o Data Warehouse
  USE [NOME_DATABASE];
  GO
  
-- Query principal
  SELECT I.[source]                                                   AS TAREFA,
         CONVERT(DATE,I.inicio,112)                                   AS DATA, 
         LEFT(CONVERT(TIME,I.inicio,112),8)                           AS HORA_INICIO,
         LEFT(CONVERT(TIME,F.fim,112),8)                              AS HORA_FIM,
	     NOME_DATABASE.dbo.FUNC_CALCULA_DURACAO(I.inicio,F.fim)       AS DURACAO -- Verifique o arquivo Duration_Calc.sql no diretório raiz
    FROM (
       -- O primeiro SUBSELECT é utilizado para obter dados de início das tarefas
            SELECT [source],
                   [sourceid],
                   [executionid],
                   [starttime]   as 'inicio'
              FROM [NOME_DATABASE].[dbo].[sysssislog]
             WHERE [event] = 'OnPreExecute'
		 ) I 
INNER JOIN (
       -- O segundo SUBSELECT é utilizado para obter dados de conclusão das tarefas
            SELECT [source],
                   [sourceid],
                   [executionid],
                   [starttime]   as 'fim'
              FROM [NOME_DATABASE].[dbo].[sysssislog]
             WHERE [event] = 'OnPostExecute'
		 ) F
        ON I.[sourceid]       = F.[sourceid]            
     WHERE I.[executionid]    = F.[executionid]
     -- Este filtro é opcional, pode ser utilizado para buscar especificamente uma ou mais tarefas
     --AND I.[source] IN ('')
	AND CONVERT(DATE,I.inicio,112) >= CONVERT(DATE,GETDATE(),112);
  GO
     
     -- O filtro de data ☝, foi definido para buscar somente regitros do dia atual
     -- caso o objetivo for buscar um período maior, basta substituir o parâmetro para o seguinte:
     -- CONVERT(DATE,GETDATE() -10,112) -> Para os últimos 10 dias
     -- CONVERT(DATE,GETDATE() -20,112) -> Para os últimos 20 dias
     -- CONVERT(DATE,GETDATE() -30,112) -> Para os últimos 30 dias...
