/* load from stg_excelsheet_vw to rdv_film_sat */
insert into rdv_film_sat (
      Film_Hub_Key
    , Film_Title
    , Film_Jaar
    , Film_Genres
    , Film_Tijdsduur_min
    , Genres_weging
    , Film_tags
    , Film_IMDB_Score
    , Laaddatum
    , Is_Current
)
    with target_table as (
        select
            upper(trim(coalesce(rfs.Film_Title, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Film_Jaar, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Film_Genres, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Film_Tijdsduur_min, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Genres_weging, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Film_tags, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Film_IMDB_Score, '|'))) AS Target_Concact
            , rfh.Film_Hub_Key
            , case when rfs.Is_Current is null then 1 else rfs.Is_Current end as Is_Current
        FROM rdv_film_hub rfh
        left join rdv_film_sat rfs
            on rfh.Film_Hub_Key = rfs.Film_Hub_Key
    ),
    source_table as (
        select
            upper(trim(coalesce(sev.Film_Title, '|'))) || '|' ||
            upper(trim(coalesce(sev.Film_Jaar, '|'))) || '|' ||
            upper(trim(coalesce(sev.Film_Genres, '|'))) || '|' ||
            upper(trim(coalesce(sev.Film_Tijdsduur_min, '|'))) || '|' ||
            upper(trim(coalesce(sev.Genres_weging, '|'))) || '|' ||
            upper(trim(coalesce(sev.Film_tags, '|'))) || '|' ||
            upper(trim(coalesce(sev.Film_IMDB_Score, '|'))) AS Source_Concact
            , rfh.Film_Hub_Key
            , sev.Film_Title
            , sev.Film_Jaar
            , sev.Film_Genres
            , sev.Film_Tijdsduur_min
            , sev.Genres_weging
            , sev.Film_tags
            , sev.Film_IMDB_Score
        from rdv_film_hub rfh
        left join stg_excelsheet_vw sev
            on rfh.TT_Code_BK = upper(trim(coalesce(sev.TT_Code, 'Onbekend')))
    )
    select distinct
      st.Film_Hub_Key
    , st.Film_Title
    , st.Film_Jaar
    , st.Film_Genres
    , st.Film_Tijdsduur_min
    , st.Genres_weging
    , st.Film_tags
    , st.Film_IMDB_Score
    , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
    , 1 as Is_Current
    from source_table st
    join target_table tt
        on st.Film_Hub_Key = tt.Film_Hub_Key
    where st.Source_Concact <> tt.Target_Concact
    and tt.Is_Current = 1
;

/* load from stg_excelsheet_vw to rdv_filmavond_sat */
insert into rdv_filmavond_sat (
 	  Filmavond_Link_Key
    , Film_weekdag
    , Ind_Gezien
    , Aantal_Films
    , Aantal_Jaar
    , Aantal_Ronde
    , Laaddatum
    , Is_Current
)
    with target_table as (
        select
            upper(trim(coalesce(rfs.Film_weekdag, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Ind_Gezien, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Aantal_Films, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Aantal_Jaar, '|'))) || '|' ||
            upper(trim(coalesce(rfs.Aantal_Ronde, '|'))) AS Target_Concact
        	, rfl.Filmavond_Link_Key
            , case when rfs.Is_Current is null then 1 else rfs.Is_Current end as Is_Current
        from rdv_filmavond_link rfl
        left join rdv_filmavond_sat rfs
            on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
    ),
    source_table as (
		select
		    upper(trim(coalesce(sev.Film_weekdag, '|'))) || '|' ||
		    upper(trim(coalesce(sev.Ind_Gezien, '|'))) || '|' ||
		    upper(trim(coalesce(sev.Aantal_Films, '|'))) || '|' ||
		    upper(trim(coalesce(sev.Aantal_Jaar, '|'))) || '|' ||
		    upper(trim(coalesce(sev.Aantal_Ronde, '|'))) AS Source_Concact
		    , rfl.Filmavond_Link_Key
			, sev.Film_weekdag
		    , sev.Ind_Gezien
		    , sev.Aantal_Films
		    , sev.Aantal_Jaar
		    , sev.Aantal_Ronde
	    from rdv_filmavond_link rfl
	    left join rdv_filmavond_sat rfs
	        on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
	    left join rdv_film_hub rfh
	    	on rfl.Film_Hub_Key = rfh.Film_Hub_Key
	    left join rdv_meister_hub rmh
	    	on rfl.Meister_Hub_Key = rmh.Meister_Hub_Key
	    left join stg_excelsheet_vw sev
	    	on upper(trim(coalesce(sev.TT_Code, 'Onbekend'))) = rfh.TT_Code_BK
	    	and upper(trim(coalesce(sev.Meister, 'Onbekend'))) = rmh.Meister_BK
    )
    select distinct
      st.Filmavond_Link_Key
    , st.Film_weekdag
    , st.Ind_Gezien
    , st.Aantal_Films
    , st.Aantal_Jaar
    , st.Aantal_Ronde
    , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
    , 1 as Is_Current
    from source_table st
    join target_table tt
        on st.Filmavond_Link_Key = tt.Filmavond_Link_Key
    where st.Source_Concact <> tt.Target_Concact
    and tt.Is_Current = 1
;
