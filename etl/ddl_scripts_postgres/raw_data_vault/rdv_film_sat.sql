    CREATE TABLE IF NOT EXISTS rdv.film_sat
        (
              Film_Hub_Key INTEGER
            , Film_Title VARCHAR
            , Film_Jaar INTEGER
            , Film_Genres VARCHAR
            , Film_Tijdsduur_min INTEGER
            , Genres_weging REAL
            , Film_tags VARCHAR
            , Film_IMDB_Score REAL
            , Laaddatum VARCHAR
            , Is_Current INTEGER
            , PRIMARY KEY(Film_Hub_Key, Laaddatum)
        );

