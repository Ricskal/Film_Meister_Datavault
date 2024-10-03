CREATE OR REPLACE VIEW bdv.film_hub AS
	SELECT
		  rfh.Film_Hub_Key
		, rfh.TT_Code_BK AS IMDb_code
	FROM rdv.film_hub rfh
;