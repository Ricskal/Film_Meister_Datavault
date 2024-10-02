
        CREATE TABLE IF NOT EXISTS rdv.filmavond_link
        (
              Filmavond_Link_Key SERIAL PRIMARY KEY
            , Film_Hub_Key INTEGER NOT NULL
            , Meister_Hub_Key INTEGER NOT NULL
            , Datum_Filmavond_BK VARCHAR NOT NULL
            , Laaddatum VARCHAR NOT NULL
        );