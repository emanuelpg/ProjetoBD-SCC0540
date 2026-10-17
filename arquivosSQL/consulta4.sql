SELECT
    esp.Nome                              AS espaco,
    ev.Nome                               AS evento,
    a.Nome                                AS atividade,
    s.Nome                                AS sessao,
    s.DataHoraInicio::date                AS data,
    to_char(s.DataHoraInicio, 'HH24:MI') || ' - ' ||
    to_char(s.DataHoraFim,    'HH24:MI')  AS horario,
    s.Vagas                               AS vagas,
    COUNT(i.InscricaoId) FILTER (WHERE i.Papel = 'ouvinte') AS inscritos
FROM sessao s
JOIN espaco esp       ON esp.EspacoId  = s.EspacoId
JOIN atividade a      ON a.AtividadeId = s.AtividadeId
JOIN evento ev        ON ev.EventoId   = a.EventoId
LEFT JOIN inscricao i ON i.SessaoId    = s.SessaoId
WHERE s.EspacoId = 1
  AND s.DataHoraInicio >= CURRENT_TIMESTAMP
GROUP BY esp.Nome, ev.Nome, a.Nome, s.SessaoId, s.Nome,
         s.DataHoraInicio, s.DataHoraFim, s.Vagas
ORDER BY s.DataHoraInicio;