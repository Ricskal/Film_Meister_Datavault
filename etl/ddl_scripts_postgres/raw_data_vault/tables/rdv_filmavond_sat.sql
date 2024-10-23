CREATE TABLE IF NOT EXISTS rdv.filmavond_sat (
      Filmavond_Link_Key INTEGER NOT NULL
    , Film_weekdag VARCHAR NULL
    , Ind_Gezien VARCHAR NULL
    , Aantal_Films INTEGER NULL
    , Aantal_Jaar INTEGER NULL
    , Aantal_Ronde INTEGER NULL
    , Laaddatum TIMESTAMP NOT NULL
    , Is_Current INTEGER NOT NULL 
    , PRIMARY KEY(Filmavond_Link_Key, Laaddatum)
);