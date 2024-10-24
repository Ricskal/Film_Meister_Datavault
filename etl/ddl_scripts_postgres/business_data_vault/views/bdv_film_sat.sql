CREATE OR REPLACE VIEW bdv.film_sat as
    WITH GenreCounts AS (
        SELECT
              bfgl.Film_Hub_Key
            , COUNT(bfgl.Film_Genre_Link_Key) AS Genre_Count
        FROM bdv.film_genre_link bfgl
        GROUP BY bfgl.Film_Hub_Key
    )
        SELECT
              rfs.Film_Hub_Key
            , rfs.Film_Title
            , rfs.Film_Jaar
            , rfs.Film_Tijdsduur_min
            , COALESCE(rfs.Film_IMDB_Score, -1) AS Film_IMDB_Score
            , CAST(1 AS REAL) / gc.Genre_Count AS Genre_Weging
        FROM rdv.film_sat rfs
        LEFT JOIN GenreCounts gc
            ON rfs.Film_Hub_Key = gc.Film_Hub_Key
        WHERE rfs.Is_Current = 1
;