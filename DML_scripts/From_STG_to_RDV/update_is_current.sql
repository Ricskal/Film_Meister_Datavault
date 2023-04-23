/* Update the Is_Current field in rdv_film_sat */
    UPDATE rdv_film_sat
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
            FROM rdv_film_sat rfs
        ) x
        WHERE x.rn <> 1
    );

/* Update the Is_Current field in rdv_filmavond_sat */
    UPDATE rdv_film_sat
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
            FROM rdv_film_sat rfs
        ) x
        WHERE x.rn <> 1
    );