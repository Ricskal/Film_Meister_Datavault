CREATE OR REPLACE VIEW dm.dim_film_genre AS
	SELECT
		  bfgl.Film_Hub_Key as Dim_Film_Key
		, bghl.Genre 
	FROM bdv.film_genre_link bfgl 
	INNER JOIN bdv.genre_hub bghl
		ON bfgl.Genre_Hub_Key = bghl.Genre_Hub_Key;