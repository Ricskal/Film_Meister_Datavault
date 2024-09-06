/* load from stg_excelsheet_vw to rdv_filmavond_link */
insert into rdv_filmavond_link (
        Film_Hub_Key
    , Meister_Hub_Key
    , Datum_Filmavond_BK
    , Laaddatum
    )
select distinct
        rfh.Film_Hub_Key
    , rmh.Meister_Hub_Key
    , upper(trim(coalesce(sev.Datum_Filmavond, 'Onbekend'))) as Datum_Filmavond
    , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
from stg_excelsheet_vw sev
left join rdv_film_hub rfh
    on upper(trim(coalesce(sev.TT_Code, 'Onbekend'))) = rfh.TT_Code_BK
left join rdv_meister_hub rmh
    on upper(trim(coalesce(sev.Meister, 'Onbekend'))) = rmh.Meister_BK
left join rdv_filmavond_link rfl
    on rfh.Film_Hub_Key = rfl.Film_Hub_Key
        and rmh.Meister_Hub_Key = rfl.Meister_Hub_Key
        and upper(trim(coalesce(sev.Datum_Filmavond,'Onbekend'))) = rfl.Datum_Filmavond_BK
where rfl.Filmavond_Link_Key is null;