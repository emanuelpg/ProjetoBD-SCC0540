-- ============================================================
-- SCC0640 - Sistema de Gestao de Eventos e Espacos
-- 05_DML_casos_triggers.sql
--
-- Dados adicionais + casos que exercitam os 5 triggers.
-- DIFERENTE dos roteiros de teste, AQUI AS ALTERACOES FICAM GRAVADAS:
--   * caso ACEITO    -> a tupla e inserida/alterada e fica na tabela
--   * caso REJEITADO -> o trigger barra e a tabela fica como estava
-- O script nao para quando um caso e rejeitado: cada caso roda isolado.
--
-- Ordem: DDL -> Triggers -> DML.sql -> este arquivo
-- Pode ser executado de novo: a secao 0 apaga os dados deste arquivo.
--
-- Ao final, a aba "Data Output" mostra, para cada caso:
--   o que era esperado, o que o banco fez, a mensagem do trigger,
--   se a tabela confere e a consulta para voce conferir sozinho.
--
-- Convencao de ids (para facilitar a conferencia):
--   Evento 100 | Espacos 101, 102, 103 | Atividades 100-103
--   Sessoes 100-104 (base) e 110-115 (criadas pelos casos)
--   Participantes 100-115 | Credenciamento = 1000 + ParticipanteId
--     (ex.: participante 102 -> credenciamento 1102)
-- ============================================================


-- ============================================================
-- 0. LIMPEZA dos dados deste arquivo (permite reexecutar)
-- ============================================================
BEGIN;
DELETE FROM evento       WHERE EventoId = 100;              -- cascata: atividades, sessoes, inscricoes...
DELETE FROM participante WHERE ParticipanteId BETWEEN 100 AND 115;
DELETE FROM espaco       WHERE EspacoId IN (101, 102, 103); -- cascata: estoque
COMMIT;


-- ============================================================
-- 1. DADOS BASE (todos validos)
-- ============================================================
BEGIN;

INSERT INTO evento (EventoId, Nome, Inicio, Fim, Descricao) VALUES
  (100, 'Congresso Regional de Tecnologia 2027', '2027-03-15 08:00', '2027-03-19 20:00',
   'Congresso com oficinas, minicursos, palestras e mesas-redondas.');

INSERT INTO patrocinio (EventoId, PromotorId, Valor, Data_patrocinio) VALUES
  (100, 3, 9000.00, '2026-12-01'),
  (100, 5, 4500.00, '2026-12-15');

INSERT INTO espaco (EspacoId, Nome, LimitePessoas, CEP, Numero, Rua, Bairro, Cidade, Estado) VALUES
  (101, 'Sala 101',         20, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (102, 'Laboratorio 102',  15, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (103, 'Auditorio Norte',  80, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP');

-- Recursos: 1 Projetor | 2 Computadores | 3 Audio | 4 Wi-Fi | 5 Microfone | 6 Lousa | 7 Transmissao | 8 Estande
INSERT INTO estoque (EspacoId, RecursoId, Quantidade) VALUES
  (101, 1, 1), (101, 4, 1),                         -- Sala 101: projetor, wi-fi
  (102, 1, 1), (102, 2, 15), (102, 4, 1),           -- Lab 102: projetor, 15 computadores, wi-fi
  (103, 1, 1), (103, 3, 1), (103, 4, 1), (103, 5, 2); -- Auditorio Norte: projetor, audio, wi-fi, 2 microfones

INSERT INTO atividade (AtividadeId, EventoId, Nome, Descricao) VALUES
  (100, 100, 'Oficina de Arduino',              'Prototipagem com microcontroladores.'),
  (101, 100, 'Palestra: Cidades Inteligentes',  'Sensores e dados abertos na gestao urbana.'),
  (102, 100, 'Minicurso de Docker',             'Conteineres do zero ao deploy.'),
  (103, 100, 'Mesa-redonda: Carreira em Dados', 'Profissionais discutem a area de dados.');

INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES
  (100, 100, 102,  'Turma 1',      '2027-03-16 09:00', 180,  5, 40.00), -- Lab 102, 09h-12h, so 5 vagas
  (101, 100, 102,  'Turma 2',      '2027-03-16 14:00', 180, 15, 40.00), -- Lab 102, 14h-17h
  (102, 101, 103,  'Sessao unica', '2027-03-15 10:00',  90, 80,  0.00), -- Auditorio Norte
  (103, 102, 101,  'Sessao unica', '2027-03-17 09:00', 240, 20, 60.00), -- Sala 101
  (104, 103, NULL, 'Sessao unica', '2027-03-18 15:00', 120, 60,  0.00); -- ainda sem espaco

INSERT INTO recursos_sessao (SessaoId, RecursoId, QtdNecessaria) VALUES
  (100, 2, 5),                       -- Turma 1: 5 computadores
  (101, 2, 15),                      -- Turma 2: 15 computadores
  (102, 1, 1), (102, 3, 1), (102, 5, 1), -- Palestra: projetor, audio, 1 microfone
  (103, 1, 1);                       -- Docker: projetor

INSERT INTO participante (ParticipanteId, CPF, Nome, DataNascimento) VALUES
  (100, '90000000100', 'Alice Monteiro',     '1985-04-12'),
  (101, '90000000101', 'Bernardo Silveira',  '1999-08-03'),
  (102, '90000000102', 'Clara Antunes',      '2001-01-27'),
  (103, '90000000103', 'Diego Paiva',        '2000-11-15'),
  (104, '90000000104', 'Elisa Fontes',       '1998-06-09'),
  (105, '90000000105', 'Fabio Queiroz',      '1979-02-21'),
  (106, '90000000106', 'Giovana Prado',      '1990-09-30'),
  (107, '90000000107', 'Heitor Lacerda',     '2002-03-18'),
  (108, '90000000108', 'Ingrid Rezende',     '2003-07-07'),
  (109, '90000000109', 'Jonas Medeiros',     '1988-12-01'),
  (110, '90000000110', 'Kelly Arantes',      '2001-05-25'),
  (111, '90000000111', 'Lucas Bittencourt',  '1997-10-14'),
  (112, '90000000112', 'Melissa Torres',     '2000-02-02'),
  (113, '90000000113', 'Nelson Guimaraes',   '1975-08-19'),
  (114, '90000000114', 'Odete Carvalhal',    '1995-04-04'),
  (115, '90000000115', 'Pietro Sales',       '2002-12-12');

-- Credenciamento = 1000 + ParticipanteId
INSERT INTO credenciamento (CredenciamentoId, ParticipanteId, EventoId, Organizacao) VALUES
  (1100, 100, 100, FALSE), (1101, 101, 100, FALSE), (1102, 102, 100, FALSE), (1103, 103, 100, FALSE),
  (1104, 104, 100, FALSE), (1105, 105, 100, FALSE), (1106, 106, 100, FALSE), (1107, 107, 100, FALSE),
  (1108, 108, 100, FALSE), (1109, 109, 100, FALSE), (1110, 110, 100, FALSE), (1111, 111, 100, FALSE),
  (1112, 112, 100, FALSE), (1113, 113, 100, TRUE),  -- 113 e organizador do evento 100
  (1114, 114,   5, FALSE),                          -- 114 esta credenciada SO no evento 5
  (1115, 115, 100, FALSE);

INSERT INTO inscricao (CredenciamentoId, SessaoId, DataHora, Papel) VALUES
  (1100, 100, '2027-02-01 10:00', 'instrutor'),  -- Turma 1: instrutor
  (1101, 100, '2027-02-02 09:00', 'ouvinte'),    -- Turma 1: 4 ouvintes (de 5 vagas)
  (1102, 100, '2027-02-02 09:30', 'ouvinte'),
  (1103, 100, '2027-02-03 14:00', 'ouvinte'),
  (1104, 100, '2027-02-04 16:00', 'ouvinte'),
  (1111, 101, '2027-02-05 08:00', 'ouvinte'),    -- Turma 2: 2 ouvintes
  (1115, 101, '2027-02-05 08:30', 'ouvinte'),
  (1105, 102, '2027-02-01 11:00', 'palestrante'),-- Palestra
  (1106, 103, '2027-02-01 12:00', 'instrutor'),  -- Docker
  (1101, 103, '2027-02-06 10:00', 'ouvinte'),
  (1107, 103, '2027-02-06 10:30', 'ouvinte');

COMMIT;


-- ============================================================
-- 2. MECANISMO DOS CASOS
-- Cada CALL executa um comando. Se o trigger rejeitar, o erro e
-- capturado, registrado e o script continua. Se for aceito, a
-- alteracao fica GRAVADA no banco.
-- (procedimento e tabela temporarios: somem ao fechar a conexao)
-- ============================================================
DROP TABLE IF EXISTS log_casos;
CREATE TEMP TABLE log_casos (
    caso      TEXT PRIMARY KEY,
    descricao TEXT,
    esperado  TEXT,
    resultado TEXT,
    mensagem  TEXT
);

CREATE OR REPLACE PROCEDURE pg_temp.caso(p_caso TEXT, p_esperado TEXT, p_descricao TEXT, p_cmd TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    BEGIN
        EXECUTE p_cmd;
        INSERT INTO log_casos VALUES (p_caso, p_descricao, p_esperado, 'ACEITO', NULL);
        RAISE NOTICE '% ACEITO    | %', p_caso, p_descricao;
    EXCEPTION WHEN OTHERS THEN
        INSERT INTO log_casos VALUES (p_caso, p_descricao, p_esperado, 'REJEITADO', SQLERRM);
        RAISE NOTICE '% REJEITADO | % -> %', p_caso, p_descricao, SQLERRM;
    END;
END;
$$;


-- ============================================================
-- 3. TRIGGER 0 - Conflito de espaco (trg_valida_conflito_espaco)
--    Lab 102 no dia 16/03: sessao 100 (09h-12h) e sessao 101 (14h-17h)
-- ============================================================
CALL pg_temp.caso('C01', 'REJEITADO', 'Nova sessao 110 no Lab 102 das 10h as 11h (dentro da sessao 100)',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (110, 100, 102, 'Turma extra', '2027-03-16 10:00', 60, 10)$c$);

CALL pg_temp.caso('C02', 'ACEITO', 'Nova sessao 111 no Lab 102 das 12h as 14h (encostada nas sessoes 100 e 101)',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (111, 100, 102, 'Turma intermediaria', '2027-03-16 12:00', 120, 10)$c$);

CALL pg_temp.caso('C03', 'ACEITO', 'Nova sessao 112 das 10h as 11h, mesmo horario da 100, mas na Sala 101',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (112, 102, 101, 'Plantao de duvidas', '2027-03-16 10:00', 60, 20)$c$);

CALL pg_temp.caso('C04', 'REJEITADO', 'Mover a sessao 101 para as 11h (cairia sobre as sessoes 100 e 111)',
  $c$UPDATE sessao SET DataHoraInicio = '2027-03-16 11:00' WHERE SessaoId = 101$c$);

CALL pg_temp.caso('C05', 'ACEITO', 'Adiar a sessao 101 para as 14h30 (horario livre)',
  $c$UPDATE sessao SET DataHoraInicio = '2027-03-16 14:30' WHERE SessaoId = 101$c$);

CALL pg_temp.caso('C06', 'REJEITADO', 'Aumentar a sessao 111 para 3h (12h-15h invadiria a sessao 101)',
  $c$UPDATE sessao SET Duracao = 180 WHERE SessaoId = 111$c$);


-- ============================================================
-- 4. TRIGGER 3 - Capacidade e recursos do espaco (trg_sessao_requisitos)
--    Sala 101: 20 lugares | Lab 102: 15 | Auditorio Norte: 80
-- ============================================================
CALL pg_temp.caso('C07', 'REJEITADO', 'Nova sessao 113 com 25 vagas na Sala 101 (capacidade 20)',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (113, 102, 101, 'Turma lotada', '2027-03-18 09:00', 60, 25)$c$);

CALL pg_temp.caso('C08', 'ACEITO', 'Nova sessao 114 com 20 vagas na Sala 101 (exatamente a capacidade)',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (114, 102, 101, 'Turma de revisao', '2027-03-18 09:00', 60, 20)$c$);

CALL pg_temp.caso('C09', 'REJEITADO', 'Aumentar as vagas da sessao 103 para 21 (Sala 101 tem 20)',
  $c$UPDATE sessao SET Vagas = 21 WHERE SessaoId = 103$c$);

CALL pg_temp.caso('C10', 'ACEITO', 'Reduzir as vagas da sessao 103 para 18',
  $c$UPDATE sessao SET Vagas = 18 WHERE SessaoId = 103$c$);

CALL pg_temp.caso('C11', 'REJEITADO', 'Mover a sessao 100 (exige 5 computadores) para o Auditorio Norte (sem computadores)',
  $c$UPDATE sessao SET EspacoId = 103 WHERE SessaoId = 100$c$);

CALL pg_temp.caso('C12', 'ACEITO', 'Mover a sessao 103 (exige projetor, 18 vagas) para o Auditorio Norte',
  $c$UPDATE sessao SET EspacoId = 103 WHERE SessaoId = 103$c$);

CALL pg_temp.caso('C13', 'REJEITADO', 'Definir a Sala 101 (20 lugares) para a sessao 104 (60 vagas)',
  $c$UPDATE sessao SET EspacoId = 101 WHERE SessaoId = 104$c$);

CALL pg_temp.caso('C14', 'ACEITO', 'Definir o Auditorio Norte (80 lugares) para a sessao 104 (60 vagas)',
  $c$UPDATE sessao SET EspacoId = 103 WHERE SessaoId = 104$c$);


-- ============================================================
-- 5. TRIGGER 4 - Recurso existe no espaco (trg_recursos_sessao_requisitos)
-- ============================================================
CALL pg_temp.caso('C15', 'REJEITADO', 'Sessao 114 (Sala 101) pede 10 computadores; a sala nao tem computadores',
  $c$INSERT INTO recursos_sessao (SessaoId, RecursoId, QtdNecessaria) VALUES (114, 2, 10)$c$);

CALL pg_temp.caso('C16', 'REJEITADO', 'Sessao 102 (Auditorio Norte) passa a pedir 3 microfones; ha 2',
  $c$UPDATE recursos_sessao SET QtdNecessaria = 3 WHERE SessaoId = 102 AND RecursoId = 5$c$);

CALL pg_temp.caso('C17', 'ACEITO', 'Sessao 114 (Sala 101) pede 1 projetor',
  $c$INSERT INTO recursos_sessao (SessaoId, RecursoId, QtdNecessaria) VALUES (114, 1, 1)$c$);

CALL pg_temp.caso('C18', 'ACEITO', 'Sessao 102 passa a pedir 2 microfones (exatamente o estoque)',
  $c$UPDATE recursos_sessao SET QtdNecessaria = 2 WHERE SessaoId = 102 AND RecursoId = 5$c$);

CALL pg_temp.caso('C19', 'ACEITO', 'Nova sessao 115 sem espaco definido (50 vagas)',
  $c$INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas)
     VALUES (115, 103, NULL, 'Feira de projetos', '2027-03-19 10:00', 120, 50)$c$);

CALL pg_temp.caso('C20', 'ACEITO', 'Sessao 115 (sem espaco) pede 20 estandes: aceito, ainda nao ha espaco para conferir',
  $c$INSERT INTO recursos_sessao (SessaoId, RecursoId, QtdNecessaria) VALUES (115, 8, 20)$c$);

CALL pg_temp.caso('C21', 'REJEITADO', 'Definir o Auditorio Norte para a sessao 115 (o auditorio nao tem estandes)',
  $c$UPDATE sessao SET EspacoId = 103 WHERE SessaoId = 115$c$);


-- ============================================================
-- 6. TRIGGER 2 - Limite de vagas (trg_inscricao_limite_vagas)
--    Sessao 100: 5 vagas, comeca com 4 ouvintes (101, 102, 103, 104)
-- ============================================================
CALL pg_temp.caso('C22', 'ACEITO', 'Participante 108 entra como ouvinte na sessao 100 (5a vaga: lota a sessao)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1108, 100, 'ouvinte')$c$);

CALL pg_temp.caso('C23', 'REJEITADO', 'Participante 109 tenta entrar como ouvinte na sessao 100 (lotada)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1109, 100, 'ouvinte')$c$);

CALL pg_temp.caso('C24', 'ACEITO', 'Participante 109 entra na sessao 100 como INSTRUTOR auxiliar (nao ocupa vaga)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1109, 100, 'instrutor')$c$);

CALL pg_temp.caso('C25', 'REJEITADO', 'Trocar o papel do participante 109 na sessao 100 para ouvinte (sessao lotada)',
  $c$UPDATE inscricao SET Papel = 'ouvinte' WHERE CredenciamentoId = 1109 AND SessaoId = 100$c$);

CALL pg_temp.caso('C26', 'REJEITADO', 'Mover a inscricao do participante 111 da sessao 101 para a 100 (lotada)',
  $c$UPDATE inscricao SET SessaoId = 100 WHERE CredenciamentoId = 1111 AND SessaoId = 101$c$);

CALL pg_temp.caso('C27', 'ACEITO', 'Cancelamento: participante 101 sai da sessao 100 (libera 1 vaga)',
  $c$DELETE FROM inscricao WHERE CredenciamentoId = 1101 AND SessaoId = 100$c$);

CALL pg_temp.caso('C28', 'ACEITO', 'Participante 110 ocupa a vaga liberada na sessao 100',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1110, 100, 'ouvinte')$c$);


-- ============================================================
-- 7. TRIGGER 1 - Conflito de horario da pessoa (trg_inscricao_conflito_horario)
--    Participante 102 esta na sessao 100 (16/03, 09h-12h)
--    Sessao 112 = 16/03 10h-11h (Sala 101) | Sessao 111 = 16/03 12h-14h (Lab 102)
-- ============================================================
CALL pg_temp.caso('C29', 'REJEITADO', 'Participante 102 se inscreve como ouvinte na sessao 112 (choca com a 100)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1102, 112, 'ouvinte')$c$);

CALL pg_temp.caso('C30', 'REJEITADO', 'Participante 102 tenta ser PALESTRANTE na sessao 112 (o papel nao importa)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1102, 112, 'palestrante')$c$);

CALL pg_temp.caso('C31', 'ACEITO', 'Participante 102 se inscreve na sessao 111 (12h, quando a 100 termina)',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1102, 111, 'ouvinte')$c$);

CALL pg_temp.caso('C32', 'ACEITO', 'Participante 112 (sem outras sessoes no dia) se inscreve na sessao 112',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1112, 112, 'ouvinte')$c$);

CALL pg_temp.caso('C33', 'REJEITADO', 'Mover a inscricao do participante 102 da sessao 111 para a 112 (choca com a 100)',
  $c$UPDATE inscricao SET SessaoId = 112 WHERE CredenciamentoId = 1102 AND SessaoId = 111$c$);

CALL pg_temp.caso('C34', 'ACEITO', 'Troca de turma: participante 103 passa da sessao 100 para a 101',
  $c$UPDATE inscricao SET SessaoId = 101 WHERE CredenciamentoId = 1103 AND SessaoId = 100$c$);


-- ============================================================
-- 8. LACUNA (nenhum trigger trata) - hoje o banco ACEITA
--    Participante 114 esta credenciada SO no evento 5, mas consegue
--    se inscrever numa sessao do evento 100.
-- ============================================================
CALL pg_temp.caso('C35', 'ACEITO (lacuna)', 'Participante 114 (credenciada so no evento 5) entra na sessao 101 do evento 100',
  $c$INSERT INTO inscricao (CredenciamentoId, SessaoId, Papel) VALUES (1114, 101, 'ouvinte')$c$);


-- ============================================================
-- 9. Ajuste das sequencias (os casos inseriram ids explicitos)
-- ============================================================
SELECT setval(pg_get_serial_sequence('evento', 'eventoid'),                 (SELECT MAX(EventoId)         FROM evento));
SELECT setval(pg_get_serial_sequence('espaco', 'espacoid'),                 (SELECT MAX(EspacoId)         FROM espaco));
SELECT setval(pg_get_serial_sequence('atividade', 'atividadeid'),           (SELECT MAX(AtividadeId)      FROM atividade));
SELECT setval(pg_get_serial_sequence('sessao', 'sessaoid'),                 (SELECT MAX(SessaoId)         FROM sessao));
SELECT setval(pg_get_serial_sequence('participante', 'participanteid'),     (SELECT MAX(ParticipanteId)   FROM participante));
SELECT setval(pg_get_serial_sequence('credenciamento', 'credenciamentoid'), (SELECT MAX(CredenciamentoId) FROM credenciamento));


-- ============================================================
-- 10. CONFERENCIA NAS TABELAS
-- A coluna "tabela_confere" e calculada lendo as TABELAS (nao o log).
-- A coluna "consulta_para_conferir" traz o SELECT que voce pode rodar.
-- ============================================================
WITH conf (caso, tabela_confere, consulta_para_conferir) AS (
  VALUES
  ('C01', NOT EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 110),
          'SELECT * FROM sessao WHERE SessaoId = 110;  -- nenhuma linha'),
  ('C02', EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 111),
          'SELECT * FROM sessao WHERE SessaoId = 111;  -- 1 linha, 12h-14h'),
  ('C03', EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 112 AND EspacoId = 101),
          'SELECT * FROM sessao WHERE SessaoId = 112;  -- 1 linha, Sala 101'),
  ('C04', (SELECT DataHoraInicio <> TIMESTAMP '2027-03-16 11:00' FROM sessao WHERE SessaoId = 101),
          'SELECT DataHoraInicio FROM sessao WHERE SessaoId = 101;  -- nao e 11:00'),
  ('C05', (SELECT DataHoraInicio = TIMESTAMP '2027-03-16 14:30' AND DataHoraFim = TIMESTAMP '2027-03-16 17:30' FROM sessao WHERE SessaoId = 101),
          'SELECT DataHoraInicio, DataHoraFim FROM sessao WHERE SessaoId = 101;  -- 14:30 a 17:30'),
  ('C06', (SELECT Duracao = 120 FROM sessao WHERE SessaoId = 111),
          'SELECT Duracao FROM sessao WHERE SessaoId = 111;  -- continua 120'),
  ('C07', NOT EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 113),
          'SELECT * FROM sessao WHERE SessaoId = 113;  -- nenhuma linha'),
  ('C08', EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 114 AND Vagas = 20),
          'SELECT * FROM sessao WHERE SessaoId = 114;  -- 1 linha, 20 vagas'),
  ('C09', (SELECT Vagas <> 21 FROM sessao WHERE SessaoId = 103),
          'SELECT Vagas FROM sessao WHERE SessaoId = 103;  -- nao e 21'),
  ('C10', (SELECT Vagas = 18 FROM sessao WHERE SessaoId = 103),
          'SELECT Vagas FROM sessao WHERE SessaoId = 103;  -- 18'),
  ('C11', (SELECT EspacoId = 102 FROM sessao WHERE SessaoId = 100),
          'SELECT EspacoId FROM sessao WHERE SessaoId = 100;  -- continua 102'),
  ('C12', (SELECT EspacoId = 103 FROM sessao WHERE SessaoId = 103),
          'SELECT EspacoId FROM sessao WHERE SessaoId = 103;  -- 103'),
  ('C13', (SELECT EspacoId IS DISTINCT FROM 101 FROM sessao WHERE SessaoId = 104),
          'SELECT EspacoId FROM sessao WHERE SessaoId = 104;  -- nao e 101'),
  ('C14', (SELECT EspacoId = 103 FROM sessao WHERE SessaoId = 104),
          'SELECT EspacoId FROM sessao WHERE SessaoId = 104;  -- 103'),
  ('C15', NOT EXISTS (SELECT 1 FROM recursos_sessao WHERE SessaoId = 114 AND RecursoId = 2),
          'SELECT * FROM recursos_sessao WHERE SessaoId = 114;  -- sem computadores (RecursoId 2)'),
  ('C16', (SELECT QtdNecessaria <> 3 FROM recursos_sessao WHERE SessaoId = 102 AND RecursoId = 5),
          'SELECT QtdNecessaria FROM recursos_sessao WHERE SessaoId = 102 AND RecursoId = 5;  -- nao e 3'),
  ('C17', EXISTS (SELECT 1 FROM recursos_sessao WHERE SessaoId = 114 AND RecursoId = 1),
          'SELECT * FROM recursos_sessao WHERE SessaoId = 114;  -- projetor (RecursoId 1)'),
  ('C18', (SELECT QtdNecessaria = 2 FROM recursos_sessao WHERE SessaoId = 102 AND RecursoId = 5),
          'SELECT QtdNecessaria FROM recursos_sessao WHERE SessaoId = 102 AND RecursoId = 5;  -- 2'),
  ('C19', EXISTS (SELECT 1 FROM sessao WHERE SessaoId = 115),
          'SELECT * FROM sessao WHERE SessaoId = 115;  -- 1 linha'),
  ('C20', EXISTS (SELECT 1 FROM recursos_sessao WHERE SessaoId = 115 AND RecursoId = 8 AND QtdNecessaria = 20),
          'SELECT * FROM recursos_sessao WHERE SessaoId = 115;  -- 20 estandes'),
  ('C21', (SELECT EspacoId IS NULL FROM sessao WHERE SessaoId = 115),
          'SELECT EspacoId FROM sessao WHERE SessaoId = 115;  -- continua NULL'),
  ('C22', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1108 AND SessaoId = 100 AND Papel = 'ouvinte'),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1108;  -- ouvinte na 100'),
  ('C23', NOT EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1109 AND SessaoId = 100 AND Papel = 'ouvinte'),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1109;  -- nao ha linha de ouvinte'),
  ('C24', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1109 AND SessaoId = 100 AND Papel = 'instrutor'),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1109;  -- instrutor na 100'),
  ('C25', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1109 AND SessaoId = 100 AND Papel = 'instrutor'),
          'SELECT Papel FROM inscricao WHERE CredenciamentoId = 1109;  -- continua instrutor'),
  ('C26', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1111 AND SessaoId = 101),
          'SELECT SessaoId FROM inscricao WHERE CredenciamentoId = 1111;  -- continua 101'),
  ('C27', NOT EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1101 AND SessaoId = 100),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1101;  -- so a sessao 103'),
  ('C28', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1110 AND SessaoId = 100),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1110;  -- ouvinte na 100'),
  ('C29', NOT EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1102 AND SessaoId = 112),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1102;  -- nao aparece a 112'),
  ('C30', NOT EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1102 AND SessaoId = 112),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1102;  -- nao aparece a 112'),
  ('C31', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1102 AND SessaoId = 111),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1102;  -- sessoes 100 e 111'),
  ('C32', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1112 AND SessaoId = 112),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1112;  -- sessao 112'),
  ('C33', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1102 AND SessaoId = 111),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1102;  -- continua na 111'),
  ('C34', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1103 AND SessaoId = 101)
          AND NOT EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1103 AND SessaoId = 100),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1103;  -- agora na 101'),
  ('C35', EXISTS (SELECT 1 FROM inscricao WHERE CredenciamentoId = 1114 AND SessaoId = 101),
          'SELECT * FROM inscricao WHERE CredenciamentoId = 1114;  -- foi aceita (lacuna)')
)
SELECT l.caso,
       l.descricao,
       l.esperado,
       l.resultado,
       CASE WHEN split_part(l.esperado, ' ', 1) = l.resultado THEN 'sim' ELSE 'NAO' END AS como_esperado,
       c.tabela_confere,
       l.mensagem AS mensagem_do_trigger,
       c.consulta_para_conferir
FROM log_casos l
JOIN conf c ON c.caso = l.caso
ORDER BY l.caso;


-- ============================================================
-- 11. CONSULTAS UTEIS PARA OLHAR O RESULTADO FINAL
-- (selecione uma e execute com F5)
-- ============================================================
-- Sessoes do evento 100:
-- SELECT s.SessaoId, a.Nome AS atividade, s.Nome, e.Nome AS espaco, s.DataHoraInicio, s.DataHoraFim, s.Vagas
-- FROM sessao s JOIN atividade a ON a.AtividadeId = s.AtividadeId LEFT JOIN espaco e ON e.EspacoId = s.EspacoId
-- WHERE a.EventoId = 100 ORDER BY s.SessaoId;
--
-- Inscricoes das sessoes do evento 100 (com nome do participante):
-- SELECT i.SessaoId, p.ParticipanteId, p.Nome, i.Papel, c.EventoId AS evento_do_credenciamento
-- FROM inscricao i JOIN credenciamento c ON c.CredenciamentoId = i.CredenciamentoId
-- JOIN participante p ON p.ParticipanteId = c.ParticipanteId
-- WHERE i.SessaoId BETWEEN 100 AND 115 ORDER BY i.SessaoId, i.Papel, p.ParticipanteId;
--
-- Ocupacao (ouvintes x vagas):
-- SELECT s.SessaoId, s.Vagas, COUNT(i.*) FILTER (WHERE i.Papel = 'ouvinte') AS ouvintes
-- FROM sessao s LEFT JOIN inscricao i ON i.SessaoId = s.SessaoId
-- WHERE s.SessaoId BETWEEN 100 AND 115 GROUP BY s.SessaoId, s.Vagas ORDER BY s.SessaoId;
--
-- Recursos pedidos pelas sessoes do evento 100:
-- SELECT rs.SessaoId, r.Nome, rs.QtdNecessaria FROM recursos_sessao rs JOIN recursos r ON r.RecursoId = rs.RecursoId
-- WHERE rs.SessaoId BETWEEN 100 AND 115 ORDER BY rs.SessaoId;