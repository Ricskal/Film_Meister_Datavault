CREATE OR REPLACE VIEW bdv.filmavond_link AS
    SELECT
          rfl.Filmavond_Link_Key
        , rfl.Film_Hub_Key
        , rfl.Meister_Hub_Key
        , to_char(rfl.Datum_Filmavond_BK, 'YYYYMMDD') AS Datum_Filmavond_Key
    FROM rdv.filmavond_link rfl
;