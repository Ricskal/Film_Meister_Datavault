CREATE TABLE IF NOT EXISTS rdv.film_sat (
      Film_Hub_Key INTEGER NOT NULL
    , Film_Title VARCHAR NOT NULL
    , Film_Jaar INTEGER NOT NULL
    , Film_Genres VARCHAR NOT NULL
    , Film_Tijdsduur_min INTEGER NOT NULL
    , Genres_weging REAL NOT NULL
    , Film_tags VARCHAR NULL
    , Film_IMDB_Score REAL NOT NULL
    , Laaddatum TIMESTAMP NOT NULL
    , Is_Current INTEGER NOT NULL
    , PRIMARY KEY(Film_Hub_Key, Laaddatum)
);