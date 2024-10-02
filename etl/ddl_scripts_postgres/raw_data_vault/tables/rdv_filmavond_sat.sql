CREATE TABLE IF NOT EXISTS rdv.filmavond_sat (
      Filmavond_Link_Key INTEGER NOT NULL
    , Film_weekdag VARCHAR NOT NULL
    , Ind_Gezien VARCHAR NOT NULL
    , Aantal_Films INTEGER NOT NULL
    , Aantal_Jaar INTEGER NOT NULL
    , Aantal_Ronde INTEGER NOT NULL
    , Laaddatum VARCHAR NOT NULL
    , Is_Current INTEGER NOT NULL 
    , PRIMARY KEY(Filmavond_Link_Key, Laaddatum)
);