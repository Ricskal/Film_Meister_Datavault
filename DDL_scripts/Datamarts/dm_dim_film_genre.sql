CREATE VIEW IF NOT EXISTS dm_dim_film_genre AS
	SELECT
		  bfgl.Film_Hub_Key as Dim_Film_Key
		, bghl.Genre 
	FROM bdv_film_genre_link bfgl 
	INNER JOIN bdv_genre_hub bghl
		ON bfgl.Genre_Hub_Key = bghl.Genre_Hub_Key;