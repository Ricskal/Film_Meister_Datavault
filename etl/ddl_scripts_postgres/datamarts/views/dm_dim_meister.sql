CREATE OR REPLACE VIEW dm.dim_meister AS
    SELECT
          bmh.Meister_Hub_Key AS Dim_Meister_Key
        , INITCAP(lower(bmh.Film_Meister))
    FROM bdv.meister_hub bmh;