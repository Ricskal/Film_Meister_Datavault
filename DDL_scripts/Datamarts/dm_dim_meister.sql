CREATE VIEW IF NOT EXISTS dm_dim_meister AS
    SELECT
	   bmh.Meister_Hub_Key AS Dim_Meister_Key
	 , bmh.Film_Meister
    FROM bdv_meister_hub bmh;