-- Consulta 1: Ocupação e Taxa de Preenchimento das Sessões
SELECT 
    e.Nome AS Evento,
    a.Nome AS Atividade,
    s.SessaoId,
    s.DataHoraInicio,
    COALESCE(esp.Nome, 'Não definido') AS Espaco,
    s.Vagas AS VagasTotais,
    COUNT(i.InscricaoId) AS Inscritos,
    ROUND((COUNT(i.InscricaoId)::NUMERIC / NULLIF(s.Vagas, 0)) * 100, 2) AS PercentualOcupacao
FROM sessao s
JOIN atividade a ON s.AtividadeId = a.AtividadeId
JOIN evento e ON a.EventoId = e.EventoId
LEFT JOIN espaco esp ON s.EspacoId = esp.EspacoId
LEFT JOIN inscricao i ON s.SessaoId = i.SessaoId
GROUP BY e.Nome, a.Nome, s.SessaoId, s.DataHoraInicio, esp.Nome, s.Vagas
ORDER BY PercentualOcupacao DESC;