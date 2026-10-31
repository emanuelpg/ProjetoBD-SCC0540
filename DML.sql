-- ============================================================
-- SCC0640 - Sistema de Gestao de Eventos e Espacos
-- DML.sql - Dados para popular o banco "eventos"
-- Executar apos o DDL
-- ============================================================

BEGIN;

-- ------------------------------------------------------------
-- PROMOTOR e subtipos (especializacao disjunta)
-- ------------------------------------------------------------
INSERT INTO promotor (PromotorId, Nome, Email, Telefone, CEP, Endereco) VALUES
  (1, 'Instituto de Computacao Paulista', 'contato@icp.org.br', '1633731000', '13566590', 'Av. Trabalhador Sao-carlense, 400 - Centro, Sao Carlos/SP'),
  (2, 'TechNova Solucoes Ltda', 'eventos@technova.com.br', '1132004500', '04538133', 'Rua das Inovacoes, 1200 - Itaim Bibi, Sao Paulo/SP'),
  (3, 'Associacao Brasileira de Dados', 'secretaria@abdados.org.br', '2125551200', '20040002', 'Av. Rio Branco, 156 - Centro, Rio de Janeiro/RJ'),
  (4, 'DataSul Consultoria', 'parcerias@datasul.com.br', '5133309900', '90010150', 'Rua dos Andradas, 980 - Centro, Porto Alegre/RS'),
  (5, 'Fundacao Inova Sao Carlos', 'fomento@inovasc.org.br', '1633628800', '13560970', 'Rua Episcopal, 1575 - Centro, Sao Carlos/SP'),
  (6, 'Carlos Eduardo Mendes', 'carlos.mendes@email.com', '16991234567', '13561120', 'Rua Dona Alexandrina, 210 - Centro, Sao Carlos/SP'),
  (7, 'Fernanda Lima Rocha', 'fernanda.rocha@email.com', '11987654321', '01310100', 'Av. Paulista, 1500 - Bela Vista, Sao Paulo/SP'),
  (8, 'Ricardo Tavares', NULL, NULL, NULL, NULL);

INSERT INTO organizacao (OrganizacaoId, CNPJ) VALUES
  (1, '11222333000181'),
  (2, '22333444000172'),
  (3, '33444555000163'),
  (4, '44555666000154'),
  (5, '55666777000145');

INSERT INTO pessoa_promotor (PessoaPId, CPF) VALUES
  (6, '30542187611'),
  (7, '41653298722'),
  (8, '52764309833');

-- ------------------------------------------------------------
-- EVENTO (eventos passados e futuros; duas edicoes da Semana da Computacao)
-- ------------------------------------------------------------
INSERT INTO evento (EventoId, Nome, Inicio, Fim, Descricao) VALUES
  (1, 'Semana da Computacao 2025', '2025-09-15 08:00', '2025-09-19 18:00', 'Edicao 2025 da semana academica com palestras, minicursos e workshops.'),
  (2, 'Semana da Computacao 2026', '2026-11-09 08:00', '2026-11-13 18:00', 'Edicao 2026 da semana academica com palestras, minicursos, workshops e maratona.'),
  (3, 'Simposio Brasileiro de Banco de Dados 2026', '2026-10-05 08:00', '2026-10-08 18:00', 'Simposio cientifico com keynotes, sessoes tecnicas e tutoriais.'),
  (4, 'Feira de Inovacao e Startups 2026', '2026-10-20 09:00', '2026-10-22 20:00', 'Feira com exposicao de startups, pitches e palestras sobre investimento.'),
  (5, 'Treinamento Intensivo em PostgreSQL', '2026-11-23 08:00', '2026-11-27 18:00', 'Treinamento pratico em laboratorio, dividido em tres modulos.'),
  (6, 'Workshop de Inteligencia Artificial 2026', '2026-12-03 09:00', '2026-12-04 18:00', NULL);

-- ------------------------------------------------------------
-- PATROCINIO (promocao conjunta: varios promotores por evento)
-- ------------------------------------------------------------
INSERT INTO patrocinio (EventoId, PromotorId, Valor, Data_patrocinio) VALUES
  (1, 1, 5000.00, '2025-08-01'),
  (1, 2, 3000.00, '2025-07-07'),
  (2, 1, 6000.00, '2026-08-07'),
  (2, 2, 3500.00, '2026-08-06'),
  (2, 4, 2000.00, '2026-07-20'),
  (3, 3, 8000.00, '2026-08-23'),
  (3, 1, 4000.00, '2026-08-08'),
  (4, 5, 10000.00, '2026-07-06'),
  (4, 2, 7500.00, '2026-07-03'),
  (4, 6, 1500.00, '2026-07-11'),
  (5, 4, 2500.00, '2026-09-01'),
  (5, 7, 1200.00, '2026-08-12'),
  (6, 3, 3000.00, '2026-08-25'),
  (6, 7, 800.00, '2026-09-02');

-- ------------------------------------------------------------
-- ESPACO
-- ------------------------------------------------------------
INSERT INTO espaco (EspacoId, Nome, LimitePessoas, CEP, Numero, Rua, Bairro, Cidade, Estado) VALUES
  (1, 'Auditorio Principal', 300, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (2, 'Sala A', 60, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (3, 'Sala B', 40, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (4, 'Laboratorio 1', 30, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (5, 'Laboratorio 2', 25, '13566590', '400', 'Av. Trabalhador Sao-carlense', 'Centro', 'Sao Carlos', 'SP'),
  (6, 'Area de Exposicao', 500, '13560970', '1575', 'Rua Episcopal', 'Centro', 'Sao Carlos', 'SP'),
  (7, 'Mini-auditorio', 120, '13560970', '1575', 'Rua Episcopal', 'Centro', 'Sao Carlos', 'SP'),
  (8, 'Sala de Reunioes', 15, '13561120', '210', NULL, NULL, NULL, NULL);

-- ------------------------------------------------------------
-- RECURSOS
-- ------------------------------------------------------------
INSERT INTO recursos (RecursoId, Nome, Descricao) VALUES
  (1, 'Projetor', 'Projetor multimidia com entrada HDMI'),
  (2, 'Computadores', 'Estacoes de trabalho com PostgreSQL e Python instalados'),
  (3, 'Sistema de audio', 'Mesa de som com caixas amplificadas'),
  (4, 'Internet Wi-Fi', 'Rede sem fio para os participantes'),
  (5, 'Microfone sem fio', 'Microfone de mao sem fio'),
  (6, 'Lousa digital', 'Lousa interativa sensivel ao toque'),
  (7, 'Transmissao ao vivo', 'Camera e encoder para transmissao online'),
  (8, 'Estande de exposicao', 'Estande modular de 3x3 m');

-- ------------------------------------------------------------
-- ESTOQUE (recursos disponiveis em cada espaco)
-- ------------------------------------------------------------
INSERT INTO estoque (EspacoId, RecursoId, Quantidade) VALUES
  (1, 1, 2),
  (1, 3, 1),
  (1, 4, 1),
  (1, 5, 4),
  (1, 7, 1),
  (2, 1, 1),
  (2, 4, 1),
  (2, 6, 1),
  (3, 1, 1),
  (3, 4, 1),
  (4, 1, 1),
  (4, 2, 30),
  (4, 4, 1),
  (5, 1, 1),
  (5, 2, 25),
  (5, 4, 1),
  (5, 6, 1),
  (6, 3, 1),
  (6, 4, 1),
  (6, 5, 2),
  (6, 8, 40),
  (7, 1, 1),
  (7, 3, 1),
  (7, 4, 1),
  (7, 5, 2),
  (8, 4, 1);

-- ------------------------------------------------------------
-- ATIVIDADE (a atividade 20 ainda nao possui sessao)
-- ------------------------------------------------------------
INSERT INTO atividade (AtividadeId, EventoId, Nome, Descricao) VALUES
  (1, 1, 'Palestra de Abertura: Carreiras em Computacao', 'Panorama das carreiras na area.'),
  (2, 1, 'Minicurso de Python', 'Introducao a linguagem Python.'),
  (3, 1, 'Workshop de Git', 'Controle de versao na pratica.'),
  (4, 1, 'Mesa-redonda: Mulheres na Tecnologia', 'Debate com profissionais da area.'),
  (5, 2, 'Palestra de Abertura: IA Generativa', 'Impactos da IA generativa.'),
  (6, 2, 'Minicurso de Python', 'Introducao a linguagem Python.'),
  (7, 2, 'Workshop de PostgreSQL', 'Modelagem, SQL e triggers na pratica.'),
  (8, 2, 'Painel: Mercado de Trabalho', 'Recrutadores comentam o mercado.'),
  (9, 2, 'Maratona de Programacao', 'Competicao em equipes.'),
  (10, 3, 'Keynote: Bancos de Dados Vetoriais', 'Busca por similaridade em larga escala.'),
  (11, 3, 'Sessao Tecnica: Otimizacao de Consultas', 'Apresentacao de artigos selecionados.'),
  (12, 3, 'Tutorial: Modelagem de Dados', 'Do modelo conceitual ao relacional.'),
  (13, 4, 'Exposicao de Startups', 'Estandes das startups participantes.'),
  (14, 4, 'Pitch de Startups', 'Apresentacoes de 5 minutos para investidores.'),
  (15, 4, 'Palestra: Captacao de Investimento', 'Como preparar uma rodada seed.'),
  (16, 5, 'Modulo 1: SQL Basico', 'DDL e DML.'),
  (17, 5, 'Modulo 2: Funcoes e Triggers', 'PL/pgSQL.'),
  (18, 5, 'Modulo 3: Desempenho e Indices', 'EXPLAIN e indices.'),
  (19, 6, 'Palestra: Etica em IA', 'Vieses e responsabilidade.'),
  (20, 6, 'Hands-on: Redes Neurais', NULL);

-- ------------------------------------------------------------
-- SESSAO
--  * atividades com mais de uma sessao: 2, 6, 7, 11
--  * sessao 9/10: limite proprio (20) menor que a capacidade da sala (25)
--  * sessao 22: vagas totalmente preenchidas
--  * sessao 23: ainda sem espaco (EspacoId NULL)
--  * Valor omitido usa o DEFAULT 0
-- ------------------------------------------------------------
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (1, 1, 1, 'Sessao unica', '2025-09-15 09:00', 120, 300);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (2, 2, 4, 'Turma 1', '2025-09-16 09:00', 180, 30, 30.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (3, 2, 5, 'Turma 2', '2025-09-16 14:00', 180, 25, 30.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (4, 3, 4, 'Sessao unica', '2025-09-17 14:00', 120, 30, 20.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (5, 4, 7, 'Sessao unica', '2025-09-18 10:00', 90, 120);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (6, 5, 1, 'Sessao unica', '2026-11-09 09:00', 120, 300);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (7, 6, 4, 'Turma 1', '2026-11-10 09:00', 180, 30, 35.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (8, 6, 4, 'Turma 2', '2026-11-10 14:00', 180, 30, 35.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (9, 7, 5, 'Turma 1', '2026-11-11 09:00', 180, 20, 50.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (10, 7, 5, 'Turma 2', '2026-11-11 14:00', 180, 20, 50.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (11, 8, 7, 'Sessao unica', '2026-11-12 10:00', 90, 120);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (12, 9, 4, 'Final', '2026-11-13 08:00', 300, 30);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (13, 10, 1, 'Sessao unica', '2026-10-05 09:00', 60, 300);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (14, 11, 2, 'Sessao 1', '2026-10-06 14:00', 120, 60);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (15, 11, 3, 'Sessao 2', '2026-10-07 14:00', 120, 40);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (16, 12, 2, 'Sessao unica', '2026-10-08 09:00', 240, 60, 80.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (17, 13, 6, 'Exposicao', '2026-10-20 09:00', 660, 500);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (18, 14, 1, 'Rodada de pitches', '2026-10-21 14:00', 180, 300);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (19, 15, 7, 'Sessao unica', '2026-10-22 10:00', 90, 120);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (20, 16, 5, 'Modulo 1', '2026-11-23 08:00', 240, 25, 150.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (21, 17, 5, 'Modulo 2', '2026-11-25 08:00', 240, 25, 150.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas, Valor) VALUES (22, 18, 5, 'Modulo 3', '2026-11-27 08:00', 240, 10, 150.00);
INSERT INTO sessao (SessaoId, AtividadeId, EspacoId, Nome, DataHoraInicio, Duracao, Vagas) VALUES (23, 19, NULL, 'Sessao unica', '2026-12-03 10:00', 60, 100);

-- ------------------------------------------------------------
-- RECURSOS_SESSAO (todos disponiveis no espaco da sessao)
-- ------------------------------------------------------------
INSERT INTO recursos_sessao (SessaoId, RecursoId, QtdNecessaria) VALUES
  (1, 1, 1),
  (1, 3, 1),
  (1, 5, 2),
  (2, 2, 30),
  (2, 1, 1),
  (3, 2, 25),
  (3, 1, 1),
  (4, 2, 20),
  (4, 1, 1),
  (4, 4, 1),
  (5, 5, 2),
  (5, 3, 1),
  (6, 1, 1),
  (6, 3, 1),
  (6, 5, 2),
  (6, 7, 1),
  (7, 2, 30),
  (8, 2, 30),
  (9, 2, 20),
  (9, 6, 1),
  (10, 2, 20),
  (11, 5, 2),
  (11, 1, 1),
  (12, 2, 30),
  (12, 4, 1),
  (13, 1, 1),
  (13, 7, 1),
  (14, 1, 1),
  (15, 1, 1),
  (16, 1, 1),
  (16, 6, 1),
  (17, 8, 30),
  (17, 4, 1),
  (18, 3, 1),
  (18, 5, 4),
  (18, 1, 2),
  (19, 1, 1),
  (20, 2, 25),
  (21, 2, 25),
  (22, 2, 10),
  (22, 1, 1),
  (23, 1, 1);

-- ------------------------------------------------------------
-- PARTICIPANTE (40 pessoas ficticias)
-- ------------------------------------------------------------
INSERT INTO participante (ParticipanteId, CPF, Nome, DataNascimento) VALUES
  (1, '97309114170', 'Ana Beatriz Souza', '2003-11-11'),
  (2, '36455681518', 'Bruno Henrique Alves', '2006-05-10'),
  (3, '72940557616', 'Camila Ferreira', '2007-08-28'),
  (4, '16897684697', 'Daniel Oliveira', '2004-09-26'),
  (5, '09320819672', 'Eduarda Martins', '2002-04-28'),
  (6, '17784864887', 'Felipe Costa', '1997-07-07'),
  (7, '44002978753', 'Gabriela Ribeiro', '1988-12-16'),
  (8, '78768045717', 'Henrique Carvalho', '2004-05-15'),
  (9, '26714751362', 'Isabela Gomes', '2000-01-03'),
  (10, '07981933190', 'Joao Pedro Santos', '2006-05-22'),
  (11, '52059972837', 'Karina Lopes', '1980-10-23'),
  (12, '84162294866', 'Lucas Almeida', '1981-09-26'),
  (13, '36016105500', 'Mariana Pereira', '2004-08-11'),
  (14, '47517799229', 'Nicolas Barbosa', '2005-04-14'),
  (15, '95793186032', 'Olivia Cardoso', '1974-11-18'),
  (16, '07370283822', 'Paulo Ricardo Dias', '1983-07-09'),
  (17, '68616425247', 'Rafaela Teixeira', '2003-07-10'),
  (18, '72587718841', 'Samuel Rocha', '1985-04-01'),
  (19, '17568205258', 'Tatiane Moreira', '2006-04-04'),
  (20, '94893949482', 'Vinicius Araujo', '1978-05-04'),
  (21, '62105218549', 'Wesley Nunes', '1976-05-11'),
  (22, '24410646001', 'Yasmin Correia', '1987-01-10'),
  (23, '11895579906', 'Andre Luiz Freitas', '1992-10-07'),
  (24, '97615846450', 'Beatriz Mendes', '1999-01-10'),
  (25, '54146590853', 'Caio Vasconcelos', '2007-01-24'),
  (26, '12911028594', 'Debora Pinto', '1973-07-19'),
  (27, '25666363228', 'Eduardo Ramos', '1973-11-23'),
  (28, '88642300487', 'Fernanda Castro', '1998-05-11'),
  (29, '29128084585', 'Gustavo Monteiro', '1975-11-27'),
  (30, '03703826538', 'Helena Duarte', '1989-06-28'),
  (31, '35577879432', 'Igor Fernandes', '1998-03-16'),
  (32, '05860214584', 'Juliana Batista', '1980-12-24'),
  (33, '10839490668', 'Leonardo Cunha', '2005-11-22'),
  (34, '28112658440', 'Larissa Macedo', '1984-03-10'),
  (35, '48452630976', 'Marcelo Azevedo', '1994-09-06'),
  (36, '80258220180', 'Natalia Brito', '1995-02-12'),
  (37, '43829932157', 'Otavio Siqueira', '1978-12-03'),
  (38, '64941577188', 'Priscila Farias', '1987-06-22'),
  (39, '79511174432', 'Rodrigo Moura', '1992-07-17'),
  (40, '85576523735', 'Sofia Nascimento', '1994-07-27');

-- ------------------------------------------------------------
-- CREDENCIAMENTO (Organizacao = TRUE -> participante organiza o evento)
--  * 14 participantes da edicao 2025 voltam na edicao 2026
-- ------------------------------------------------------------
INSERT INTO credenciamento (CredenciamentoId, ParticipanteId, EventoId, Organizacao) VALUES
  (1, 4, 1, FALSE),
  (2, 5, 1, FALSE),
  (3, 8, 1, FALSE),
  (4, 9, 1, FALSE),
  (5, 10, 1, FALSE),
  (6, 11, 1, FALSE),
  (7, 14, 1, FALSE),
  (8, 15, 1, FALSE),
  (9, 18, 1, FALSE),
  (10, 21, 1, FALSE),
  (11, 22, 1, FALSE),
  (12, 23, 1, FALSE),
  (13, 24, 1, FALSE),
  (14, 25, 1, TRUE),
  (15, 27, 1, FALSE),
  (16, 28, 1, FALSE),
  (17, 29, 1, FALSE),
  (18, 30, 1, FALSE),
  (19, 31, 1, FALSE),
  (20, 32, 1, FALSE),
  (21, 33, 1, FALSE),
  (22, 34, 1, FALSE),
  (23, 35, 1, FALSE),
  (24, 36, 1, FALSE),
  (25, 38, 1, TRUE),
  (26, 39, 1, FALSE),
  (27, 1, 2, FALSE),
  (28, 2, 2, FALSE),
  (29, 3, 2, FALSE),
  (30, 4, 2, FALSE),
  (31, 5, 2, FALSE),
  (32, 7, 2, FALSE),
  (33, 8, 2, TRUE),
  (34, 10, 2, FALSE),
  (35, 11, 2, FALSE),
  (36, 13, 2, FALSE),
  (37, 15, 2, TRUE),
  (38, 16, 2, FALSE),
  (39, 17, 2, FALSE),
  (40, 18, 2, FALSE),
  (41, 19, 2, FALSE),
  (42, 20, 2, FALSE),
  (43, 21, 2, TRUE),
  (44, 22, 2, FALSE),
  (45, 23, 2, FALSE),
  (46, 24, 2, FALSE),
  (47, 26, 2, FALSE),
  (48, 27, 2, FALSE),
  (49, 28, 2, FALSE),
  (50, 29, 2, FALSE),
  (51, 30, 2, FALSE),
  (52, 31, 2, FALSE),
  (53, 32, 2, FALSE),
  (54, 33, 2, FALSE),
  (55, 35, 2, FALSE),
  (56, 36, 2, FALSE),
  (57, 38, 2, FALSE),
  (58, 40, 2, FALSE),
  (59, 1, 3, FALSE),
  (60, 3, 3, FALSE),
  (61, 4, 3, FALSE),
  (62, 7, 3, FALSE),
  (63, 9, 3, FALSE),
  (64, 11, 3, FALSE),
  (65, 12, 3, FALSE),
  (66, 15, 3, FALSE),
  (67, 17, 3, FALSE),
  (68, 20, 3, FALSE),
  (69, 21, 3, FALSE),
  (70, 22, 3, TRUE),
  (71, 27, 3, FALSE),
  (72, 28, 3, FALSE),
  (73, 31, 3, FALSE),
  (74, 32, 3, FALSE),
  (75, 34, 3, FALSE),
  (76, 35, 3, FALSE),
  (77, 37, 3, FALSE),
  (78, 38, 3, TRUE),
  (79, 39, 3, FALSE),
  (80, 40, 3, FALSE),
  (81, 1, 4, FALSE),
  (82, 3, 4, FALSE),
  (83, 4, 4, FALSE),
  (84, 5, 4, FALSE),
  (85, 6, 4, TRUE),
  (86, 7, 4, FALSE),
  (87, 10, 4, FALSE),
  (88, 13, 4, FALSE),
  (89, 14, 4, FALSE),
  (90, 15, 4, FALSE),
  (91, 17, 4, FALSE),
  (92, 18, 4, FALSE),
  (93, 19, 4, FALSE),
  (94, 20, 4, FALSE),
  (95, 22, 4, FALSE),
  (96, 23, 4, FALSE),
  (97, 25, 4, FALSE),
  (98, 27, 4, FALSE),
  (99, 28, 4, FALSE),
  (100, 29, 4, FALSE),
  (101, 30, 4, FALSE),
  (102, 31, 4, FALSE),
  (103, 32, 4, FALSE),
  (104, 33, 4, FALSE),
  (105, 34, 4, FALSE),
  (106, 35, 4, FALSE),
  (107, 36, 4, TRUE),
  (108, 37, 4, FALSE),
  (109, 39, 4, FALSE),
  (110, 40, 4, FALSE),
  (111, 2, 5, FALSE),
  (112, 9, 5, FALSE),
  (113, 11, 5, FALSE),
  (114, 15, 5, FALSE),
  (115, 16, 5, FALSE),
  (116, 21, 5, FALSE),
  (117, 22, 5, FALSE),
  (118, 23, 5, FALSE),
  (119, 27, 5, FALSE),
  (120, 29, 5, FALSE),
  (121, 31, 5, FALSE),
  (122, 32, 5, FALSE),
  (123, 33, 5, FALSE),
  (124, 36, 5, TRUE),
  (125, 37, 5, FALSE),
  (126, 40, 5, FALSE),
  (127, 2, 6, FALSE),
  (128, 9, 6, FALSE),
  (129, 13, 6, FALSE),
  (130, 17, 6, FALSE),
  (131, 24, 6, FALSE),
  (132, 30, 6, FALSE),
  (133, 31, 6, FALSE),
  (134, 32, 6, TRUE);

-- ------------------------------------------------------------
-- INSCRICAO
--  * programacao geral: apenas palestrantes inscritos na sessao
--  * minicursos, workshops, tutoriais e treinamento: instrutor + ouvintes
--  * nenhuma sessao ultrapassa o numero de vagas
-- ------------------------------------------------------------
INSERT INTO inscricao (CredenciamentoId, SessaoId, DataHora, Papel) VALUES
  (9, 4, '2025-08-06 00:00', 'instrutor'),
  (19, 4, '2025-08-06 05:15', 'ouvinte'),
  (11, 4, '2025-08-07 00:15', 'ouvinte'),
  (6, 3, '2025-08-08 22:15', 'ouvinte'),
  (9, 3, '2025-08-09 02:30', 'ouvinte'),
  (24, 3, '2025-08-09 04:30', 'ouvinte'),
  (16, 4, '2025-08-09 05:15', 'ouvinte'),
  (2, 2, '2025-08-09 20:30', 'ouvinte'),
  (8, 3, '2025-08-10 01:15', 'instrutor'),
  (20, 2, '2025-08-10 06:15', 'ouvinte'),
  (17, 2, '2025-08-10 07:30', 'ouvinte'),
  (22, 3, '2025-08-11 00:30', 'ouvinte'),
  (6, 4, '2025-08-11 02:30', 'ouvinte'),
  (1, 4, '2025-08-11 06:30', 'ouvinte'),
  (18, 5, '2025-08-11 22:00', 'palestrante'),
  (12, 4, '2025-08-12 02:15', 'ouvinte'),
  (2, 4, '2025-08-13 04:15', 'ouvinte'),
  (7, 4, '2025-08-14 00:00', 'ouvinte'),
  (11, 3, '2025-08-15 02:00', 'ouvinte'),
  (23, 5, '2025-08-16 00:00', 'palestrante'),
  (21, 4, '2025-08-16 21:00', 'ouvinte'),
  (13, 3, '2025-08-17 04:15', 'ouvinte'),
  (22, 2, '2025-08-17 21:15', 'ouvinte'),
  (8, 2, '2025-08-18 05:30', 'ouvinte'),
  (23, 3, '2025-08-19 07:15', 'ouvinte'),
  (26, 3, '2025-08-20 20:45', 'ouvinte'),
  (11, 2, '2025-08-20 21:15', 'instrutor'),
  (10, 5, '2025-08-21 20:15', 'palestrante'),
  (21, 3, '2025-08-21 20:45', 'ouvinte'),
  (5, 4, '2025-08-21 22:45', 'ouvinte'),
  (12, 3, '2025-08-22 00:00', 'ouvinte'),
  (19, 3, '2025-08-22 00:45', 'ouvinte'),
  (6, 1, '2025-08-23 02:45', 'palestrante'),
  (5, 3, '2025-08-24 21:15', 'ouvinte'),
  (7, 3, '2025-08-27 03:30', 'ouvinte'),
  (4, 3, '2025-08-27 04:00', 'ouvinte'),
  (10, 4, '2025-08-29 01:45', 'ouvinte'),
  (15, 4, '2025-08-29 02:15', 'ouvinte'),
  (24, 2, '2025-08-29 23:30', 'ouvinte'),
  (17, 4, '2025-08-30 23:00', 'ouvinte'),
  (23, 4, '2025-08-31 20:00', 'ouvinte'),
  (26, 2, '2025-09-01 21:00', 'ouvinte'),
  (10, 2, '2025-09-01 21:45', 'ouvinte'),
  (15, 2, '2025-09-02 05:30', 'ouvinte'),
  (1, 2, '2025-09-03 21:00', 'ouvinte'),
  (23, 2, '2025-09-03 22:45', 'ouvinte'),
  (24, 4, '2025-09-04 03:15', 'ouvinte'),
  (16, 2, '2025-09-04 06:00', 'ouvinte'),
  (5, 2, '2025-09-05 00:45', 'ouvinte'),
  (3, 4, '2025-09-05 03:45', 'ouvinte'),
  (10, 3, '2025-09-05 20:00', 'ouvinte'),
  (16, 3, '2025-09-06 05:45', 'ouvinte'),
  (3, 3, '2025-09-06 19:45', 'ouvinte'),
  (2, 3, '2025-09-07 23:00', 'ouvinte'),
  (20, 3, '2025-09-08 00:15', 'ouvinte'),
  (15, 3, '2025-09-08 04:45', 'ouvinte'),
  (1, 3, '2025-09-08 23:15', 'ouvinte'),
  (18, 4, '2025-09-10 23:15', 'ouvinte'),
  (8, 4, '2025-09-11 00:45', 'ouvinte'),
  (12, 2, '2025-09-11 03:30', 'ouvinte'),
  (18, 3, '2025-09-11 23:45', 'ouvinte'),
  (69, 15, '2026-08-29 01:45', 'ouvinte'),
  (65, 16, '2026-08-29 05:30', 'ouvinte'),
  (71, 16, '2026-08-30 20:00', 'ouvinte'),
  (74, 14, '2026-08-31 01:30', 'ouvinte'),
  (62, 16, '2026-08-31 05:45', 'ouvinte'),
  (63, 16, '2026-09-03 03:15', 'ouvinte'),
  (73, 15, '2026-09-03 05:15', 'ouvinte'),
  (67, 15, '2026-09-03 22:00', 'ouvinte'),
  (60, 14, '2026-09-06 06:45', 'ouvinte'),
  (72, 15, '2026-09-08 06:30', 'ouvinte'),
  (79, 16, '2026-09-08 23:15', 'ouvinte'),
  (75, 15, '2026-09-10 04:15', 'ouvinte'),
  (59, 15, '2026-09-11 05:15', 'ouvinte'),
  (64, 16, '2026-09-11 21:00', 'ouvinte'),
  (72, 16, '2026-09-12 19:30', 'ouvinte'),
  (73, 16, '2026-09-13 02:00', 'ouvinte'),
  (79, 15, '2026-09-15 01:15', 'ouvinte'),
  (63, 14, '2026-09-15 03:45', 'ouvinte'),
  (74, 16, '2026-09-15 19:15', 'ouvinte'),
  (75, 16, '2026-09-15 20:30', 'instrutor'),
  (69, 14, '2026-09-16 00:15', 'ouvinte'),
  (61, 16, '2026-09-16 02:00', 'ouvinte'),
  (71, 15, '2026-09-16 19:30', 'ouvinte'),
  (63, 15, '2026-09-18 01:45', 'ouvinte'),
  (73, 14, '2026-09-18 20:30', 'instrutor'),
  (80, 16, '2026-09-19 03:30', 'ouvinte'),
  (80, 15, '2026-09-20 03:45', 'ouvinte'),
  (66, 14, '2026-09-21 00:00', 'ouvinte'),
  (77, 16, '2026-09-22 02:00', 'ouvinte'),
  (76, 15, '2026-09-22 03:15', 'ouvinte'),
  (76, 16, '2026-09-22 22:30', 'ouvinte'),
  (75, 13, '2026-09-24 04:30', 'palestrante'),
  (65, 15, '2026-09-25 04:30', 'ouvinte'),
  (68, 16, '2026-09-25 20:30', 'ouvinte'),
  (67, 16, '2026-09-25 21:00', 'ouvinte'),
  (65, 14, '2026-09-26 03:15', 'ouvinte'),
  (61, 15, '2026-09-26 04:00', 'ouvinte'),
  (64, 15, '2026-09-26 07:15', 'ouvinte'),
  (79, 14, '2026-09-27 03:15', 'ouvinte'),
  (59, 14, '2026-09-27 04:30', 'ouvinte'),
  (59, 16, '2026-09-27 22:00', 'ouvinte'),
  (74, 15, '2026-09-28 01:15', 'ouvinte'),
  (68, 14, '2026-09-29 00:30', 'ouvinte'),
  (49, 7, '2026-09-29 21:45', 'ouvinte'),
  (68, 15, '2026-09-29 22:00', 'ouvinte'),
  (34, 10, '2026-09-30 05:00', 'ouvinte'),
  (76, 14, '2026-09-30 06:30', 'ouvinte'),
  (77, 14, '2026-10-01 03:45', 'ouvinte'),
  (36, 8, '2026-10-01 05:15', 'ouvinte'),
  (61, 14, '2026-10-01 21:30', 'ouvinte'),
  (62, 15, '2026-10-02 01:15', 'instrutor'),
  (53, 10, '2026-10-02 01:30', 'ouvinte'),
  (31, 7, '2026-10-02 02:30', 'ouvinte'),
  (64, 14, '2026-10-02 02:45', 'ouvinte'),
  (60, 16, '2026-10-02 21:30', 'ouvinte'),
  (54, 10, '2026-10-02 22:30', 'ouvinte'),
  (55, 8, '2026-10-03 03:15', 'ouvinte'),
  (53, 7, '2026-10-03 06:45', 'ouvinte'),
  (41, 6, '2026-10-04 02:45', 'palestrante'),
  (51, 7, '2026-10-04 19:45', 'ouvinte'),
  (50, 12, '2026-10-04 22:45', 'ouvinte'),
  (39, 10, '2026-10-05 00:30', 'ouvinte'),
  (109, 17, '2026-10-05 20:45', 'palestrante'),
  (53, 8, '2026-10-06 02:30', 'ouvinte'),
  (38, 7, '2026-10-06 21:15', 'ouvinte'),
  (52, 7, '2026-10-07 20:45', 'ouvinte'),
  (32, 12, '2026-10-08 00:45', 'instrutor'),
  (55, 9, '2026-10-08 21:15', 'ouvinte'),
  (51, 10, '2026-10-08 22:15', 'ouvinte'),
  (30, 7, '2026-10-08 23:00', 'ouvinte'),
  (38, 9, '2026-10-09 02:00', 'ouvinte'),
  (56, 9, '2026-10-09 06:15', 'ouvinte'),
  (32, 10, '2026-10-09 08:00', 'ouvinte'),
  (35, 7, '2026-10-09 20:00', 'ouvinte'),
  (44, 7, '2026-10-09 20:30', 'ouvinte'),
  (41, 10, '2026-10-09 22:30', 'ouvinte'),
  (27, 7, '2026-10-09 23:00', 'ouvinte'),
  (44, 9, '2026-10-10 00:30', 'ouvinte'),
  (35, 9, '2026-10-10 01:00', 'ouvinte'),
  (95, 19, '2026-10-10 02:15', 'palestrante'),
  (29, 10, '2026-10-11 20:30', 'ouvinte'),
  (44, 10, '2026-10-12 04:00', 'ouvinte'),
  (54, 11, '2026-10-12 05:00', 'palestrante'),
  (87, 18, '2026-10-13 08:45', 'palestrante'),
  (38, 10, '2026-10-13 20:30', 'ouvinte'),
  (31, 8, '2026-10-13 21:15', 'ouvinte'),
  (120, 22, '2026-10-13 21:30', 'instrutor'),
  (52, 8, '2026-10-13 22:30', 'ouvinte'),
  (54, 8, '2026-10-13 23:45', 'ouvinte'),
  (29, 7, '2026-10-14 03:15', 'ouvinte'),
  (50, 7, '2026-10-14 04:30', 'ouvinte'),
  (111, 22, '2026-10-15 02:15', 'ouvinte'),
  (56, 8, '2026-10-15 21:00', 'ouvinte'),
  (54, 7, '2026-10-16 06:45', 'instrutor'),
  (122, 21, '2026-10-16 07:45', 'ouvinte'),
  (51, 9, '2026-10-16 22:45', 'ouvinte'),
  (57, 10, '2026-10-17 01:15', 'ouvinte'),
  (50, 10, '2026-10-17 21:00', 'ouvinte'),
  (40, 7, '2026-10-18 05:15', 'ouvinte'),
  (114, 22, '2026-10-18 08:00', 'ouvinte'),
  (115, 21, '2026-10-18 19:45', 'ouvinte'),
  (121, 22, '2026-10-18 19:45', 'ouvinte'),
  (36, 7, '2026-10-18 21:00', 'ouvinte'),
  (48, 8, '2026-10-19 05:15', 'ouvinte'),
  (35, 12, '2026-10-19 20:00', 'ouvinte'),
  (123, 20, '2026-10-20 02:00', 'ouvinte'),
  (40, 11, '2026-10-20 06:00', 'palestrante'),
  (58, 12, '2026-10-20 08:00', 'ouvinte'),
  (54, 12, '2026-10-20 20:15', 'ouvinte'),
  (31, 10, '2026-10-21 19:15', 'ouvinte'),
  (41, 7, '2026-10-22 00:15', 'ouvinte'),
  (51, 8, '2026-10-22 02:15', 'instrutor'),
  (56, 10, '2026-10-22 04:00', 'ouvinte'),
  (45, 7, '2026-10-22 05:00', 'ouvinte'),
  (46, 7, '2026-10-22 21:15', 'ouvinte'),
  (29, 8, '2026-10-22 23:15', 'ouvinte'),
  (52, 9, '2026-10-23 05:15', 'ouvinte'),
  (44, 8, '2026-10-23 20:30', 'ouvinte'),
  (49, 10, '2026-10-23 20:45', 'instrutor'),
  (55, 10, '2026-10-24 20:15', 'ouvinte'),
  (45, 12, '2026-10-25 02:45', 'ouvinte'),
  (31, 9, '2026-10-25 19:15', 'ouvinte'),
  (45, 10, '2026-10-25 22:30', 'ouvinte'),
  (39, 12, '2026-10-26 00:15', 'ouvinte'),
  (120, 21, '2026-10-26 19:45', 'ouvinte'),
  (46, 8, '2026-10-26 23:30', 'ouvinte'),
  (125, 20, '2026-10-27 00:30', 'ouvinte'),
  (54, 9, '2026-10-27 02:00', 'ouvinte'),
  (32, 7, '2026-10-27 22:15', 'ouvinte'),
  (48, 10, '2026-10-28 02:30', 'ouvinte'),
  (114, 20, '2026-10-29 00:00', 'ouvinte'),
  (58, 7, '2026-10-29 01:30', 'ouvinte'),
  (42, 7, '2026-10-29 02:00', 'ouvinte'),
  (55, 12, '2026-10-30 01:45', 'ouvinte'),
  (53, 9, '2026-10-30 07:00', 'ouvinte'),
  (123, 22, '2026-10-31 05:15', 'ouvinte'),
  (39, 9, '2026-10-31 06:30', 'ouvinte'),
  (56, 7, '2026-10-31 06:45', 'ouvinte'),
  (48, 9, '2026-10-31 22:00', 'ouvinte'),
  (28, 10, '2026-11-01 02:15', 'ouvinte'),
  (118, 20, '2026-11-01 03:30', 'ouvinte'),
  (28, 7, '2026-11-01 04:30', 'ouvinte'),
  (35, 8, '2026-11-01 04:45', 'ouvinte'),
  (117, 22, '2026-11-01 06:15', 'ouvinte'),
  (50, 9, '2026-11-01 07:15', 'ouvinte'),
  (34, 7, '2026-11-01 21:00', 'ouvinte'),
  (36, 9, '2026-11-02 19:30', 'instrutor'),
  (126, 20, '2026-11-03 01:00', 'ouvinte'),
  (36, 12, '2026-11-03 02:15', 'ouvinte'),
  (46, 11, '2026-11-03 07:00', 'palestrante'),
  (46, 12, '2026-11-03 07:30', 'ouvinte'),
  (42, 8, '2026-11-03 22:30', 'ouvinte'),
  (121, 21, '2026-11-04 06:15', 'ouvinte'),
  (58, 8, '2026-11-04 19:30', 'ouvinte'),
  (40, 8, '2026-11-04 20:45', 'ouvinte'),
  (57, 7, '2026-11-06 00:30', 'ouvinte'),
  (48, 7, '2026-11-06 02:45', 'ouvinte'),
  (58, 10, '2026-11-06 19:30', 'ouvinte'),
  (113, 21, '2026-11-06 20:15', 'ouvinte'),
  (55, 7, '2026-11-06 22:30', 'ouvinte'),
  (28, 8, '2026-11-07 01:15', 'ouvinte'),
  (39, 7, '2026-11-07 02:00', 'ouvinte'),
  (27, 10, '2026-11-07 02:15', 'ouvinte'),
  (112, 22, '2026-11-07 04:45', 'ouvinte'),
  (115, 20, '2026-11-07 23:00', 'instrutor'),
  (125, 22, '2026-11-08 21:15', 'ouvinte'),
  (117, 20, '2026-11-09 01:00', 'ouvinte'),
  (126, 21, '2026-11-09 04:00', 'instrutor'),
  (119, 21, '2026-11-11 01:30', 'ouvinte'),
  (121, 20, '2026-11-12 23:00', 'ouvinte'),
  (116, 20, '2026-11-13 01:00', 'ouvinte'),
  (116, 22, '2026-11-13 23:15', 'ouvinte'),
  (119, 22, '2026-11-19 02:00', 'ouvinte'),
  (118, 21, '2026-11-20 23:45', 'ouvinte'),
  (118, 22, '2026-11-21 04:00', 'ouvinte'),
  (129, 23, '2026-11-25 07:00', 'palestrante');

 -- ============================================================
-- SCC0640 - Sistema de Gestao de Eventos e Espacos
-- 05_DML_casos_triggers.sql
 -- ============================================================

-- ============================================================
-- 1. DADOS BASE (todos validos)
-- ============================================================

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

-- ------------------------------------------------------------
-- Em cada inserção, estamos definindo o id da tupla
-- Então precisamos justar as sequencias IDENTITY para o maior id inserido
-- (sem isso, o proximo INSERT sem id tentaria usar o id 1 e falharia)
-- ------------------------------------------------------------
SELECT setval(pg_get_serial_sequence('promotor', 'promotorid'), (SELECT MAX(promotorid) FROM promotor));
SELECT setval(pg_get_serial_sequence('evento', 'eventoid'), (SELECT MAX(eventoid) FROM evento));
SELECT setval(pg_get_serial_sequence('atividade', 'atividadeid'), (SELECT MAX(atividadeid) FROM atividade));
SELECT setval(pg_get_serial_sequence('espaco', 'espacoid'), (SELECT MAX(espacoid) FROM espaco));
SELECT setval(pg_get_serial_sequence('sessao', 'sessaoid'), (SELECT MAX(sessaoid) FROM sessao));
SELECT setval(pg_get_serial_sequence('recursos', 'recursoid'), (SELECT MAX(recursoid) FROM recursos));
SELECT setval(pg_get_serial_sequence('estoque', 'estoqueid'), (SELECT MAX(estoqueid) FROM estoque));
SELECT setval(pg_get_serial_sequence('recursos_sessao', 'recursosessaoid'), (SELECT MAX(recursosessaoid) FROM recursos_sessao));
SELECT setval(pg_get_serial_sequence('participante', 'participanteid'), (SELECT MAX(participanteid) FROM participante));
SELECT setval(pg_get_serial_sequence('credenciamento', 'credenciamentoid'), (SELECT MAX(credenciamentoid) FROM credenciamento));
SELECT setval(pg_get_serial_sequence('inscricao', 'inscricaoid'), (SELECT MAX(inscricaoid) FROM inscricao));

COMMIT;