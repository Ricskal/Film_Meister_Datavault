CREATE VIEW IF NOT EXISTS dm_dim_film as
    select
		  bfh.Film_Hub_Key
		, bfh.IMDb_code
		, bfs.Film_Title
		, bfs.Film_Jaar
		, bfs.Film_Tijdsduur_min
		, bfs.Film_IMDB_Score
		, bfs.Genre_Weging
    from bdv_film_hub bfh
    join bdv_film_sat bfs
    	on bfh.Film_Hub_Key = bfs.Film_Hub_Key;