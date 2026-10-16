-- Consulta 1: Ocupação e Taxa de Preenchimento das Sessões
SELECT
e.Nome AS Evento,
a.Nome AS Atividade,
s.SessaoId,
s.DataHoraInicio,
esp.Nome AS Espaco,
s.Vagas AS VagasTotais,
COUNT(i.InscricaoId) AS Inscritos,
ROUND((COUNT(i.InscricaoId)::NUMERIC / s.Vagas) * 100, 2) AS PercentualOcupacao
FROM Sessao s
JOIN Atividade a ON s.AtividadeId = a.AtividadeId
JOIN Evento e ON a.EventoId = e.EventoId
JOIN Espaco esp ON s.EspacoId = esp.EspacoId
LEFT JOIN Inscricao i ON s.SessaoId = i.SessaoId
GROUP BY e.Nome, a.Nome, s.SessaoId, s.DataHoraInicio, esp.Nome, s.Vagas
ORDER BY PercentualOcupacao DESC;

-- Consulta 2: Participantes com Múltiplas Inscrições e Papéis Desempenhados
SELECT
p.Nome AS Participante,
p.CPF,
c.Organizacao,
COUNT(DISTINCT c.EventoId) AS TotalEventosInscritos,
COUNT(i.InscricaoId) AS TotalSessoesInscritas,
STRING_AGG(DISTINCT i.Papel, ', ') AS PapeisDesempenhados
FROM Participante p
JOIN Credenciamento c ON p.ParticipanteId = c.ParticipanteId
JOIN Inscricao i ON c.CredenciamentoId = i.CredenciamentoId
GROUP BY p.ParticipanteId, p.Nome, p.CPF, c.Organizacao
HAVING COUNT(i.InscricaoId) > 1
ORDER BY TotalSessoesInscritas DESC;


-- Consulta 3 (Antiga 4): Ranking e Arrecadação Financeira por Evento
WITH ReceitaPatrocinio AS (
SELECT
EventoId,
SUM(Valor) AS TotalPatrocinio
FROM Patrocinio
GROUP BY EventoId
),
ReceitaInscricoes AS (
SELECT
a.EventoId,
SUM(s.Valor) AS TotalInscricoes
FROM Inscricao i
JOIN Sessao s ON i.SessaoId = s.SessaoId
JOIN Atividade a ON s.AtividadeId = a.AtividadeId
GROUP BY a.EventoId
)
SELECT
e.EventoId,
e.Nome AS Evento,
COALESCE(p.TotalPatrocinio, 0.00) AS ReceitaPatrocinio,
COALESCE(i.TotalInscricoes, 0.00) AS ReceitaInscricoes,
(COALESCE(p.TotalPatrocinio, 0.00) + COALESCE(i.TotalInscricoes, 0.00)) AS
ReceitaTotal
FROM Evento e
LEFT JOIN ReceitaPatrocinio p ON e.EventoId = p.EventoId
LEFT JOIN ReceitaInscricoes i ON e.EventoId = i.EventoId
ORDER BY ReceitaTotal DESC;

-- Consulta 4: Relatório de Ocupação por Espaço Físico e Capacidade Máxima
SELECT
esp.EspacoId,
esp.Nome AS Espaco,
esp.LimitePessoas AS CapacidadeMaxima,
COUNT(DISTINCT s.SessaoId) AS TotalSessoesAgendadas,
COUNT(i.InscricaoId) AS TotalInscritosAcumulado,
ROUND(
AVG(
(SELECT COUNT(*) FROM Inscricao i2 WHERE i2.SessaoId = s.SessaoId)::NUMERIC

/ NULLIF(s.Vagas, 0) * 100
), 2
) AS MediaOcupacaoSessoesPct
FROM Espaco esp
LEFT JOIN Sessao s ON esp.EspacoId = s.EspacoId
LEFT JOIN Inscricao i ON s.SessaoId = i.SessaoId
GROUP BY esp.EspacoId, esp.Nome, esp.LimitePessoas
ORDER BY TotalSessoesAgendadas DESC, MediaOcupacaoSessoesPct DESC;

-- Consulta 5: Perfil Demográfico e Distribuição de Participantes por Organização
SELECT
COALESCE(c.Organizacao, 'Independente / Sem Vínculo') AS Organizacao,
COUNT(DISTINCT c.ParticipanteId) AS TotalParticipantes,
COUNT(DISTINCT c.EventoId) AS TotalEventosAlcancados,
COUNT(i.InscricaoId) AS TotalInscricoesSessoes,
COALESCE(SUM(s.Valor), 0.00) AS ValorTotalInvestido
FROM Credenciamento c
LEFT JOIN Inscricao i ON c.CredenciamentoId = i.CredenciamentoId
LEFT JOIN Sessao s ON i.SessaoId = s.SessaoId
GROUP BY COALESCE(c.Organizacao, 'Independente / Sem Vínculo')
HAVING COUNT(DISTINCT c.ParticipanteId) >= 1
ORDER BY TotalParticipantes DESC, ValorTotalInvestido DESC;


-- TRIGGERS --------
-- 1. Função de Validação PL/pgSQL
CREATE OR REPLACE FUNCTION fn_valida_conflito_espaco()
RETURNS TRIGGER AS $$
DECLARE
v_conflito INTEGER;
BEGIN
SELECT COUNT(*) INTO v_conflito
FROM Sessao
WHERE EspacoId = NEW.EspacoId
AND SessaoId <> COALESCE(NEW.SessaoId, -1)
AND NEW.DataHoraInicio < (DataHoraInicio + (Duracao || ' minutes')::INTERVAL)
AND (NEW.DataHoraInicio + (NEW.Duracao || ' minutes')::INTERVAL) > DataHoraInicio;
IF v_conflito > 0 THEN
RAISE EXCEPTION 'Erro de agendamento: O espaço % já possui outra sessão alocada
neste horário.', NEW.EspacoId;
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- 2. Associação da Trigger à Tabela Sessao
CREATE TRIGGER trg_valida_conflito_espaco
BEFORE INSERT OR UPDATE ON Sessao
FOR EACH ROW EXECUTE FUNCTION fn_valida_conflito_espaco();