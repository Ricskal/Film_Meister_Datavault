    CREATE VIEW IF NOT EXISTS stg_excelsheet_vw AS
        SELECT
             xls."Nr." AS Aantal_Films
            ,xls."Jaar" AS Aantal_Jaar
            ,xls."Rnd"  AS Aantal_Ronde
            ,xls."Datum" AS Datum_Filmavond
            ,xls."Meister" AS Meister
            ,xls."TT_Code" AS TT_Code
            ,xls."Film" AS Film_Title
            ,xls."Jaar2" AS Film_Jaar
            ,xls."Genres" AS Film_Genres
            ,xls."Tijdsduur in min" AS Film_Tijdsduur_min
            ,xls."Al gezien?" AS Ind_Gezien
            ,xls."Weging" AS Genres_weging
            ,xls."Tags" AS Film_tags
            ,xls."Score" AS Film_IMDB_Score
            ,xls."Dag" AS Film_weekdag
        FROM
            'stg_excelsheet' xls
        ;