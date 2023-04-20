    CREATE VIEW IF NOT EXISTS bdv_film_hub as
		select
			  rfh.Film_Hub_Key
			, rfh.TT_Code_BK
			, rfh.Laaddatum
		from rdv_film_hub rfh
        ;