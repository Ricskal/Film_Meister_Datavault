
        CREATE TABLE IF NOT EXISTS rdv.filmavond_link
        (
              Filmavond_Link_Key SERIAL PRIMARY KEY
            , Film_Hub_Key INTEGER
            , Meister_Hub_Key INTEGER
            , Datum_Filmavond_BK VARCHAR
            , Laaddatum VARCHAR
        );