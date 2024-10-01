CREATE VIEW IF NOT EXISTS dm_dim_film AS
    SELECT
		  bfh.Film_Hub_Key AS Dim_Film_Key
		, bfh.IMDb_code
		, bfs.Film_Title
		, bfs.Film_Jaar
		, bfs.Film_Tijdsduur_min
		, bfs.Film_IMDB_Score
		, bfs.Genre_Weging
    FROM bdv.film_hub bfh
    JOIN bdv.film_sat bfs
    	ON bfh.Film_Hub_Key = bfs.Film_Hub_Key;