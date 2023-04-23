    CREATE VIEW IF NOT EXISTS bdv_filmavond_link AS
       SELECT
              rfl.Filmavond_Link_Key
            , rfl.Film_Hub_Key
            , rfl.Meister_Hub_Key
            , strftime('%Y%m%d', rfl.Datum_Filmavond_BK) AS Datum_Filmavond_Key
       FROM rdv_filmavond_link rfl;