CREATE VIEW IF NOT EXISTS dm_fact_filmavond AS
    SELECT
          bfl.Filmavond_Link_Key AS Fact_Filmavond_key
        , bfl.Film_Hub_Key AS Dim_Film_key
        , bfl.Meister_Hub_Key AS Dim_Meister_key
        , bfl.Datum_Filmavond_Key AS Dim_Filmavond_Datum_key
        , CAST('1' AS INTEGER) AS Aantal_Films
        , bfs.Ind_Gezien AS Film_Al_Gezien
        , bfs.Aantal_Jaar AS Aantal_Jaar_Filmavond
        , bfs.Aantal_Ronde AS Aantal_Ronde_Filmavond
    FROM bdv_filmavond_link bfl
    JOIN bdv_filmavond_sat bfs
        ON bfl.Filmavond_Link_Key = bfs.Filmavond_Link_Key;