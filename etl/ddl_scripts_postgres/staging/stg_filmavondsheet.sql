CREATE TABLE IF NOT EXISTS stg.filmavondsheet (
      Aantal_Films INTEGER NULL
    , Aantal_Jaar INTEGER NULL
    , Aantal_Ronde INTEGER NULL
    , Datum_Filmavond TIMESTAMP NULL
    , Meister VARCHAR NULL
    , TT_Code VARCHAR NULL
    , Film_Title VARCHAR NULL
    , Film_Jaar INTEGER NULL
    , Film_Genres VARCHAR NULL
    , Film_Tijdsduur_min INTEGER NULL
    , Ind_Gezien VARCHAR NULL
    , Genres_weging REAL NULL
    , Film_tags VARCHAR NULL
    , Film_IMDB_Score NUMERIC(3,1) NULL
    , Film_weekdag VARCHAR NULL
);