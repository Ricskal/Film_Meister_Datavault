    CREATE VIEW IF NOT EXISTS bdv_film_hub AS
		SELECT
			  rfh.Film_Hub_Key
			, rfh.TT_Code_BK AS IMDb_code
		FROM rdv_film_hub rfh
        ;