-- Consulta 3: Ranking e Arrecadação Financeira por Evento
WITH ReceitaPatrocinio AS (
    SELECT 
        EventoId,
        SUM(Valor) AS TotalPatrocinio
    FROM patrocinio
    GROUP BY EventoId
),
ReceitaInscricoes AS (
    SELECT 
        a.EventoId,
        SUM(s.Valor) AS TotalInscricoes
    FROM inscricao i
    JOIN sessao s ON i.SessaoId = s.SessaoId
    JOIN atividade a ON s.AtividadeId = a.AtividadeId
    GROUP BY a.EventoId
)
SELECT 
    e.EventoId,
    e.Nome AS Evento,
    COALESCE(p.TotalPatrocinio, 0.00) AS ReceitaPatrocinio,
    COALESCE(i.TotalInscricoes, 0.00) AS ReceitaInscricoes,
    (COALESCE(p.TotalPatrocinio, 0.00) + COALESCE(i.TotalInscricoes, 0.00)) AS ReceitaTotal
FROM evento e
LEFT JOIN ReceitaPatrocinio p ON e.EventoId = p.EventoId
LEFT JOIN ReceitaInscricoes i ON e.EventoId = i.EventoId
ORDER BY ReceitaTotal DESC;