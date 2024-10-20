CREATE OR REPLACE PROCEDURE stg.load_sats()
LANGUAGE plpgsql
AS $$
BEGIN
	/* load from stg.filmavondsheet to rdv.film_sat */
	insert into rdv.film_sat (
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
	            upper(trim(coalesce(rfs.Film_Jaar::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Film_Genres, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Film_Tijdsduur_min::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Genres_weging::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Film_tags, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Film_IMDB_Score::varchar, '|'))) AS Target_Concact
	            , rfh.Film_Hub_Key
	            , case when rfs.Is_Current is null then 1 else rfs.Is_Current end as Is_Current
	        FROM rdv.film_hub rfh
	        left join rdv.film_sat rfs
	            on rfh.Film_Hub_Key = rfs.Film_Hub_Key
	    ),
	    source_table as (
	        select
	            upper(trim(coalesce(sfs.Film_Title, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Film_Jaar::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Film_Genres, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Film_Tijdsduur_min::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Genres_weging::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Film_tags, '|'))) || '|' ||
	            upper(trim(coalesce(sfs.Film_IMDB_Score::varchar, '|'))) AS Source_Concact
	            , rfh.Film_Hub_Key //werkt niet
	            , sfs.Film_Title
	            , sfs.Film_Jaar
	            , sfs.Film_Genres
	            , sfs.Film_Tijdsduur_min
	            , sfs.Genres_weging
	            , sfs.Film_tags
	            , sfs.Film_IMDB_Score
	        from rdv.film_hub rfh
	        left join stg.filmavondsheet sfs
	            on rfh.TT_Code_BK = upper(trim(coalesce(sfs.TT_Code, 'Onbekend')))
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
	    , cast(now() as timestamp) as Laaddatum
	    , 1 as Is_Current
	    from source_table st
	    join target_table tt
	        on st.Film_Hub_Key = tt.Film_Hub_Key
	    where st.Source_Concact <> tt.Target_Concact
	    and tt.Is_Current = 1
	;
	
	/* load from stg.filmavondsheet to rdv.filmavond_sat */
	insert into rdv.filmavond_sat (
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
	            upper(trim(coalesce(rfs.Aantal_Films::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Aantal_Jaar::varchar, '|'))) || '|' ||
	            upper(trim(coalesce(rfs.Aantal_Ronde::varchar, '|'))) AS Target_Concact
	        	, rfl.Filmavond_Link_Key
	            , case when rfs.Is_Current is null then 1 else rfs.Is_Current end as Is_Current
	        from rdv.filmavond_link rfl
	        left join rdv.filmavond_sat rfs
	            on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
	    ),
	    source_table as (
			select
			    upper(trim(coalesce(sfs.Film_weekdag, '|'))) || '|' ||
			    upper(trim(coalesce(sfs.Ind_Gezien, '|'))) || '|' ||
			    upper(trim(coalesce(sfs.Aantal_Films::varchar, '|'))) || '|' ||
			    upper(trim(coalesce(sfs.Aantal_Jaar::varchar, '|'))) || '|' ||
			    upper(trim(coalesce(sfs.Aantal_Ronde::varchar, '|'))) AS Source_Concact
			    , rfl.Filmavond_Link_Key
				, sfs.Film_weekdag
			    , sfs.Ind_Gezien
			    , sfs.Aantal_Films
			    , sfs.Aantal_Jaar
			    , sfs.Aantal_Ronde
		    from rdv.filmavond_link rfl
		    left join rdv.filmavond_sat rfs
		        on rfl.Filmavond_Link_Key = rfs.Filmavond_Link_Key
		    left join rdv.film_hub rfh
		    	on rfl.Filmavond_Link_Key = rfh.Film_Hub_Key
		    left join rdv.meister_hub rmh
		    	on rfl.Meister_Hub_Key = rmh.Meister_Hub_Key
		    left join stg.filmavondsheet sfs
		    	on upper(trim(coalesce(sfs.TT_Code, 'Onbekend'))) = rfh.TT_Code_BK
		    	and upper(trim(coalesce(sfs.Meister, 'Onbekend'))) = rmh.Meister_BK
	    )
	    select distinct
	      st.Filmavond_Link_Key
	    , st.Film_weekdag
	    , st.Ind_Gezien
	    , st.Aantal_Films
	    , st.Aantal_Jaar
	    , st.Aantal_Ronde
	    , cast(now() as timestamp) as Laaddatum
	    , 1 as Is_Current
	    from source_table st
	    join target_table tt
	        on st.Filmavond_Link_Key = tt.Filmavond_Link_Key
	    where st.Source_Concact <> tt.Target_Concact
	    and tt.Is_Current = 1
	;
END;
$$;
