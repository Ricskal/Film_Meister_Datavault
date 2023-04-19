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
)
    with target_table as (
        select
            COALESCE(rfs.Film_Title, '|') || '|' ||
            COALESCE(rfs.Film_Jaar, '|') || '|' ||
            COALESCE(rfs.Film_Genres, '|') || '|' ||
            COALESCE(rfs.Film_Tijdsduur_min, '|') || '|' ||
            COALESCE(rfs.Genres_weging, '|') || '|' ||
            COALESCE(rfs.Film_tags, '|') || '|' ||
            COALESCE(rfs.Film_IMDB_Score, '|') AS Target_Concact
            , rfh.Film_Hub_Key
        FROM rdv_film_hub rfh
        left join rdv_film_sat rfs
            on rfh.Film_Hub_Key = rfs.Film_Hub_Key
    ),
    source_table as (
        select
            COALESCE(sev.Film_Title, '|') || '|' ||
            COALESCE(sev.Film_Jaar, '|') || '|' ||
            COALESCE(sev.Film_Genres, '|') || '|' ||
            COALESCE(sev.Film_Tijdsduur_min, '|') || '|' ||
            COALESCE(sev.Genres_weging, '|') || '|' ||
            COALESCE(sev.Film_tags, '|') || '|' ||
            COALESCE(sev.Film_IMDB_Score, '|') AS Source_Concact
            , rfh.Film_Hub_Key
            , sev.Film_Title
            , sev.Film_Jaar
            , sev.Film_Genres
            , sev.Film_Tijdsduur_min
            , sev.Genres_weging
            , sev.Film_tags
            , sev.Film_IMDB_Score
        FROM rdv_film_hub rfh
        left join stg_excelsheet_vw sev
            on rfh.TT_Code_BK = sev.TT_Code
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
    from source_table st
    join target_table tt
        on st.Film_Hub_Key = tt.Film_Hub_Key
    where st.Source_Concact <> tt.Target_Concact
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
)
    with target_table as (
        select
        	rfl.Filmavond_Link_Key
            ,coalesce(rfs.Film_weekdag, '|') || '|' ||
            coalesce(rfs.Ind_Gezien, '|') || '|' ||
            coalesce(rfs.Aantal_Films, '|') || '|' ||
            coalesce(rfs.Aantal_Jaar, '|') || '|' ||
            coalesce(rfs.Aantal_Ronde, '|') AS Target_Concact
        from rdv_filmavond_link rfl
        left join rdv_filmavond_sat rfs
            on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
    ),
    source_table as (
		select
			  rfl.Filmavond_Link_Key
			, sev.Film_weekdag
		    , sev.Ind_Gezien
		    , sev.Aantal_Films
		    , sev.Aantal_Jaar
		    , sev.Aantal_Ronde
		    ,coalesce(sev.Film_weekdag, '|') || '|' ||
		    coalesce(sev.Ind_Gezien, '|') || '|' ||
		    coalesce(sev.Aantal_Films, '|') || '|' ||
		    coalesce(sev.Aantal_Jaar, '|') || '|' ||
		    coalesce(sev.Aantal_Ronde, '|') AS Source_Concact
	    from rdv_filmavond_link rfl
	    left join rdv_filmavond_sat rfs
	        on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
	    left join rdv_film_hub rfh
	    	on rfl.Filmavond_Link_Key = rfh.Film_Hub_Key
	    left join rdv_meister_hub rmh
	    	on rfl.Meister_Hub_Key = rmh.Meister_Hub_Key
	    left join stg_excelsheet_vw sev
	    	on sev.TT_Code = rfh.TT_Code_BK
	    	and sev.Meister = rmh.Meister_BK
    )
    select distinct
      st.Filmavond_Link_Key
    , st.Film_weekdag
    , st.Ind_Gezien
    , st.Aantal_Films
    , st.Aantal_Jaar
    , st.Aantal_Ronde
    , strftime('%Y-%m-%d %H:%M:%S', 'now') as Laaddatum
    from source_table st
    join target_table tt
        on st.Filmavond_Link_Key = tt.Filmavond_Link_Key
    where st.Source_Concact <> tt.Target_Concact
;
