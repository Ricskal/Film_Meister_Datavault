    CREATE VIEW IF NOT EXISTS stg_excelsheet_vw as
        select
             xls."Nr." as Aantal_Films
            ,xls."Jaar" as Aantal_Jaar
            ,xls."Rnd"  as Aantal_Ronde
            ,xls."Datum" as Datum_Filmavond
            ,xls."Meister" as Meister
            ,xls."TT_Code" as TT_Code
            ,xls."Film" as Film_Title
            ,xls."Jaar2" as Film_Jaar
            ,xls."Genres" as Film_Genres
            ,xls."Tijdsduur in min" as Film_Tijdsduur_min
            ,xls."Al gezien?" as Ind_Gezien
            ,xls."Weging" as Genres_weging
            ,xls."Tags" as Film_tags
            ,xls."Score" as Film_IMDB_Score
            ,xls."Dag" as Film_weekdag
        FROM
            'stg_excelsheet' xls
        ;