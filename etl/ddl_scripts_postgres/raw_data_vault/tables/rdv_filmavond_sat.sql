
        CREATE TABLE IF NOT EXISTS rdv.filmavond_sat
        (
              Filmavond_Link_Key INTEGER
            , Film_weekdag VARCHAR
            , Ind_Gezien VARCHAR
            , Aantal_Films INTEGER
            , Aantal_Jaar INTEGER
            , Aantal_Ronde INTEGER
            , Laaddatum VARCHAR
            , Is_Current INTEGER
            , PRIMARY KEY(Filmavond_Link_Key, Laaddatum)
        );