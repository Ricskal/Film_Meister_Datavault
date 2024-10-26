CREATE OR REPLACE PROCEDURE stg.load_links()
LANGUAGE plpgsql
AS $$
BEGIN
	/* load from stg.filmavondsheet to rdv.filmavond_link */
	insert into rdv.filmavond_link (
	      Film_Hub_Key
	    , Meister_Hub_Key
	    , Datum_Filmavond_BK
	    , Laaddatum
	    )
	select distinct
	      rfh.Film_Hub_Key
	    , rmh.Meister_Hub_Key
	    , coalesce(sfs.Datum_Filmavond, to_timestamp('1900-01-01', 'yyyy-mm-dd')) as Datum_Filmavond
	    , cast(now() as timestamp) as Laaddatum
	from stg.filmavondsheet sfs
	left join rdv.film_hub rfh
	    on upper(trim(coalesce(sfs.TT_Code, 'Onbekend'))) = rfh.TT_Code_BK
	left join rdv.meister_hub rmh
	    on upper(trim(coalesce(sfs.Meister, 'Onbekend'))) = rmh.Meister_BK
	left join rdv.filmavond_link rfl
	    on rfh.Film_Hub_Key = rfl.Film_Hub_Key
	        and rmh.Meister_Hub_Key = rfl.Meister_Hub_Key
	        and coalesce(sfs.Datum_Filmavond, to_timestamp('1900-01-01', 'yyyy-mm-dd')) = rfl.Datum_Filmavond_BK
	where rfl.Filmavond_Link_Key is null;
END;
$$;