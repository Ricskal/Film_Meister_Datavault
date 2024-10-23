CREATE TABLE IF NOT EXISTS rdv.film_sat (
      Film_Hub_Key INTEGER NOT NULL
    , Film_Title VARCHAR NULL
    , Film_Jaar INTEGER NULL
    , Film_Genres VARCHAR NULL
    , Film_Tijdsduur_min INTEGER NULL
    , Genres_weging REAL NULL
    , Film_tags VARCHAR NULL
    , Film_IMDB_Score NUMERIC(3,1) NULL
    , Laaddatum TIMESTAMP NOT NULL
    , Is_Current INTEGER NOT NULL
    , PRIMARY KEY(Film_Hub_Key, Laaddatum)
);