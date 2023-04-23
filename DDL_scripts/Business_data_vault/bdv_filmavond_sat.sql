    CREATE VIEW IF NOT EXISTS bdv_filmavond_sat AS
        SELECT
              rfs.Filmavond_Link_Key
            , rfs.Ind_Gezien
            , rfs.Aantal_Jaar
            , rfs.Aantal_Ronde
        FROM rdv_filmavond_sat rfs
        WHERE rfs.Is_Current = 1
        ;