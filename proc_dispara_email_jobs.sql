/********************************************************************************************
SITUAÇÃO:
    Para situações em que se faz necessário realizar envio por e-mail dos jobs executados usando msdb.dbo.sp_send_dbmail
OBJETIVO:
    Obter tempo de execução de rotinas e acompanhamento das mesmas.
HISTÓRICO
    01/01/2023 - Alexsandre Macaulay, Vitor Pilger, Jerson Mateus da Silveira
*********************************************************************************************/


-- Definindo o Data Warehouse
  USE [NOME_DATABASE];
  GO
  
CREATE PROCEDURE [dbo].[PROC_DISPARA_EMAIL_JOBS]
@DESTINO AS VARCHAR(4000)
AS
BEGIN
DECLARE @HTML AS NVARCHAR(MAX)
DECLARE @DATA AS NVARCHAR(10)
DECLARE @TIME AS NVARCHAR(8)
DECLARE @QUERY AS NVARCHAR(MAX)

SET @DATA = FORMAT(GETDATE(), 'dd/MM/yyyy')
SET @TIME = FORMAT(GETDATE(), 'HH:mm:ss')
DECLARE @JOBS_LIST NVARCHAR(MAX)
DECLARE @JOBS_LIST_ERROR NVARCHAR(MAX)
DECLARE @JOBS_LIST_RUNNING NVARCHAR(MAX)
DECLARE @JOBS_LIST_LATE NVARCHAR(MAX)
DECLARE @JOBS_LIST_DONE NVARCHAR(MAX)


SET @JOBS_LIST_ERROR =
CAST(
(
SELECT	td = K.NOME, '',
		td = K.DATA_INICIO, '',
		td = K.HORA_INICIO, '',
		td = K.HORA_TERMINO, '',
		td = K.DURACAO, '',
		td = K.STATUS_FIM
FROM(SELECT  NOME, 
		DATA_INICIO, 
		HORA_INICIO, 
		HORA_TERMINO,
		NOME_DATABASE.dbo.FUNC_CALCULA_DURACAO(V.HORA_INICIO,V.HORA_TERMINO) AS DURACAO,
		CASE
			WHEN CONVERT(DATE, DATA_INICIO, 103) <> CONVERT(DATE, GETDATE(), 103) THEN 'Erro'
			WHEN STATUS = 0 THEN 'Erro'
			WHEN STATUS = 1 AND (DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA) > 120) AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.1) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.2) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 THEN 'Executando'
			WHEN STATUS = 2 THEN 'Concluído'
			ELSE STATUS
		END STATUS_FIM
	FROM 
		TABELA_JOBS C INNER JOIN VIEW_JOBS V ON (C.ID_JOB = V.ID_JOB)
	    AND v.NOME IS NOT NULL
	) K
	WHERE K.STATUS_FIM = 'Erro'
	ORDER BY 
		CONVERT(TIME,K.HORA_TERMINO) DESC,
		K.STATUS_FIM ASC,
		K.DATA_INICIO ASC
	FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) )

SET @JOBS_LIST_RUNNING =
CAST(
(
SELECT	td = K.NOME, '',
		td = K.DATA_INICIO, '',
		td = K.HORA_INICIO, '',
		td = K.HORA_TERMINO, '',
		td = K.DURACAO, '',
		td = K.STATUS_FIM
FROM(SELECT  NOME, 
		DATA_INICIO, 
		HORA_INICIO, 
		HORA_TERMINO,
		NOME_DATABASE.dbo.FUNC_CALCULA_DURACAO(V.HORA_INICIO,V.HORA_TERMINO) AS DURACAO,
		CASE
			WHEN CONVERT(DATE, DATA_INICIO, 103) <> CONVERT(DATE, GETDATE(), 103) THEN 'Erro'
			WHEN STATUS = 0 THEN 'Erro'
			WHEN STATUS = 1 AND (DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA) > 120) AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.1) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.2) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 THEN 'Executando'
			WHEN STATUS = 2 THEN 'Concluído'
			ELSE STATUS
		END STATUS_FIM
	FROM 
		TABELA_JOBS C INNER JOIN VIEW_JOBS V ON (C.ID_JOB = V.ID_JOB)
	    AND v.NOME IS NOT NULL
	) K
	WHERE K.STATUS_FIM = 'Executando'
	ORDER BY 
		CONVERT(TIME,K.HORA_TERMINO) DESC,
		K.STATUS_FIM ASC,
		K.DATA_INICIO ASC
	FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) )

SET @JOBS_LIST_LATE =
CAST(
(
SELECT	td = K.NOME, '',
		td = K.DATA_INICIO, '',
		td = K.HORA_INICIO, '',
		td = K.HORA_TERMINO, '',
		td = K.DURACAO, '',
		td = K.STATUS_FIM
FROM(SELECT  NOME, 
		DATA_INICIO, 
		HORA_INICIO, 
		HORA_TERMINO,
		NOME_DATABASE.dbo.FUNC_CALCULA_DURACAO(V.HORA_INICIO,V.HORA_TERMINO) AS DURACAO,
		CASE
			WHEN CONVERT(DATE, DATA_INICIO, 103) <> CONVERT(DATE, GETDATE(), 103) THEN 'Erro'
			WHEN STATUS = 0 THEN 'Erro'
			WHEN STATUS = 1 AND (DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA) > 120) AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.1) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.2) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 THEN 'Executando'
			WHEN STATUS = 2 THEN 'Concluído'
			ELSE STATUS
		END STATUS_FIM
	FROM 
		TABELA_JOBS C INNER JOIN VIEW_JOBS V ON (C.ID_JOB = V.ID_JOB)
	    AND v.NOME IS NOT NULL
	) K
	WHERE K.STATUS_FIM = 'Atrasado'
	ORDER BY 
		CONVERT(TIME,K.HORA_TERMINO) DESC,
		K.STATUS_FIM ASC,
		K.DATA_INICIO ASC
	FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) )

SET @JOBS_LIST_DONE =
CAST(
(
SELECT	td = K.NOME, '',
		td = K.DATA_INICIO, '',
		td = K.HORA_INICIO, '',
		td = K.HORA_TERMINO, '',
		td = K.DURACAO, '',
		td = K.STATUS_FIM
FROM(SELECT  NOME, 
		DATA_INICIO, 
		HORA_INICIO, 
		HORA_TERMINO,
		NOME_DATABASE.dbo.FUNC_CALCULA_DURACAO(V.HORA_INICIO,V.HORA_TERMINO) AS DURACAO,
		CASE
			WHEN CONVERT(DATE, DATA_INICIO, 103) <> CONVERT(DATE, GETDATE(), 103) THEN 'Erro'
			WHEN STATUS = 0 THEN 'Erro'
			WHEN STATUS = 1 AND (DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA) > 120) AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.1) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 AND CONVERT(TIME,DATEADD(MINUTE,((DATEDIFF (MINUTE, '00:00:00', DURACAO_MEDIA)) * 0.2) , HORA_TERMINO)) < CONVERT(TIME, GETDATE()) THEN 'Atrasado'
			WHEN STATUS = 1 THEN 'Executando'
			WHEN STATUS = 2 THEN 'Concluído'
			ELSE STATUS
		END STATUS_FIM
	FROM 
		TABELA_JOBS C INNER JOIN VIEW_JOBS V ON (C.ID_JOB = V.ID_JOB)
	    AND v.NOME IS NOT NULL
	) K
	WHERE K.STATUS_FIM = 'Concluído'
	ORDER BY 
		CONVERT(TIME,K.HORA_TERMINO) DESC,
		K.STATUS_FIM ASC,
		K.DATA_INICIO ASC
	FOR XML PATH('tr'), TYPE 
	) AS NVARCHAR(MAX) )

SET @JOBS_LIST_ERROR = REPLACE(@JOBS_LIST_ERROR,'<tr>','<tr class="error">')
SET @JOBS_LIST_LATE = REPLACE(@JOBS_LIST_LATE,'<tr>','<tr class="late">')
SET @JOBS_LIST_RUNNING = REPLACE(@JOBS_LIST_RUNNING,'<tr>','<tr class="running">')
SET @JOBS_LIST_DONE = REPLACE(@JOBS_LIST_DONE,'<tr>','<tr class="done">')

SET @JOBS_LIST = CONCAT(@JOBS_LIST_ERROR,@JOBS_LIST_RUNNING,@JOBS_LIST_LATE,@JOBS_LIST_DONE)

SET @HTML = N'
<!DOCTYPE html>
<html lang="en">
<head>
    <style>
        html{
            font-family: system-ui, -apple-system, BlinkMacSystemFont, ''Segoe UI'', Roboto, Oxygen, Ubuntu, Cantarell, ''Open Sans'', ''Helvetica Neue'', sans-serif;
        }
        .center{
            text-align: center;
		}
        .box{
            border: 1px solid #b9b9b9;
            border-radius: 10px;
			font-size: 10px;
            margin-top: 20px;
			margin: auto;
			padding: 10px;
            width: 60%;
        }
        .data-table{
            border-collapse: collapse;
			border-bottom: 2px solid #008000;
			font-size: 13px;
            margin: auto;
            min-width: 60%;
				max-width: 90%;
				text-align: left;
        }
        th{
            background-color: #008000;
            color: #ffffff;
            min-width: 30%;
            padding: 5px 10px 5px 10px;
        }
        td{
			border: 1px solid #b9b9b9;
			border-left: hidden;
            border-right: hidden;
            margin: auto;
            padding: 5px 10px 5px 10px;
			white-space: nowrap;
        }
        .job{
            border-left: hidden;
            border-radius: 10px 0px 0px 0px;
        }
        .status{
            border-right: hidden;
            border-radius: 0px 10px 0px 0px;
        }
        .error{
            background-color: #c90e08;
            font-style: italic;
        }
        .running{
            background-color: #e6b209;
            font-style: italic;
        }		
        .late{
            background-color: #e66b07;
            font-style: italic;
        }
		.legend-table{            
			border-collapse: collapse;
			border-bottom: 2px solid #008000;
			font-size: 13px;
            margin: auto;
            min-width: 15%;
			max-width: 35%;
			text-align: center;
		}
		.legend_header{
			border-radius: 10px 10px 0px 0px;
		}
    </style>
</head>
<body>
	<h3 class="center">Relatório dos Jobs - '+@DATA+' - '+@TIME+'</h3>
    <br>
	<table class="data-table">
	<thead>
		<tr>
			<th class="table-header job center">Job</th>
            <th class="table-header day">Dia</th>
            <th class="table-header start">Início</th>
            <th class="table-header end">Fim</th>
            <th class="table-header duration">Duração</th>
            <th class="table-header status">Status</th>
        </tr>
	</thead>
	<tbody>'+ @JOBS_LIST + '
	</tbody>
		</table>
		<br>
		<table class="legend-table center">
			<thead>
				<th class="legend_header">Legenda</th>
			</thead>
			<tbody>
				<tr>
					<td class="error center">Erro</td>
				</tr>
				<tr>
					<td class="late center">Atrasado</td>
				</tr>
				<tr>
					<td class="running center">Executando</td>
				</tr>
				<tr>
					<td class="done center">Concluído</td>
				</tr>
			</tbody>
		</table>
		<br>
	    <div class="center footer box">
            <p class="details">Este é um e-mail automático, não responda. Quaisquer dúvidas, entre em contato com GrupoTISistemasBI@paqueta.com.br.</p>
        </div>
	</body>
</html>'

    EXEC msdb.dbo.sp_send_dbmail
    @profile_name ='USERNAME',
    @recipients= @DESTINO,
    @subject = 'Relatório de Jobs',
    @body = @HTML,  
    @body_format = 'HTML';	

END




GO


