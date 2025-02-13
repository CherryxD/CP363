USE League_Database;
SELECT t.short_name AS team,
       COUNT(CASE WHEN r.team1_score > r.team2_score AND t.short_name = m.team1 THEN 1 
                  WHEN r.team2_score > r.team1_score AND t.short_name = m.team2 THEN 1 
             END) AS wins,
       COUNT(CASE WHEN r.team1_score < r.team2_score AND t.short_name = m.team1 THEN 1 
                  WHEN r.team2_score < r.team1_score AND t.short_name = m.team2 THEN 1 
             END) AS losses,
       COUNT(CASE WHEN r.team1_score = r.team2_score THEN 1 AND m.team1 != NULL AND m.team2 != NULL END) AS draws
FROM Teams t
LEFT JOIN Matches m ON t.short_name IN (m.team1, m.team2)
LEFT JOIN Results r ON m.match_id = r.match_id
GROUP BY t.short_name
ORDER BY wins DESC;