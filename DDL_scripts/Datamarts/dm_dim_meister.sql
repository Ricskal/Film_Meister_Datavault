CREATE VIEW IF NOT EXISTS dm_dim_meister as
    select
	   bmh.Meister_Hub_Key as Dim_Meister_Key
	 , bmh.Film_Meister
    from bdv_meister_hub bmh;