    CREATE TABLE IF NOT EXISTS rdv_film_sat
        (
              Film_Hub_Key INTEGER
            , Film_Title TEXT
            , Film_Jaar REAL
            , Film_Genres TEXT
            , Film_Tijdsduur_min REAL
            , Genres_weging REAL
            , Film_tags TEXT
            , Film_IMDB_Score REAL
            , Laaddatum TEXT
            , Is_Current INTEGER
            , PRIMARY KEY(Film_Hub_Key, Laaddatum)
        );

