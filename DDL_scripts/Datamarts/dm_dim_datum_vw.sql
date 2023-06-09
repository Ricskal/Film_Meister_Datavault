CREATE VIEW IF NOT EXISTS dm_dim_datum_vw AS
    WITH cte_min_max_datum AS (
        SELECT
              MIN(Dim_Filmavond_Datum_key) AS Eerste_Filmavond_key
            , MAX(Dim_Filmavond_Datum_key) AS Laatste_Filmavond_key
        FROM dm_fact_filmavond
    )
        SELECT
              ddd.Dim_Datum_Key
            , ddd.Datum
            , ddd.DagNummer
            , ddd.Dag
            , ddd.DagAfkorting
            , ddd.DagVanDeMaand
            , ddd.MaandNummer
            , ddd.Jaar
            , ddd.IsWeekend
            , ddd.IsWeekdag
            , ddd.Maand
            , ddd.IsFeestdag
            , ddd.Toelichting
        FROM dm_dim_datum ddd
        JOIN cte_min_max_datum cmmd ON TRUE
        WHERE ddd.Dim_Datum_Key >= cmmd.Eerste_Filmavond_key
        AND ddd.Dim_Datum_Key <= cmmd.Laatste_Filmavond_key;