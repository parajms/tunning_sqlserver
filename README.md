<h1 align="center" >Tunning SQL Server</h1>

<p align="center">
<img src="https://img.shields.io/badge/License-MIT-green?style=flat" alt="License">
<img src="https://img.shields.io/badge/Language-TSQL-orange?style=flat&logo" alt="T-SQL">

## Sumário

* [Introdução](#introdução)
* [Etapas de Execução](#etapas-de-execução)
* [Contribuição](#contribuição)

## Introdução

Projeto que visa mapear e analisar os principais gargalos no tempo de execução de rotinas do SSIS.

## Etapas de execução

* Analisamos os logs dos pipelines de dados para identificar os pontos mais demorados
  * O tempo de duração das cargas era de 9 horas
* Otimizamos os ETLs desses pacotes identificados
* Identificamos consultas SQL que poderiam ser convertidas em views otimizadas
* Testamos o desempenho do sistema para verificar se houve uma melhoria significativa no tempo de duração das cargas
  * O tempo de duração das cargas foi reduzido para 5 horas
* Implementamos essas mudanças no ambiente de produção
* Monitoramos regularmente o desempenho do sistema para garantir que as cargas continuem a ser executadas de forma eficiente

## Contribuição

[![parajms](https://github.com/parajms.png?size=50)](https://github.com/parajms)
[![vitorhugopilger](https://github.com/vitorhugopilger.png?size=50)](https://github.com/vitorhugopilger)
[![macs47](https://github.com/macs47.png?size=50)](https://github.com/macs47)

