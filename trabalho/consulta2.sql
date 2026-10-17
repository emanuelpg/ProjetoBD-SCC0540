-- Consulta 2: Participantes com Múltiplas Inscrições e Papéis Desempenhados
SELECT 
    p.Nome AS Participante,
    p.CPF,
    c.Organizacao,
    COUNT(DISTINCT c.EventoId) AS TotalEventosInscritos,
    COUNT(i.InscricaoId) AS TotalSessoesInscritas,
    STRING_AGG(DISTINCT i.Papel::TEXT, ', ') AS PapeisDesempenhados
FROM participante p
JOIN credenciamento c ON p.ParticipanteId = c.ParticipanteId
JOIN inscricao i ON c.CredenciamentoId = i.CredenciamentoId
GROUP BY p.ParticipanteId, p.Nome, p.CPF, c.Organizacao
HAVING COUNT(i.InscricaoId) > 1
ORDER BY TotalSessoesInscritas DESC;