
        CREATE TABLE IF NOT EXISTS rdv_filmavond_link
        (
              Filmavond_Link_Key INTEGER PRIMARY KEY
            , Film_Hub_Key INTEGER
            , Meister_Hub_Key INTEGER
            , Datum_Filmavond_BK TEXT
            , Laaddatum TEXT
        );