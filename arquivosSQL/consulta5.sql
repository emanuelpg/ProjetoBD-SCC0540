SELECT s.Nome                                   AS sessao,
       esp.Nome                                 AS espaco,
       r.Nome                                   AS recurso,
       rs.QtdNecessaria                         AS necessario,
       COALESCE(e.Quantidade, 0)                AS em_estoque,
       COALESCE(e.Quantidade, 0) - rs.QtdNecessaria AS folga,
       SUM(rs.QtdNecessaria) OVER (PARTITION BY rs.RecursoId) AS demanda_total_do_recurso,
       CASE
           WHEN s.EspacoId IS NULL                       THEN 'Sessão sem espaço'
           WHEN COALESCE(e.Quantidade, 0) = 0            THEN 'Recurso ausente no espaço'
           WHEN e.Quantidade < rs.QtdNecessaria          THEN 'Insuficiente'
           WHEN e.Quantidade = rs.QtdNecessaria          THEN 'Justo'
           ELSE 'Folgado'
       END                                      AS situacao
  FROM recursos_sessao rs
  JOIN sessao s         ON s.SessaoId  = rs.SessaoId
  JOIN recursos r       ON r.RecursoId = rs.RecursoId
  LEFT JOIN espaco esp  ON esp.EspacoId = s.EspacoId
  LEFT JOIN estoque e   ON e.EspacoId  = s.EspacoId
                       AND e.RecursoId = rs.RecursoId
 ORDER BY situacao, s.Nome, r.Nome;