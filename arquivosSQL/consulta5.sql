-- Consulta 5: Demanda de recursos das sessões x estoque do espaço
SELECT s.Nome                                   AS sessao,
       esp.Nome                                 AS espaco,
       r.Nome                                   AS recurso,
       rs.QtdNecessaria                         AS necessario,
       -- NULL quando a sessão não tem espaço (não se aplica)
       CASE WHEN s.EspacoId IS NOT NULL
            THEN COALESCE(e.Quantidade, 0) END  AS em_estoque,
       CASE WHEN s.EspacoId IS NOT NULL
            THEN COALESCE(e.Quantidade, 0) - rs.QtdNecessaria END AS folga,
       SUM(rs.QtdNecessaria) OVER (PARTITION BY rs.RecursoId)     AS demanda_total_do_recurso,
       CASE
           WHEN s.EspacoId IS NULL              THEN 'Sessão sem espaço'
           WHEN e.Quantidade IS NULL            THEN 'Recurso ausente no espaço'
           WHEN e.Quantidade < rs.QtdNecessaria THEN 'Insuficiente'
           WHEN e.Quantidade = rs.QtdNecessaria THEN 'Justo'
           ELSE 'Folgado'
       END                                      AS situacao
  FROM recursos_sessao rs
  JOIN sessao s         ON s.SessaoId  = rs.SessaoId
  JOIN recursos r       ON r.RecursoId = rs.RecursoId
  LEFT JOIN espaco esp  ON esp.EspacoId = s.EspacoId
  LEFT JOIN estoque e   ON e.EspacoId  = s.EspacoId
                       AND e.RecursoId = rs.RecursoId
 ORDER BY CASE
              WHEN s.EspacoId IS NULL              THEN 1
              WHEN e.Quantidade IS NULL            THEN 2
              WHEN e.Quantidade < rs.QtdNecessaria THEN 3
              WHEN e.Quantidade = rs.QtdNecessaria THEN 4
              ELSE 5
          END,
          s.Nome, r.Nome;