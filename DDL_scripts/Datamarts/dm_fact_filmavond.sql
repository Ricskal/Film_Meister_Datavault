CREATE VIEW IF NOT EXISTS dm_fact_filmavond as
    select
          bfl.Filmavond_Link_Key as Fact_Filmavond_key
        , bfl.Film_Hub_Key as Dim_Film_key
        , bfl.Meister_Hub_Key as Dim_Meister_key
        , bfl.Datum_Filmavond_Key as Dim_Filmavond_Datum_key
        , 1 as Aantal_Films
        , bfs.Ind_Gezien as Film_Al_Gezien
        , bfs.Aantal_Jaar as Aantal_Jaar_Filmavond
        , bfs.Aantal_Ronde as Aantal_Ronde_Filmavond
    from bdv_filmavond_link bfl
    join bdv_filmavond_sat bfs
        on bfl.Filmavond_Link_Key = bfs.Filmavond_Link_Key;