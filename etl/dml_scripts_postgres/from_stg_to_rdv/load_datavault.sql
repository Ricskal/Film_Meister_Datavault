create or replace procedure stg.load_datavault(
    in p_datum_filmavond varchar,
    in p_meister varchar,
    in p_tt_code varchar,
    in p_film_title varchar,
    in p_film_jaar varchar,
    in p_film_genres varchar,
    in p_film_tijdsduur_min varchar,
    in p_ind_gezien varchar,
    in p_film_imdb_score varchar
)
language plpgsql
as $$
begin
    truncate table stg.filmavondsheet;
	raise notice 'Command: "truncate table stg.filmavondsheet" completed!';

    call stg.load_stage(
          p_datum_filmavond
        , p_meister
        , p_tt_code
        , p_film_title
        , p_film_jaar
        , p_film_genres
        , p_film_tijdsduur_min
        , p_ind_gezien
        , p_film_imdb_score
    );
	raise notice 'Command: "call stg.load_stage();" completed!';

    call stg.load_hubs();
	raise notice 'Command: "call stg.load_hubs()" completed!';

	call stg.load_links();
   	raise notice 'Command: "call stg.load_links();" completed!';
  
	call stg.load_sats();
	raise notice 'Command: "call stg.load_sats();" completed!';

	call stg.update_is_current();
	raise notice 'Command: "call stg.update_is_current();" completed!';

    call rdv.load_genre();
	raise notice 'Command: "call rdv.load_genre();" completed!';

	raise notice 'Command: "stg.load_datavault();" completed!';

end;
$$;