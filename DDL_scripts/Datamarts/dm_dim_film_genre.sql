CREATE VIEW IF NOT EXISTS dm_dim_film_genre AS
	select
		  bfgl.Film_Hub_Key as Dim_Film_Key
		, bghl.Genre 
	from bdv_film_genre_link bfgl 
	inner join bdv_genre_hub bghl
		on bfgl.Genre_Hub_Key  = bghl.Genre_Hub_Key;