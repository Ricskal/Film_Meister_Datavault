CREATE OR REPLACE PROCEDURE stg.update_is_current()
LANGUAGE plpgsql
AS $$
BEGIN
	/* Update the Is_Current field in rdv.film_sat */
	UPDATE rdv.film_sat
	SET Is_Current = 0
	WHERE (Film_Hub_Key, Laaddatum) IN (
	    SELECT
	          x.Film_Hub_Key
	        , x.Laaddatum
	    FROM (
	        SELECT
	              rfs.Film_Hub_Key
	            , rfs.Laaddatum
	            , row_number() OVER
	                (PARTITION BY rfs.Film_Hub_Key
	                ORDER BY rfs.Laaddatum DESC) AS rn
	        FROM rdv.film_sat rfs
	    ) x
	    WHERE x.rn <> 1
	);
	
	/* Update the Is_Current field in rdv.filmavond_sat */
	UPDATE rdv.filmavond_sat
	SET Is_Current = 0
	WHERE (Filmavond_Link_Key, Laaddatum) IN (
	    SELECT
	          x.Filmavond_Link_Key
	        , x.Laaddatum
	    FROM (
	        SELECT
	              rfs.Filmavond_Link_Key
	            , rfs.Laaddatum
	            , row_number() OVER
	                (PARTITION BY rfs.Filmavond_Link_Key
	                ORDER BY rfs.Laaddatum DESC) AS rn
	        FROM rdv.filmavond_sat rfs
	    ) x
	    WHERE x.rn <> 1
	);
END;
$$;
