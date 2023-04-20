    CREATE VIEW IF NOT EXISTS bdv_filmavond_sat as
        select
              rfs.Filmavond_Link_Key
            , rfs.Film_weekdag
            , rfs.Ind_Gezien
            , rfs.Aantal_Films
            , rfs.Aantal_Jaar
            , rfs.Aantal_Ronde
        from rdv_filmavond_sat rfs
        where rfs.Is_Current = 1
        ;