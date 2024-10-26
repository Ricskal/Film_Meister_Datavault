CREATE OR REPLACE PROCEDURE stg.load_hubs()
LANGUAGE plpgsql
AS $$
BEGIN
  /* load from stg.filmavondsheet to rdv.film_hub */
  insert into rdv.film_hub (
      TT_Code_BK
    , Laaddatum
  )
  select distinct
      upper(trim(coalesce(stg.TT_Code, 'Onbekend'))) as TT_Code
    , cast(now() as timestamp) as Laaddatum
  from stg.filmavondsheet stg
  left join rdv.film_hub rfh
    on upper(trim(coalesce(stg.TT_Code, 'Onbekend'))) = rfh.TT_Code_BK
  where rfh.Film_Hub_Key is null
  ;

  /* load from stg.filmavondsheet to rdv.meister_hub */
  insert into rdv.meister_hub (
      Meister_BK
    , Laaddatum
  )
  select distinct
      upper(trim(coalesce(stg.Meister, 'Onbekend'))) as Meister
    , cast(now() as timestamp) as Laaddatum
  from stg.filmavondsheet stg
  left join rdv.meister_hub rmh
    on upper(trim(coalesce(stg.Meister, 'Onbekend'))) = rmh.Meister_BK
  where rmh.Meister_Hub_Key is null
  ;
END;
$$;
