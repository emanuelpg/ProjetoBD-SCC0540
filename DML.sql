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



-- ============================================================
-- TRIGGERS
-- Executar DEPOIS do script de criacao das tabelas.
-- Pode ser executado mais de uma vez (idempotente).
--
-- Ordem de disparo (alfabetica pelo nome do trigger):
--   sessao:          trg_sessao_requisitos -> trg_valida_conflito_espaco
--   inscricao:       trg_inscricao_conflito_horario -> trg_inscricao_limite_vagas
--   recursos_sessao: trg_recursos_sessao_requisitos
-- Em inscricao, todos travam primeiro o participante e depois a sessao
-- (ordem consistente, evita deadlock).
-- ============================================================


-- ------------------------------------------------------------
-- Trigger 0: Conflito de espaco (sessao x sessao)
-- Duas sessoes nao podem ocupar o mesmo espaco no mesmo intervalo.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_valida_conflito_espaco()
RETURNS TRIGGER AS $$
DECLARE
    v_conflito INTEGER;
BEGIN
    -- Sessao sem espaco definido nao conflita com nada
    IF NEW.EspacoId IS NULL THEN
        RETURN NEW;
    END IF;

    -- Serializa agendamentos concorrentes no mesmo espaco.
    -- Advisory lock (e nao FOR UPDATE em espaco) para nao entrar em conflito
    -- com o FOR SHARE de trg_sessao_requisitos, que roda antes.
    PERFORM pg_advisory_xact_lock(NEW.EspacoId);

    SELECT COUNT(*)
      INTO v_conflito
      FROM sessao
     WHERE EspacoId = NEW.EspacoId
       AND SessaoId <> COALESCE(NEW.SessaoId, -1)
       AND NEW.DataHoraInicio < DataHoraFim
       AND (NEW.DataHoraInicio + make_interval(mins => NEW.Duracao)) > DataHoraInicio;

    IF v_conflito > 0 THEN
        RAISE EXCEPTION 'Erro de agendamento: o espaco % ja possui outra sessao alocada neste horario.',
            NEW.EspacoId
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_valida_conflito_espaco ON sessao;

CREATE TRIGGER trg_valida_conflito_espaco
BEFORE INSERT OR UPDATE OF EspacoId, DataHoraInicio, Duracao ON sessao
FOR EACH ROW
EXECUTE FUNCTION fn_valida_conflito_espaco();


-- ------------------------------------------------------------
-- Trigger 1: Conflito de horario na inscricao
-- A mesma pessoa nao pode ter inscricoes em sessoes sobrepostas
-- (em qualquer evento, em qualquer papel).
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verifica_conflito_inscricao()
RETURNS TRIGGER AS $$
DECLARE
    v_participante INTEGER;
    v_inicio       TIMESTAMP;
    v_fim          TIMESTAMP;
    v_conf_nome    VARCHAR(150);
    v_conf_inicio  TIMESTAMP;
    v_conf_fim     TIMESTAMP;
BEGIN
    -- Descobre quem e a pessoa por tras do credenciamento
    SELECT ParticipanteId
      INTO v_participante
      FROM credenciamento
     WHERE CredenciamentoId = NEW.CredenciamentoId;

    -- Trava o participante para serializar inscricoes concorrentes da mesma pessoa
    PERFORM 1
       FROM participante
      WHERE ParticipanteId = v_participante
        FOR UPDATE;

    -- Intervalo da sessao que esta sendo inscrita
    SELECT DataHoraInicio, DataHoraFim
      INTO v_inicio, v_fim
      FROM sessao
     WHERE SessaoId = NEW.SessaoId;

    -- Procura qualquer outra inscricao da mesma pessoa cujo intervalo se sobreponha
    SELECT s.Nome, s.DataHoraInicio, s.DataHoraFim
      INTO v_conf_nome, v_conf_inicio, v_conf_fim
      FROM inscricao i
      JOIN credenciamento c ON c.CredenciamentoId = i.CredenciamentoId
      JOIN sessao s         ON s.SessaoId         = i.SessaoId
     WHERE c.ParticipanteId = v_participante
       AND (TG_OP = 'INSERT' OR i.InscricaoId <> NEW.InscricaoId)
       AND s.DataHoraInicio < v_fim
       AND v_inicio         < s.DataHoraFim
     LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION
            'Conflito de horario: o participante % ja esta inscrito na sessao "%" (% a %).',
            v_participante, v_conf_nome,
            to_char(v_conf_inicio, 'DD/MM/YYYY HH24:MI'),
            to_char(v_conf_fim,    'DD/MM/YYYY HH24:MI')
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_inscricao_conflito_horario ON inscricao;

CREATE TRIGGER trg_inscricao_conflito_horario
BEFORE INSERT OR UPDATE OF CredenciamentoId, SessaoId ON inscricao
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_conflito_inscricao();


-- ------------------------------------------------------------
-- Trigger 2: Limite de vagas (inscricao com sessao)
-- Somente ouvintes ocupam vaga.
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verifica_limite_vagas()
RETURNS TRIGGER AS $$
DECLARE
    v_vagas    INTEGER;
    v_ocupadas INTEGER;
BEGIN
    -- Somente ouvintes ocupam vaga: outros papeis passam direto
    IF NEW.Papel <> 'ouvinte' THEN
        RETURN NEW;
    END IF;

    -- Trava a linha da sessao para serializar inscricoes concorrentes
    -- (sem isso, duas transacoes simultaneas podem estourar o limite).
    SELECT Vagas
      INTO v_vagas
      FROM sessao
     WHERE SessaoId = NEW.SessaoId
       FOR UPDATE;

    -- Conta os ouvintes ja inscritos
    -- (no UPDATE, ignora a propria linha que esta sendo alterada).
    SELECT COUNT(*)
      INTO v_ocupadas
      FROM inscricao
     WHERE SessaoId = NEW.SessaoId
       AND Papel = 'ouvinte'
       AND (TG_OP = 'INSERT' OR InscricaoId <> NEW.InscricaoId);

    IF v_ocupadas >= v_vagas THEN
        RAISE EXCEPTION 'Sessao % esgotada: % de % vagas preenchidas.',
            NEW.SessaoId, v_ocupadas, v_vagas
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_inscricao_limite_vagas ON inscricao;

-- Papel incluido: instrutor/palestrante que vira ouvinte passa a ocupar vaga
CREATE TRIGGER trg_inscricao_limite_vagas
BEFORE INSERT OR UPDATE OF SessaoId, Papel ON inscricao
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_limite_vagas();


-- ------------------------------------------------------------
-- Trigger 3 (em SESSAO): capacidade do espaco + recursos ja exigidos
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verifica_requisitos_sessao()
RETURNS TRIGGER AS $$
DECLARE
    v_limite   INTEGER;
    v_recurso  VARCHAR(100);
    v_exigido  INTEGER;
    v_estoque  INTEGER;
BEGIN
    -- Sessao sem espaco definido nao tem requisitos a validar
    IF NEW.EspacoId IS NULL THEN
        RETURN NEW;
    END IF;

    -- FOR SHARE evita que o espaco seja alterado/removido durante a validacao
    SELECT LimitePessoas
      INTO v_limite
      FROM espaco
     WHERE EspacoId = NEW.EspacoId
       FOR SHARE;

    -- (a) Vagas da sessao nao podem exceder a capacidade do espaco
    IF NEW.Vagas > v_limite THEN
        RAISE EXCEPTION
            'Sessao "%": % vagas excedem o limite de % pessoas do espaco %.',
            NEW.Nome, NEW.Vagas, v_limite, NEW.EspacoId
            USING ERRCODE = 'check_violation';
    END IF;

    -- (b) Recursos que a sessao ja exige devem existir no estoque do espaco
    --     (no INSERT ainda nao ha recursos_sessao; vale para troca de espaco)
    SELECT r.Nome, rs.QtdNecessaria, COALESCE(e.Quantidade, 0)
      INTO v_recurso, v_exigido, v_estoque
      FROM recursos_sessao rs
      JOIN recursos r        ON r.RecursoId = rs.RecursoId
      LEFT JOIN estoque e    ON e.EspacoId  = NEW.EspacoId
                            AND e.RecursoId = rs.RecursoId
     WHERE rs.SessaoId = NEW.SessaoId
       AND COALESCE(e.Quantidade, 0) < rs.QtdNecessaria
     LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION
            'Espaco % nao atende a sessao "%": recurso "%" exige % unidade(s), mas ha %.',
            NEW.EspacoId, NEW.Nome, v_recurso, v_exigido, v_estoque
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sessao_requisitos ON sessao;

CREATE TRIGGER trg_sessao_requisitos
BEFORE INSERT OR UPDATE OF EspacoId, Vagas ON sessao
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_requisitos_sessao();


-- ------------------------------------------------------------
-- Trigger 4 (em RECURSOS_SESSAO): o espaco da sessao tem o recurso?
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_verifica_recurso_sessao()
RETURNS TRIGGER AS $$
DECLARE
    v_espaco     INTEGER;
    v_disponivel INTEGER;
BEGIN
    -- FOR SHARE impede que o espaco da sessao mude durante a validacao
    SELECT EspacoId
      INTO v_espaco
      FROM sessao
     WHERE SessaoId = NEW.SessaoId
       FOR SHARE;

    -- Sessao sem espaco: nada a validar (sera validado quando o espaco for definido)
    IF v_espaco IS NULL THEN
        RETURN NEW;
    END IF;

    SELECT Quantidade
      INTO v_disponivel
      FROM estoque
     WHERE EspacoId  = v_espaco
       AND RecursoId = NEW.RecursoId;

    IF v_disponivel IS NULL THEN
        RAISE EXCEPTION
            'O espaco % nao possui o recurso % no estoque.',
            v_espaco, NEW.RecursoId
            USING ERRCODE = 'check_violation';
    ELSIF v_disponivel < NEW.QtdNecessaria THEN
        RAISE EXCEPTION
            'Recurso % insuficiente no espaco %: necessario %, disponivel %.',
            NEW.RecursoId, v_espaco, NEW.QtdNecessaria, v_disponivel
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_recursos_sessao_requisitos ON recursos_sessao;

CREATE TRIGGER trg_recursos_sessao_requisitos
BEFORE INSERT OR UPDATE OF SessaoId, RecursoId, QtdNecessaria ON recursos_sessao
FOR EACH ROW
EXECUTE FUNCTION fn_verifica_recurso_sessao();