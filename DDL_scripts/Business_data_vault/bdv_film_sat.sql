    CREATE VIEW IF NOT EXISTS bdv_film_sat as
        select
              rfs.Film_Hub_Key
            , rfs.Film_Title
            , rfs.Film_Jaar
            , rfs.Film_Genres
            , rfs.Film_Tijdsduur_min
            , rfs.Genres_weging
            , rfs.Film_tags
            , rfs.Film_IMDB_Score
        from rdv_film_sat rfs
        where rfs.Is_Current = 1
        ;

