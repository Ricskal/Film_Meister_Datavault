
    /* load from stg_excelsheet_vw to rdv_film_hub */
    insert into rdv_film_hub (
          TT_Code_BK
        , Laaddatum
        )
    select distinct
          coalesce(stg.TT_Code, 'Onbekend') as TT_Code
        , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
    from stg_excelsheet_vw stg
    left join rdv_film_hub rfh
        on coalesce(stg.TT_Code, 'Onbekend') = rfh.TT_Code_BK
    where rfh.Film_Hub_Key is null
    ;


     /* load from stg_excelsheet_vw to rdv_meister_hub */
     insert into rdv_meister_hub (
          Meister_BK
        , Laaddatum
        )
    select distinct
          coalesce(stg.Meister, 'Onbekend') as Meister
        , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
    from stg_excelsheet_vw stg
    left join rdv_meister_hub rmh
        on coalesce(stg.Meister, 'Onbekend') = rmh.Meister_BK
    where rmh.Meister_Hub_Key is null
    ;
