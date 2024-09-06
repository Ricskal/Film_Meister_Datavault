
        CREATE TABLE IF NOT EXISTS rdv_filmavond_sat
        (
              Filmavond_Link_Key INTEGER
            , Film_weekdag TEXT
            , Ind_Gezien TEXT
            , Aantal_Films INTEGER
            , Aantal_Jaar INTEGER
            , Aantal_Ronde INTEGER
            , Laaddatum TEXT
            , Is_Current INTEGER
            , PRIMARY KEY(Filmavond_Link_Key, Laaddatum)
        );