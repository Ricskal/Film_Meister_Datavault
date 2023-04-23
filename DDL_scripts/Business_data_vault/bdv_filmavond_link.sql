    CREATE VIEW IF NOT EXISTS bdv_filmavond_link as
       select
              rfl.Filmavond_Link_Key
            , rfl.Film_Hub_Key
            , rfl.Meister_Hub_Key
            , strftime('%Y%m%d', rfl.Datum_Filmavond_BK) as Datum_Filmavond_Key
       from rdv_filmavond_link rfl;